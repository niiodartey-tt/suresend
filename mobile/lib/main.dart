import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/wallet_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/wallet/fund_wallet_screen.dart';
import 'screens/wallet/withdraw_funds_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService().init();

  runApp(const SureSendApp());
}

class SureSendApp extends StatelessWidget {
  const SureSendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(
        title: 'SureSend',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/wallet': (context) => const WalletScreen(),
          '/fund-wallet': (context) => const FundWalletScreen(),
          '/withdraw-funds': (context) => const WithdrawFundsScreen(),
          // example routes for chat and transaction details (use arguments in real app)
          '/chat': (context) => const ChatScreen(userId: 'user1', userName: 'User', transactionId: 'TRX-001'),
        },
      ),
    );
  }
}
