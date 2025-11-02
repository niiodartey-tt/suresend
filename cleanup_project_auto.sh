#!/bin/bash

# SureSend Project Cleanup Script (Automated - No prompts)
# This script removes documentation, guides, and reference files
# Use this for automated cleanup without user interaction

PROJECT_ROOT="/home/user/suresend"

echo "Starting automated cleanup..."

# Delete all .md files
find "$PROJECT_ROOT" -type f -name "*.md" -delete 2>/dev/null

# Delete docs folder
rm -rf "$PROJECT_ROOT/docs" 2>/dev/null

# Delete ui_references folder
rm -rf "$PROJECT_ROOT/mobile/assets/ui_references" 2>/dev/null

# Delete figma attribution and guidelines
find "$PROJECT_ROOT/mobile/assets/figma" -type f -name "*.md" -delete 2>/dev/null
find "$PROJECT_ROOT/mobile/assets/figma" -type d -name "guidelines" -exec rm -rf {} + 2>/dev/null

# Delete .gitkeep files
find "$PROJECT_ROOT" -type f -name ".gitkeep" -delete 2>/dev/null

# Delete ui_references.txt if exists
find "$PROJECT_ROOT" -type f -name "ui_references.txt" -delete 2>/dev/null

# Delete test documentation
find "$PROJECT_ROOT/backend/tests" -type f -name "*.md" -delete 2>/dev/null

# Delete empty directories
find "$PROJECT_ROOT" -type d -empty -delete 2>/dev/null

echo "✓ Cleanup completed!"
