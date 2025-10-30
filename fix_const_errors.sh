#!/bin/bash

# Fix invalid const value errors where AppTheme colors are used

cd mobile/lib

# Pattern: const Something(color: AppTheme.xxx) -> Something(color: AppTheme.xxx)
# We need to remove 'const' before constructors that use AppTheme colors

echo "Fixing invalid const errors in screen files..."

# For TextStyle with AppTheme colors
find . -name "*.dart" -type f -exec sed -i 's/const TextStyle(\([^)]*AppTheme\.[^)]*\))/TextStyle(\1)/g' {} \;

# For Container/BoxDecoration with AppTheme colors
find . -name "*.dart" -type f -exec sed -i 's/const BoxDecoration(\([^)]*AppTheme\.[^)]*\))/BoxDecoration(\1)/g' {} \;
find . -name "*.dart" -type f -exec sed -i 's/const Container(\([^)]*AppTheme\.[^)]*\))/Container(\1)/g' {} \;

# For Icon with AppTheme colors
find . -name "*.dart" -type f -exec sed -i 's/const Icon(\([^,]*\), color: AppTheme\./Icon(\1, color: AppTheme./g' {} \;

# For EdgeInsets and specific patterns
find . -name "*.dart" -type f -exec sed -i 's/const EdgeInsets\.zero,$/EdgeInsets.zero,/g' {} \;

echo "Fixing specific invalid const patterns..."

# Fix patterns like: const Color(AppTheme.xxx)
find . -name "*.dart" -type f -exec sed -i 's/const Color(AppTheme\./Color(AppTheme./g' {} \;

# Fix Icon patterns
find . -name "*.dart" -type f -exec sed -i 's/const Icon(\([^,)]*\), *size: *\([0-9]*\), *color: AppTheme\./Icon(\1, size: \2, color: AppTheme./g' {} \;

# Remove duplicate const keywords that might have been introduced
find . -name "*.dart" -type f -exec sed -i 's/const const /const /g' {} \;

echo "Done fixing invalid const errors!"
