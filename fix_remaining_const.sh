#!/bin/bash

# Fix all remaining invalid const errors where AppTheme colors are used

cd mobile/lib

echo "Fixing invalid const in SnackBar constructors..."
find . -name "*.dart" -type f -exec sed -i 's/const SnackBar(\([^)]*\)backgroundColor: AppTheme\./SnackBar(\1backgroundColor: AppTheme./g' {} \;

echo "Fixing invalid const in Container constructors with AppTheme..."
find . -name "*.dart" -type f -exec sed -i 's/const Container(\([^)]*\)color: AppTheme\./Container(\1color: AppTheme./g' {} \;

echo "Fixing invalid const in TextStyle constructors..."
find . -name "*.dart" -type f -exec sed -i 's/const TextStyle(\([^)]*\)color: AppTheme\./TextStyle(\1color: AppTheme./g' {} \;

echo "Fixing invalid const in BoxDecoration with AppTheme..."
find . -name "*.dart" -type f -exec sed -i 's/const BoxDecoration(\([^)]*\)color: AppTheme\./BoxDecoration(\1color: AppTheme./g' {} \;

echo "Fixing invalid const in Icon with AppTheme colors..."
find . -name "*.dart" -type f -exec sed -i 's/const Icon(\([^)]*\), color: AppTheme\./Icon(\1, color: AppTheme./g' {} \;

echo "Fixing patterns with 'const ' before constructors using AppTheme..."
# More specific patterns for remaining errors
find . -name "*.dart" -type f -exec perl -i -pe 's/const\s+(\w+)\(([^)]*AppTheme\.[^)]*)\)/$1($2)/g' {} \;

echo "Done fixing const errors!"
