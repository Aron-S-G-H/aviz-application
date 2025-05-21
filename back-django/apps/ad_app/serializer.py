from rest_framework import serializers
from .models import Category, SubCategory, Aviz, AvizFacilities, AvizPoster
from jalali_date import datetime2jalali
from django.core.validators import FileExtensionValidator


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'
        read_only_fields = ('id',)


class SubCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = SubCategory
        fields = '__all__'
        read_only_fields = ('id',)


class AvizFacilitiesSerializer(serializers.ModelSerializer):
    class Meta:
        model = AvizFacilities
        fields = '__all__'
        read_only_fields = ('id',)


class AvizSerializer(serializers.ModelSerializer):
    poster_links = serializers.SerializerMethodField(source='posters')
    facilities = serializers.StringRelatedField(many=True)
    created_at = serializers.SerializerMethodField(source='created_at')
    category = SubCategorySerializer()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        context = kwargs.get('context', {})
        request = context.get('request')
        is_list = context.get('is_list')

        if request and request.method == 'GET' and is_list:
            allowed_fields = {'id', 'title', 'description', 'price', 'poster_links'}
            existing_fields = set(self.fields.keys())
            for field_name in existing_fields - allowed_fields:
                self.fields.pop(field_name)

    class Meta:
        model = Aviz
        fields = '__all__'
        read_only_fields = ('id', 'created_at', 'is_hot')

    def get_poster_links(self, obj):
        request = self.context.get('request')
        posters = obj.posters.all()
        posters_url = [request.build_absolute_uri(image.poster.url) for image in posters]
        return posters_url

    def get_created_at(self, obj):
        return datetime2jalali(obj.created_at).strftime('%Y/%m/%d - %H:%M')

    def validate_year_of_construction(self, year_of_construction):
        if year_of_construction < 1360 or year_of_construction > 1404:
            raise serializers.ValidationError('سال ساخت باید بین 1360 و 1404 باشد')
        return year_of_construction


class AvizPosterSerializer(serializers.ModelSerializer):
    poster = serializers.ImageField(
        validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png'])]
    )

    class Meta:
        model = AvizPoster
        fields = ['poster']

    def validate_poster(self, value):
        max_size = 5 * 1024 * 1024  # 5MB in bytes
        if value.size > max_size:
            raise serializers.ValidationError("Image size must not exceed 5MB.")
        return value

class CreateAvizSerializer(serializers.ModelSerializer):
    facilities = serializers.CharField(max_length=64, write_only=True)
    images = serializers.ListField(
        child=serializers.ImageField(validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png'])]),
        write_only=True,
        required=False
    )
    location = serializers.CharField(write_only=True)

    class Meta:
        model = Aviz
        fields = [
            'category', 'title', 'description', 'total_area', 'rooms', 'floor',
            'year_of_construction', 'price_per_meter', 'price', 'facilities',
            'is_location_allowed', 'chat_available', 'call_available', 'location',
            'images'
        ]

    def validate_category(self, value):
        if not SubCategory.objects.filter(id=value.id).exists():
            raise serializers.ValidationError("Invalid SubCategory ID.")
        return value

    def validate_title(self, value):
        if len(value) > 64:
            raise serializers.ValidationError("Title must not exceed 64 characters.")
        return value

    def validate_description(self, value):
        if len(value) > 1000:
            raise serializers.ValidationError('Description must not exceed 1000 characters.')
        return value

    def validate_total_area(self, value):
        if value <= 0 or value > 10000000:
            raise serializers.ValidationError("Total area must be a positive integer less than 10,000,000.")
        return value

    def validate_rooms(self, value):
        if value < 0 or value > 100:
            raise serializers.ValidationError("Number of rooms must be a positive integer less than 100.")
        return value

    def validate_floor(self, value):
        if value < 0 or value > 100:
            raise serializers.ValidationError("Floor must be a positive integer less than 100.")
        return value

    def validate_year_of_construction(self, value):
        if value < 1300 or value > 1405:
            raise serializers.ValidationError("Year of construction must be between 1300 and 1405.")
        return value

    def validate_facilities(self, value):
        if not value:
            raise serializers.ValidationError("At least one facility must be provided.")
        value = value.strip().split(',')
        for facility in value:
            if not AvizFacilities.objects.filter(title=facility).exists():
                raise serializers.ValidationError(f"Facility '{facility}' does not exist.")
        facilities_qs = AvizFacilities.objects.filter(title__in=value).all()
        return facilities_qs

    def validate_location(self, value):
        try:
            lat, lon = map(float, value.split(','))
            if not (-90 <= lat <= 90) or not (-180 <= lon <= 180):
                raise serializers.ValidationError("Invalid latitude or longitude values.")
            return {'latitude': lat, 'longitude': lon}
        except (ValueError, AttributeError):
            raise serializers.ValidationError("Location must be in the format 'latitude,longitude'.")

    def validate_images(self, value):
        max_images = 5
        if len(value) > max_images:
            raise serializers.ValidationError(f"Maximum {max_images} images allowed.")
        for image in value:
            max_size = 5 * 1024 * 1024  # 5MB in bytes
            if image.size > max_size:
                raise serializers.ValidationError("Each image size must not exceed 5MB.")
        return value

    def validate(self, data):
        price_per_meter = data.get('price_per_meter')
        price = data.get('price')
        if price_per_meter > price:
            raise serializers.ValidationError("Price per meter must not exceed price.")
        return data

    def to_internal_value(self, data):
        # Convert location to latitude and longitude
        location = data.get('location')
        if location:
            location_data = self.validate_location(location)
            data = data.copy()
            data['latitude'] = location_data['latitude']
            data['longitude'] = location_data['longitude']
        return super().to_internal_value(data)