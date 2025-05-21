from django.db import models
from django.contrib.auth.models import AbstractUser
from .managers import CustomUserManager
from django.core.validators import EmailValidator


class CustomUser(AbstractUser):
    # Override the fields to remove it
    first_name, last_name = None, None

    username = models.CharField(max_length=150)
    email = models.EmailField(verbose_name='email address', unique=True, validators=[EmailValidator()])

    USERNAME_FIELD = "email"
    EMAIL_FIELD = "email"
    REQUIRED_FIELDS = ['username']

    objects = CustomUserManager()

    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'

    def save(self, *args, **kwargs):
        self.username = self.username.capitalize()
        super().save(*args, **kwargs)

    def __str__(self):
        return self.username
