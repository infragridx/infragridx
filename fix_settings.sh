#!/bin/bash

echo "🔧 Fixing settings.py and database connection..."

cd /var/www/infragridx

# Step 1: Fix settings.py
echo "Fixing settings.py..."
cat > infragridx/settings.py << 'EOF'
import os
from pathlib import Path
from decouple import config

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = config('SECRET_KEY', default='django-insecure-key')
DEBUG = config('DEBUG', default=False, cast=bool)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='localhost,127.0.0.1').split(',')

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.sitemaps',
    'django.contrib.sites',
    'crispy_forms',
    'crispy_bootstrap5',
    'ckeditor',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'core',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'allauth.account.middleware.AccountMiddleware',
]

ROOT_URLCONF = 'infragridx.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'core.context_processors.site_context',
            ],
        },
    },
]

WSGI_APPLICATION = 'infragridx.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME', default='infragridx_db'),
        'USER': config('DB_USER', default='infragridx_user'),
        'PASSWORD': config('DB_PASSWORD', default=''),
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

SITE_ID = 1

STATIC_URL = 'static/'
STATICFILES_DIRS = [BASE_DIR / 'static']
STATIC_ROOT = BASE_DIR / 'staticfiles'

MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

CRISPY_ALLOWED_TEMPLATE_PACKS = "bootstrap5"
CRISPY_TEMPLATE_PACK = "bootstrap5"

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = config('EMAIL_HOST', default='smtp.gmail.com')
EMAIL_PORT = config('EMAIL_PORT', default=587, cast=int)
EMAIL_USE_TLS = config('EMAIL_USE_TLS', default=True, cast=bool)
EMAIL_HOST_USER = config('EMAIL_HOST_USER', default='')
EMAIL_HOST_PASSWORD = config('EMAIL_HOST_PASSWORD', default='')
DEFAULT_FROM_EMAIL = config('DEFAULT_FROM_EMAIL', default='info@infragridx.com')
ADMIN_EMAIL = config('ADMIN_EMAIL', default='info@infragridx.com')
EOF

echo "✅ settings.py fixed"

# Step 2: Create proper .env file
echo "Creating .env file..."
cat > .env << 'EOF'
SECRET_KEY=django-insecure-key
DEBUG=False
ALLOWED_HOSTS=200.141.4.223,localhost,127.0.0.1
DB_NAME=infragridx_db
DB_USER=infragridx_user
DB_PASSWORD=InfraGridX@2024
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=info@infragridx.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=info@infragridx.com
ADMIN_EMAIL=info@infragridx.com
EOF

# Step 3: Reset PostgreSQL password
echo "Resetting PostgreSQL password..."
sudo -u postgres psql -c "ALTER USER infragridx_user WITH PASSWORD 'InfraGridX@2024';"

# Step 4: Verify database connection
echo "Verifying database connection..."
source venv/bin/activate
python -c "
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'infragridx.settings')
import django
django.setup()
from django.db import connection
connection.ensure_connection()
print('✅ Database connection successful!')
"

# Step 5: Run migrations
echo "Running migrations..."
python manage.py migrate

# Step 6: Restart Gunicorn
echo "Restarting Gunicorn..."
sudo systemctl restart gunicorn

# Step 7: Test website
echo ""
echo "Testing website..."
sleep 3
curl -I http://localhost/admin/ 2>/dev/null | head -3

SERVER_IP=$(hostname -I | awk '{print $1}')
echo ""
echo "✅ Fix complete!"
echo "🌐 Visit: http://$SERVER_IP/admin"
