import 'package:flutter/material.dart';
import 'package:suresend/screens/auth/login_screen.dart';
import 'package:suresend/screens/home/home_screen.dart';
import 'package:suresend/screens/dashboard/dashboard_screen.dart';
import 'package:suresend/screens/transactions/buy_transaction_screen.dart';
import 'package:suresend/screens/transactions/sell_transaction_screen.dart';
import 'package:suresend/screens/transactions/transaction_detail_screen.dart';
import 'package:suresend/screens/transactions/transaction_list_screen.dart';
import 'package:suresend/screens/wallet/fund_wallet_screen.dart';
import 'package:suresend/screens/wallet/withdraw_funds_screen.dart';
import 'package:suresend/screens/settings/settings_screen.dart';
import 'package:suresend/screens/profile/profile_screen.dart';
import 'package:suresend/screens/deals/deals_screen.dart';
import 'package:suresend/screens/notifications/notification_screen.dart';
import 'package:suresend/screens/success/transaction_successful_screen.dart';
import 'package:suresend/screens/success/escrow_created_success_screen.dart';
import 'package:suresend/screens/success/withdrawal_success_screen.dart';

/// App route names
class AppRoutes {
  // Auth routes
  static const String login = '/login';

  // Main routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Transaction routes
  static const String buyTransaction = '/transaction/buy';
  static const String sellTransaction = '/transaction/sell';
  static const String transactionDetail = '/transaction/detail';
  static const String transactionList = '/transaction/list';

  // Wallet routes
  static const String fundWallet = '/wallet/fund';
  static const String withdrawFunds = '/wallet/withdraw';

  // Other routes
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String deals = '/deals';
  static const String notifications = '/notifications';

  // Success routes
  static const String transactionSuccess = '/success/transaction';
  static const String escrowCreatedSuccess = '/success/escrow';
  static const String withdrawalSuccess = '/success/withdrawal';
}

/// Route generator for the app
class AppRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments
    final args = settings.arguments;

    switch (settings.name) {
      // Auth routes
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      // Main routes
      case AppRoutes.home:
        final index = args as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(initialIndex: index),
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      // Transaction routes
      case AppRoutes.buyTransaction:
        return MaterialPageRoute(builder: (_) => const BuyTransactionScreen());

      case AppRoutes.sellTransaction:
        return MaterialPageRoute(builder: (_) => const SellTransactionScreen());

      case AppRoutes.transactionDetail:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => TransactionDetailScreen(transactionId: args),
          );
        }
        return _errorRoute('Transaction ID is required');

      case AppRoutes.transactionList:
        return MaterialPageRoute(builder: (_) => const TransactionListScreen());

      // Wallet routes
      case AppRoutes.fundWallet:
        return MaterialPageRoute(builder: (_) => const FundWalletScreen());

      case AppRoutes.withdrawFunds:
        return MaterialPageRoute(builder: (_) => const WithdrawFundsScreen());

      // Other routes
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.deals:
        return MaterialPageRoute(builder: (_) => const DealsScreen());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      // Success routes
      case AppRoutes.transactionSuccess:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => TransactionSuccessfulScreen(
              transactionId: args['transactionId'] as String,
              amount: args['amount'] as String,
              date: args['date'] as String,
            ),
          );
        }
        return _errorRoute('Transaction details required');

      case AppRoutes.escrowCreatedSuccess:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => EscrowCreatedSuccessScreen(
              transactionId: args['transactionId'] as String,
              amount: args['amount'] as String,
              date: args['date'] as String,
            ),
          );
        }
        return _errorRoute('Escrow details required');

      case AppRoutes.withdrawalSuccess:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => WithdrawalSuccessScreen(
              transactionId: args['transactionId'] as String,
              amount: args['amount'] as String,
              date: args['date'] as String,
            ),
          );
        }
        return _errorRoute('Withdrawal details required');

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(_).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
