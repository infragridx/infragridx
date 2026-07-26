#!/bin/bash

echo "🚀 Backing up InfraGridX from Development..."

cd /var/www/infragridx

# Step 1: Fix git ownership
git config --global --add safe.directory /var/www/infragridx

# Step 2: Commit all changes
echo "📝 Committing changes..."
git add .
git commit -m "Backup: $(date +'%Y-%m-%d %H:%M:%S')"

# Step 3: Push to GitHub
echo "📤 Pushing to GitHub..."
git push origin main

# Step 4: Create tag
echo "🏷️ Creating backup tag..."
git tag -a "backup-$(date +'%Y%m%d')" -m "Backup on $(date +'%Y-%m-%d %H:%M:%S')"
git push origin --tags

# Step 5: Backup database
echo "🗄️ Backing up database..."
sudo -u postgres pg_dump infragridx_db | gzip > infragridx_db_$(date +'%Y%m%d').sql.gz

# Step 6: Backup media
echo "📁 Backing up media files..."
tar -czf media_backup_$(date +'%Y%m%d').tar.gz media/ 2>/dev/null || echo "No media directory"

# Step 7: Show backup files
echo ""
echo "✅ Backup complete!"
echo ""
echo "📋 Backup files created:"
ls -lh infragridx_db_*.sql.gz 2>/dev/null
ls -lh media_backup_*.tar.gz 2>/dev/null
echo ""
echo "📤 Pushed to GitHub: main branch + tags"
