from django.contrib.auth import authenticate
from django.core.validators import EmailValidator
from rest_framework import serializers
from .models import CustomUser


class BaseUserSerializer(serializers.ModelSerializer):
    def validate_username(self, value):
        if not value.isalpha():
            raise serializers.ValidationError('username must be alphanumeric')
        return value


class UserSerializer(BaseUserSerializer):
    class Meta:
        model = CustomUser
        exclude = ('user_permissions', 'groups')
        read_only_fields = ('id', 'is_active', 'is_staff', 'is_superuser', 'last_login', 'date_joined')
        extra_kwargs = {
            'password': {'write_only': True},
            'email': {'required': True},
            'username': {'required': True},
        }

    def validate_username(self, value):
        return super().validate_username(value)


class UserRegisterSerializer(BaseUserSerializer):
    confirm_password = serializers.CharField(max_length=128, required=True)

    class Meta:
        model = CustomUser
        fields = ('username', 'email', 'password', 'confirm_password')

    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        return user

    def validate_username(self, value):
        return super().validate_username(value)

    def validate(self, attrs):
        if attrs['password'] != attrs['confirm_password']:
            raise serializers.ValidationError({'detail': 'Password fields didnt match'})
        extra_fields = set(self.initial_data.keys()) - set(self.fields.keys())
        if extra_fields:
            raise serializers.ValidationError({'detail': f"فیلدهای نامعتبر: {', '.join(extra_fields)}"})
        return attrs

class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True, validators=[EmailValidator()])
    password = serializers.CharField(max_length=128, write_only=True, required=True)

    def validate(self, data):
        # بررسی فیلدهای اضافی
        extra_fields = set(self.initial_data.keys()) - set(self.fields.keys())
        if extra_fields:
            raise serializers.ValidationError({'detail': f"فیلدهای نامعتبر: {', '.join(extra_fields)}"})

        user = authenticate(email=data['email'], password=data['password'])
        if not user:
            raise serializers.ValidationError({"detail": "ایمیل یا رمز عبور نامعتبر است"})

        return user
