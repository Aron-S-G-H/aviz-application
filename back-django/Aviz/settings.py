from pathlib import Path
import os
import logging

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'django-insecure-czeqyl+=2p+y6=fv)5xr!s09mhggzs&yft6yii35%-zhw9_ggx'

DEBUG = True

ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'jazzmin.apps.JazzminConfig',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # Third party
    'django_cleanup.apps.CleanupConfig',
    'rest_framework',
    'rest_framework_simplejwt',
    'drf_spectacular',
    'jalali_date',
    # My apps
    'apps.ad_app.apps.AdAppConfig',
    'apps.account_app.apps.AccountAppConfig',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'Aviz.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'Aviz.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

STATIC_URL = 'static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
MEDIA_URL = 'media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

AUTH_USER_MODEL = 'account_app.CustomUser'

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://localhost:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

INSTALLED_APPS += ['nplusone.ext.django']

MIDDLEWARE += ['nplusone.ext.django.NPlusOneMiddleware']
NPLUSONE_LOGGER = logging.getLogger('nplusone')
NPLUSONE_RAISE = False
NPLUSONE_LOG_LEVEL = logging.WARN
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
        },
    },
    "root": {
        "handlers": ["console"],
        "level": "INFO",
    },
    'nplusone': {
        'handlers': ['console'],
        'level': 'WARN',
    },
}

LOGGER = logging.getLogger("root")

# JAZZMIN ADMIN PANEL SETTING
from .custom_settings.jazzmin_setting import *

# REST-FRAMEWORK SETTING
from .custom_settings.rest_setting import *

# CELERY SETTING
from .custom_settings.celery_setting import *

# EMAIL SETTINGS
from .custom_settings.email_setting import *
