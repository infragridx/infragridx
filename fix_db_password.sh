#!/bin/bash

echo "🔧 Fixing PostgreSQL authentication..."

cd /var/www/infragridx

# Step 1: Generate new password
NEW_DB_PASSWORD=$(openssl rand -base64 20 | tr -d "=+/" | cut -c1-20)
echo "Generated new password: $NEW_DB_PASSWORD"

# Step 2: Update PostgreSQL user password
echo "Updating PostgreSQL password..."
sudo -u postgres psql -c "ALTER USER infragridx_user WITH PASSWORD '$NEW_DB_PASSWORD';"

# Step 3: Update .env file
echo "Updating .env file..."
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$NEW_DB_PASSWORD/" .env

# Step 4: Also update in settings.py if hardcoded
echo "Updating settings.py if needed..."
if grep -q "DB_PASSWORD.*config" infragridx/settings.py; then
    echo "Settings.py uses config from .env - OK"
else
    echo "Updating settings.py..."
    sed -i "s/PASSWORD.*=.*/PASSWORD = '$NEW_DB_PASSWORD',/" infragridx/settings.py
fi

# Step 5: Verify
echo ""
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

# Step 6: Restart Gunicorn
echo "Restarting Gunicorn..."
sudo systemctl restart gunicorn

# Step 7: Test website
echo ""
echo "Testing website..."
sleep 2
curl -I http://localhost/admin/ 2>/dev/null | head -3

SERVER_IP=$(hostname -I | awk '{print $1}')
echo ""
echo "✅ Fix complete!"
echo "🌐 Visit: http://$SERVER_IP/admin"
