#!/bin/bash

echo "🚀 Restoring InfraGridX from GitHub (Prod)..."
echo "==============================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Step 1: Pull latest code
echo -e "${BLUE}[1/8] Pulling latest code from GitHub...${NC}"
git pull origin main

# Step 2: Checkout specific tag if provided
if [ -n "$1" ]; then
    echo -e "${BLUE}[2/8] Checking out tag: $1${NC}"
    git checkout $1
else
    echo -e "${BLUE}[2/8] Using latest main branch${NC}"
fi

# Step 3: Setup Python virtual environment
echo -e "${BLUE}[3/8] Setting up Python environment...${NC}"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn whitenoise psycopg2-binary

# Step 4: Install PostgreSQL dependencies (Ubuntu 24.04)
echo -e "${BLUE}[4/8] Installing PostgreSQL dependencies...${NC}"
sudo apt update
sudo apt install -y postgresql postgresql-contrib libpq-dev

# Step 5: Setup database
echo -e "${BLUE}[5/8] Setting up database...${NC}"
sudo -u postgres psql << 'SQL'
CREATE DATABASE IF NOT EXISTS infragridx_db;
CREATE USER IF NOT EXISTS infragridx_user WITH PASSWORD 'YourSecurePasswordHere!';
GRANT ALL PRIVILEGES ON DATABASE infragridx_db TO infragridx_user;
ALTER USER infragridx_user CREATEDB;
\q
SQL

# Step 6: Restore database backup if exists
echo -e "${BLUE}[6/8] Restoring database...${NC}"
if [ -f infragridx_db_*.sql.gz ]; then
    DB_FILE=$(ls infragridx_db_*.sql.gz | head -1)
    gunzip -c $DB_FILE | sudo -u postgres psql -d infragridx_db
    echo -e "${GREEN}✅ Database restored from: $DB_FILE${NC}"
else
    echo -e "${YELLOW}ℹ️  No database backup found. Running migrations...${NC}"
    python manage.py makemigrations
    python manage.py migrate
fi

# Step 7: Create .env file
echo -e "${BLUE}[7/8] Creating .env file...${NC}"
if [ ! -f .env ]; then
    cat > .env << 'ENVEOF'
SECRET_KEY=$(python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
DEBUG=False
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com,YOUR_PRODUCTION_IP
DB_NAME=infragridx_db
DB_USER=infragridx_user
DB_PASSWORD=YourSecurePasswordHere!
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=info@infragridx.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=info@infragridx.com
ADMIN_EMAIL=info@infragridx.com
ENVEOF
fi

# Step 8: Finalize
echo -e "${BLUE}[8/8] Finalizing deployment...${NC}"
python manage.py collectstatic --noinput
python manage.py createsuperuser

# Set permissions
sudo chown -R www-data:www-data /var/www/infragridx
sudo chmod -R 755 /var/www/infragridx

echo ""
echo -e "${GREEN}✅ Restore complete!${NC}"
echo ""
echo "🌐 Visit: http://YOUR_PRODUCTION_IP"
echo "🔑 Admin: http://YOUR_PRODUCTION_IP/admin"
echo ""
echo "📋 Next steps:"
echo "  1. Configure Gunicorn: sudo systemctl enable gunicorn"
echo "  2. Configure Nginx: sudo systemctl enable nginx"
echo "  3. Update .env file with production settings"
