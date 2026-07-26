#!/bin/bash

echo "🚀 Starting full backup of InfraGridX (Dev → GitHub)..."
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Step 1: Check git status
echo -e "${BLUE}[1/6] Checking git status...${NC}"
git status

# Step 2: Add all changes
echo -e "${BLUE}[2/6] Adding all changes...${NC}"
git add .

# Step 3: Commit changes
echo -e "${BLUE}[3/6] Committing changes...${NC}"
COMMIT_MSG="Backup: $(date +'%Y-%m-%d %H:%M:%S') - Dev Server"
git commit -m "$COMMIT_MSG"

# Step 4: Push to GitHub
echo -e "${BLUE}[4/6] Pushing to GitHub...${NC}"
git push origin main

# Step 5: Create backup tag
echo -e "${BLUE}[5/6] Creating backup tag...${NC}"
TAG_NAME="backup-$(date +'%Y%m%d_%H%M%S')"
git tag -a "$TAG_NAME" -m "Full backup from Dev server on $(date +'%Y-%m-%d %H:%M:%S')"
git push origin "$TAG_NAME"

# Step 6: Database backup (optional - only if you want to commit it)
echo -e "${BLUE}[6/6] Backing up database...${NC}"
DB_BACKUP="infragridx_db_$(date +'%Y%m%d_%H%M%S').sql.gz"
sudo -u postgres pg_dump infragridx_db | gzip > "/tmp/$DB_BACKUP"
mv "/tmp/$DB_BACKUP" .
echo -e "${GREEN}✅ Database backup created: $DB_BACKUP${NC}"

echo ""
echo -e "${GREEN}✅ Backup complete!${NC}"
echo ""
echo "📋 Backup Summary:"
echo "  ✅ Code: Pushed to GitHub (main branch)"
echo "  ✅ Tag: $TAG_NAME"
echo "  ✅ Database: $DB_BACKUP"
echo "  🔗 GitHub: https://github.com/infragridx/infragridx"
echo ""
echo "🌐 Next: Restore on production server"
