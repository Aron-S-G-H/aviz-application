from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator

class Category(models.Model):
    title = models.CharField(max_length=50, help_text='50 Characters allowed', unique=True)

    class Meta:
        verbose_name = 'Category'
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.title


class SubCategory(models.Model):
    title = models.CharField(max_length=50, help_text='50 Characters allowed')
    general_category = models.ForeignKey(Category, related_name='subs', on_delete=models.CASCADE)
    parent_category = models.ForeignKey('self', related_name='subs', on_delete=models.CASCADE, null=True, blank=True)

    class Meta:
        verbose_name = 'Sub Category'
        verbose_name_plural = 'Sub Categories'

    def __str__(self):
        return f'{self.title} - {self.general_category.title}'


class AvizFacilities(models.Model):
    title = models.CharField(max_length=64, help_text='64 Characters allowed')

    def __str__(self):
        return self.title


class Aviz(models.Model):
    category = models.ForeignKey(SubCategory, on_delete=models.CASCADE, related_name='avizs')
    title = models.CharField(max_length=64, help_text='64 Characters allowed')
    description = models.TextField(null=True, blank=True, max_length=1000, help_text='1000 Characters allowed')
    total_area = models.PositiveIntegerField(
        validators=[MaxValueValidator(10000000, message='Total area must be a positive integer less than 10,000,000.')]
    )
    rooms = models.PositiveSmallIntegerField(
        validators=[MaxValueValidator(100, message='Number of rooms must be a positive integer less than 100')]
    )
    floor = models.PositiveSmallIntegerField(
        validators=[MaxValueValidator(100, message='Number of floor must be a positive integer less than 100')]
    )
    year_of_construction = models.PositiveSmallIntegerField(
        validators=[
            MaxValueValidator(1405, message='year of construction must be less than 1406'),
            MinValueValidator(1300, message='year of construction must be greater than 1300')
        ]
    )
    price_per_meter = models.PositiveIntegerField()
    price = models.PositiveBigIntegerField()
    facilities = models.ManyToManyField(AvizFacilities)
    latitude = models.FloatField(default=0.0)
    longitude = models.FloatField(default=0.0)
    is_hot = models.BooleanField(default=False)
    is_location_allowed = models.BooleanField(default=True)
    chat_available = models.BooleanField(default=True)
    call_available = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Aviz'
        verbose_name_plural = 'Avizs'
        ordering = ['-created_at']

    def __str__(self):
        return self.title


class AvizPoster(models.Model):
    aviz = models.ForeignKey(Aviz, on_delete=models.CASCADE, related_name='posters')
    poster = models.ImageField(upload_to='posters', width_field='poster_width', height_field='poster_height')
    poster_width = models.PositiveSmallIntegerField(null=True, blank=True)
    poster_height = models.PositiveSmallIntegerField(null=True, blank=True)
    size = models.FloatField(blank=True, help_text='in kilobytes')

    def save(self, *args, **kwargs):
        self.size = self.poster.size / 1000
        super(AvizPoster, self).save(*args, **kwargs)

    def __str__(self):
        return self.aviz.title
