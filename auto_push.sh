#!/bin/bash
# Auto-push script - run this to sync with GitHub

cd /mnt/user-data/outputs/roseglass-repo

# Add any new files
git add .

# Check if there are changes
if git diff --staged --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Commit with timestamp
git commit -m "📦 Batch update: $(date '+%Y-%m-%d %H:%M:%S')

Auto-committed by processing script"

# Push to GitHub
git push origin main

echo "✅ Pushed to GitHub!"
