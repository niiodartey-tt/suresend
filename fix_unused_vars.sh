#!/bin/bash

cd mobile/lib

echo "Commenting out unused _storageService in auth_provider.dart..."
sed -i 's/^  final StorageService _storageService = StorageService();$/  \/\/ Unused: final StorageService _storageService = StorageService();/' providers/auth_provider.dart

echo "Commenting out unused fields in unified_dashboard.dart (if truly unused)..."
# These might be used for future error handling, so just comment them
sed -i 's/^  bool _hasError = false;$/  \/\/ TODO: Use for error handling - bool _hasError = false;/' screens/dashboard/unified_dashboard.dart
sed -i 's/^  String _errorMessage = '';$/  \/\/ TODO: Use for error handling - String _errorMessage = '\'''\'';/' screens/dashboard/unified_dashboard.dart

echo "Commenting out assignments to unused fields..."
sed -i 's/^        _hasError = false;$/        \/\/ _hasError = false;/' screens/dashboard/unified_dashboard.dart
sed -i 's/^        _errorMessage = '';$/        \/\/ _errorMessage = '\'''\'';/' screens/dashboard/unified_dashboard.dart
sed -i 's/^          _hasError = false;$/          \/\/ _hasError = false;/' screens/dashboard/unified_dashboard.dart
sed -i 's/^          _hasError = true;$/          \/\/ _hasError = true;/' screens/dashboard/unified_dashboard.dart
sed -i 's/^          _errorMessage = e.toString();$/          \/\/ _errorMessage = e.toString();/' screens/dashboard/unified_dashboard.dart

echo "Commenting out unused _buildEmptyState method..."
sed -i 's/^  Widget _buildEmptyState() {$/  \/\/ Unused method - can be removed or used later\n  \/\/ Widget _buildEmptyState() {/' screens/notifications/notification_screen.dart

echo "Fixing unused result variable in auth_service.dart line 168..."
sed -i '168s/final result = /\/_unused_\/ /' services/auth_service.dart

echo "Done fixing unused variables!"
