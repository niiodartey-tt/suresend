#!/bin/bash

# Script to fix Flutter analyzer issues for Dart 3.9.2 and Flutter 3.35.7

cd mobile

echo "Fixing theme.dart..."
# Fix CardTheme -> CardThemeData
sed -i 's/cardTheme: CardTheme(/cardTheme: CardThemeData(/g' lib/config/theme.dart

# Fix DialogTheme -> DialogThemeData
sed -i 's/dialogTheme: DialogTheme(/dialogTheme: DialogThemeData(/g' lib/config/theme.dart

# Fix withOpacity -> withValues in theme.dart
sed -i 's/\.withOpacity(\([0-9.]*\))/\.withValues(alpha: \1)/g' lib/config/theme.dart

echo "Fixing withOpacity -> withValues in all Dart files..."
find lib -name "*.dart" -type f -exec sed -i 's/\.withOpacity(\([0-9.]*\))/\.withValues(alpha: \1)/g' {} \;

echo "Adding const to constructors in bottom_navigation.dart..."
sed -i 's/Border(/const Border(/g' lib/widgets/bottom_navigation.dart
sed -i 's/BorderSide(/const BorderSide(/g' lib/widgets/bottom_navigation.dart
sed -i 's/EdgeInsets\.zero/const EdgeInsets.zero/g' lib/widgets/bottom_navigation.dart

echo "Fixed withOpacity deprecated warnings across all files"
echo "Fixed type mismatches in theme.dart"
echo "Done!"
