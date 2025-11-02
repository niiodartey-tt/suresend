#!/bin/bash

# SureSend Project Cleanup Script
# This script removes documentation, guides, and reference files
# while keeping only core functional code and necessary assets

set -e

PROJECT_ROOT="/home/user/suresend"
BACKUP_DIR="/tmp/suresend_backup_$(date +%Y%m%d_%H%M%S)"

echo "================================================"
echo "SureSend Project Cleanup Script"
echo "================================================"
echo ""
echo "This script will remove the following types of files:"
echo "  ✗ All .md files (README, guides, documentation)"
echo "  ✗ docs/ folder"
echo "  ✗ ui_references/ folder"
echo "  ✗ Test documentation"
echo "  ✗ Figma attribution files"
echo "  ✗ CHANGELOG files"
echo "  ✗ .gitkeep files"
echo ""
echo "The following will be KEPT:"
echo "  ✓ Source code (.dart, .js, .ts, etc.)"
echo "  ✓ Configuration files (pubspec.yaml, package.json, etc.)"
echo "  ✓ App assets (icons, fonts)"
echo "  ✓ Build configurations"
echo "  ✓ Database files"
echo "  ✓ .git folder"
echo ""

# Function to count files that will be deleted
count_files() {
    local count=0

    # Count .md files
    count=$((count + $(find "$PROJECT_ROOT" -type f -name "*.md" 2>/dev/null | wc -l)))

    # Count docs folder files
    if [ -d "$PROJECT_ROOT/docs" ]; then
        count=$((count + $(find "$PROJECT_ROOT/docs" -type f 2>/dev/null | wc -l)))
    fi

    # Count ui_references files
    if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
        count=$((count + $(find "$PROJECT_ROOT/mobile/assets/ui_references" -type f 2>/dev/null | wc -l)))
    fi

    # Count figma attribution files
    count=$((count + $(find "$PROJECT_ROOT/mobile/assets/figma" -type f -name "*.md" 2>/dev/null | wc -l)))

    # Count .gitkeep files
    count=$((count + $(find "$PROJECT_ROOT" -type f -name ".gitkeep" 2>/dev/null | wc -l)))

    echo $count
}

# Count files to be deleted
TOTAL_FILES=$(count_files)

echo "Total files to be removed: $TOTAL_FILES"
echo ""

# Show preview of files to be deleted
echo "Preview of files that will be deleted:"
echo "----------------------------------------"

# Show first 20 .md files
echo ""
echo "Documentation files (.md):"
find "$PROJECT_ROOT" -type f -name "*.md" 2>/dev/null | head -20
MD_COUNT=$(find "$PROJECT_ROOT" -type f -name "*.md" 2>/dev/null | wc -l)
if [ $MD_COUNT -gt 20 ]; then
    echo "... and $((MD_COUNT - 20)) more .md files"
fi

# Show docs folder
echo ""
if [ -d "$PROJECT_ROOT/docs" ]; then
    echo "docs/ folder:"
    ls -la "$PROJECT_ROOT/docs/" | head -10
fi

# Show ui_references folder
echo ""
if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
    echo "ui_references/ folder:"
    ls -la "$PROJECT_ROOT/mobile/assets/ui_references/" | head -10
fi

echo ""
echo "----------------------------------------"
echo ""

# Ask for confirmation
read -p "Do you want to create a backup before deletion? (recommended) [Y/n]: " CREATE_BACKUP
CREATE_BACKUP=${CREATE_BACKUP:-Y}

if [[ $CREATE_BACKUP =~ ^[Yy]$ ]]; then
    echo ""
    echo "Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    # Backup all files that will be deleted
    echo "Backing up files..."

    # Backup .md files
    find "$PROJECT_ROOT" -type f -name "*.md" 2>/dev/null | while read file; do
        rel_path="${file#$PROJECT_ROOT/}"
        backup_file="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_file")"
        cp "$file" "$backup_file" 2>/dev/null || true
    done

    # Backup docs folder
    if [ -d "$PROJECT_ROOT/docs" ]; then
        cp -r "$PROJECT_ROOT/docs" "$BACKUP_DIR/" 2>/dev/null || true
    fi

    # Backup ui_references folder
    if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
        mkdir -p "$BACKUP_DIR/mobile/assets"
        cp -r "$PROJECT_ROOT/mobile/assets/ui_references" "$BACKUP_DIR/mobile/assets/" 2>/dev/null || true
    fi

    echo "✓ Backup created successfully!"
    echo ""
fi

read -p "Proceed with deletion? This cannot be undone (except from backup). [y/N]: " CONFIRM
CONFIRM=${CONFIRM:-N}

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo ""
    echo "Cleanup cancelled. No files were deleted."
    exit 0
fi

echo ""
echo "Starting cleanup..."
echo ""

# Delete all .md files
echo "→ Removing .md files..."
find "$PROJECT_ROOT" -type f -name "*.md" -delete 2>/dev/null || true

# Delete docs folder
if [ -d "$PROJECT_ROOT/docs" ]; then
    echo "→ Removing docs/ folder..."
    rm -rf "$PROJECT_ROOT/docs"
fi

# Delete ui_references folder
if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
    echo "→ Removing ui_references/ folder..."
    rm -rf "$PROJECT_ROOT/mobile/assets/ui_references"
fi

# Delete figma attribution and guidelines
if [ -d "$PROJECT_ROOT/mobile/assets/figma" ]; then
    echo "→ Removing Figma attribution files..."
    find "$PROJECT_ROOT/mobile/assets/figma" -type f -name "*.md" -delete 2>/dev/null || true
    find "$PROJECT_ROOT/mobile/assets/figma" -type d -name "guidelines" -exec rm -rf {} + 2>/dev/null || true
fi

# Delete .gitkeep files
echo "→ Removing .gitkeep files..."
find "$PROJECT_ROOT" -type f -name ".gitkeep" -delete 2>/dev/null || true

# Delete any remaining guide/instruction files
echo "→ Removing guide and instruction files..."
find "$PROJECT_ROOT" -type f -iname "*guide*" -iname "*.txt" -delete 2>/dev/null || true
find "$PROJECT_ROOT" -type f -iname "*instruction*" -delete 2>/dev/null || true
find "$PROJECT_ROOT" -type f -name "ui_references.txt" -delete 2>/dev/null || true

# Delete test documentation
echo "→ Removing test documentation..."
find "$PROJECT_ROOT/backend/tests" -type f -name "*.md" -delete 2>/dev/null || true

# Delete empty directories
echo "→ Removing empty directories..."
find "$PROJECT_ROOT" -type d -empty -delete 2>/dev/null || true

echo ""
echo "================================================"
echo "✓ Cleanup completed successfully!"
echo "================================================"
echo ""

# Show summary
echo "Summary:"
echo "  • Removed $TOTAL_FILES files"
if [[ $CREATE_BACKUP =~ ^[Yy]$ ]]; then
    echo "  • Backup location: $BACKUP_DIR"
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    echo "  • Backup size: $BACKUP_SIZE"
fi
echo ""

# Show remaining project structure
echo "Remaining project structure:"
echo "----------------------------"
du -h --max-depth=2 "$PROJECT_ROOT" 2>/dev/null | sort -hr | head -15

echo ""
echo "✓ Project cleaned! Only core functional files remain."
echo ""

if [[ $CREATE_BACKUP =~ ^[Yy]$ ]]; then
    echo "Note: You can restore files from backup at: $BACKUP_DIR"
    echo "To restore: cp -r $BACKUP_DIR/* $PROJECT_ROOT/"
fi

echo ""
