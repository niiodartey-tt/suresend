#!/bin/bash

# SureSend Project Cleanup Preview Script
# Shows what will be deleted WITHOUT actually deleting anything

PROJECT_ROOT="/home/user/suresend"

echo "================================================"
echo "SureSend Project Cleanup Preview"
echo "================================================"
echo ""
echo "The following files and folders will be DELETED:"
echo ""

# Count and show .md files
MD_COUNT=$(find "$PROJECT_ROOT" -type f -name "*.md" 2>/dev/null | wc -l)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Documentation files (.md): $MD_COUNT files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
find "$PROJECT_ROOT" -type f -name "*.md" 2>/dev/null | sed 's|/home/user/suresend/||' | sort

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. docs/ folder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -d "$PROJECT_ROOT/docs" ]; then
    DOCS_COUNT=$(find "$PROJECT_ROOT/docs" -type f 2>/dev/null | wc -l)
    echo "   Contains $DOCS_COUNT files"
    find "$PROJECT_ROOT/docs" -type f 2>/dev/null | sed 's|/home/user/suresend/||' | sort
else
    echo "   (Not found)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. ui_references/ folder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
    UI_REF_COUNT=$(find "$PROJECT_ROOT/mobile/assets/ui_references" -type f 2>/dev/null | wc -l)
    UI_REF_SIZE=$(du -sh "$PROJECT_ROOT/mobile/assets/ui_references" 2>/dev/null | cut -f1)
    echo "   Contains $UI_REF_COUNT files ($UI_REF_SIZE)"
    find "$PROJECT_ROOT/mobile/assets/ui_references" -type f 2>/dev/null | sed 's|/home/user/suresend/||' | sort | head -20
    if [ $UI_REF_COUNT -gt 20 ]; then
        echo "   ... and $((UI_REF_COUNT - 20)) more files"
    fi
else
    echo "   (Not found)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Figma attribution files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
FIGMA_MD_COUNT=$(find "$PROJECT_ROOT/mobile/assets/figma" -type f -name "*.md" 2>/dev/null | wc -l)
if [ $FIGMA_MD_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT/mobile/assets/figma" -type f -name "*.md" 2>/dev/null | sed 's|/home/user/suresend/||'
else
    echo "   (None found)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Other files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# .gitkeep files
GITKEEP_COUNT=$(find "$PROJECT_ROOT" -type f -name ".gitkeep" 2>/dev/null | wc -l)
echo "   .gitkeep files: $GITKEEP_COUNT"
if [ $GITKEEP_COUNT -gt 0 ]; then
    find "$PROJECT_ROOT" -type f -name ".gitkeep" 2>/dev/null | sed 's|/home/user/suresend/||' | head -10
fi

# ui_references.txt
if [ -f "$PROJECT_ROOT/mobile/assets/ui_references.txt" ]; then
    echo "   mobile/assets/ui_references.txt"
fi

echo ""
echo "================================================"
echo "SUMMARY"
echo "================================================"

TOTAL_FILES=0

# Count all files to be deleted
TOTAL_FILES=$((TOTAL_FILES + MD_COUNT))

if [ -d "$PROJECT_ROOT/docs" ]; then
    TOTAL_FILES=$((TOTAL_FILES + $(find "$PROJECT_ROOT/docs" -type f 2>/dev/null | wc -l)))
fi

if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
    TOTAL_FILES=$((TOTAL_FILES + $(find "$PROJECT_ROOT/mobile/assets/ui_references" -type f 2>/dev/null | wc -l)))
fi

TOTAL_FILES=$((TOTAL_FILES + FIGMA_MD_COUNT + GITKEEP_COUNT))

echo ""
echo "Total files to be deleted: $TOTAL_FILES"
echo ""

# Calculate total size
TOTAL_SIZE=0
if [ -d "$PROJECT_ROOT/docs" ]; then
    TOTAL_SIZE=$((TOTAL_SIZE + $(du -sb "$PROJECT_ROOT/docs" 2>/dev/null | cut -f1)))
fi
if [ -d "$PROJECT_ROOT/mobile/assets/ui_references" ]; then
    TOTAL_SIZE=$((TOTAL_SIZE + $(du -sb "$PROJECT_ROOT/mobile/assets/ui_references" 2>/dev/null | cut -f1)))
fi

TOTAL_SIZE_MB=$((TOTAL_SIZE / 1024 / 1024))
echo "Total size to be freed: ~${TOTAL_SIZE_MB}MB"

echo ""
echo "================================================"
echo ""
echo "To proceed with cleanup, run:"
echo "  ./cleanup_project.sh         (interactive with backup)"
echo "  ./cleanup_project_auto.sh    (automatic, no backup)"
echo ""
