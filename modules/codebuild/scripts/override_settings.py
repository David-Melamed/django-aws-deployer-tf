import os
from django.conf import settings

route53_domain = os.environ.get('ROUTE53_DOMAIN')

CSRF_TRUSTED_ORIGINS = [route53_domain]
ALLOWED_HOSTS = ["*"]
CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
CORS_ORIGIN_WHITELIST = [
    'http://127.0.0.1:9090',
    'http://localhost:9090',
    'http://127.0.0.1:8080',
    'http://localhost:8080',
    f'{route53_domain}'
]
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ  .get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': os.environ.get('DB_PORT')
    }
}
DJANGO_SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')

settings.ALLOWED_HOSTS = ALLOWED_HOSTS
settings.CORS_ALLOW_CREDENTIALS = CORS_ALLOW_CREDENTIALS
settings.CORS_ORIGIN_ALLOW_ALL = CORS_ORIGIN_ALLOW_ALL
settings.CORS_ORIGIN_WHITELIST = CORS_ORIGIN_WHITELIST
settings.DATABASES = DATABASES
settings.CSRF_TRUSTED_ORIGINS = CSRF_TRUSTED_ORIGINS
settings.DJANGO_SECRET_KEY = DJANGO_SECRET_KEY