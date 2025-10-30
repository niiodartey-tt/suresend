#!/bin/bash

# Fix all const errors with AppTheme properties

cd /home/user/suresend/mobile

# Function to remove const from widgets using AppTheme properties
fix_const_in_file() {
    local file="$1"
    echo "Fixing $file..."

    # Remove const from Icon widgets with AppTheme
    perl -i -0777 -pe 's/const Icon\(\s*([^)]+),\s*([^)]*AppTheme\.[^)]+)\)/Icon\(\n                  $1,\n                  $2\)/gs' "$file"

    # Remove const from Text widgets with TextStyle containing AppTheme
    perl -i -0777 -pe 's/const Text\(\s*([^,]+),\s*style:\s*const TextStyle\(([^)]*AppTheme\.[^)]+)\)/Text\(\n                  $1,\n                  style: TextStyle\($2\)/gs' "$file"

    # Remove const from Expanded containing AppTheme
    perl -i -0777 -pe 's/const Expanded\(((?:(?!const Expanded).)*?AppTheme\..*?)\)/Expanded\($1\)/gs' "$file"

    # Remove const from Padding containing AppTheme
    perl -i -0777 -pe 's/const Padding\(((?:(?!const Padding).)*?AppTheme\..*?)\)/Padding\($1\)/gs' "$file"

    # Remove const from Center containing AppTheme
    perl -i -0777 -pe 's/const Center\(((?:(?!const Center).)*?AppTheme\..*?)\)/Center\($1\)/gs' "$file"

    # Remove const from CircularProgressIndicator with AppTheme
    perl -i -0777 -pe 's/const CircularProgressIndicator\(\s*([^)]*AppTheme\.[^)]+)\)/CircularProgressIndicator\(\n                  $1\)/gs' "$file"
}

# Fix all files with const errors
fix_const_in_file "lib/screens/dashboard/unified_dashboard.dart"
fix_const_in_file "lib/screens/dashboard/rider_dashboard.dart"
fix_const_in_file "lib/screens/notifications/notification_screen.dart"
fix_const_in_file "lib/screens/wallet/fund_wallet_screen.dart"
fix_const_in_file "lib/screens/wallet/withdraw_funds_screen.dart"
fix_const_in_file "lib/screens/wallet/transfer_money_screen.dart"
fix_const_in_file "lib/widgets/error_retry_widget.dart"
fix_const_in_file "lib/screens/transactions/transaction_success_screen.dart"

echo "Done fixing all const errors!"
