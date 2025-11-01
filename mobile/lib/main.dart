import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suresend/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService().init();

  // Initialize API service
  final apiService = ApiService();

  runApp(SureSendApp(apiService: apiService));
}

class SureSendApp extends StatelessWidget {
  final ApiService apiService;

  const SureSendApp({super.key, required this.apiService});

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
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        // Add route generator
        onGenerateRoute: AppRouteGenerator.generateRoute,
        // Define named routes for common navigation
        routes: {
          AppRoutes.login: (context) => const SplashScreen(), // Will redirect to login
        },
      ),
    );
  }
}
