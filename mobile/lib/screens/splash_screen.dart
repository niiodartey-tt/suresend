import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suresend/config/theme.dart';
import 'package:suresend/providers/auth_provider.dart';
import 'package:suresend/screens/auth/login_screen.dart';
import 'package:suresend/screens/dashboard/unified_dashboard.dart';
import 'package:suresend/screens/dashboard/rider_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash screen display
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check authentication status
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initAuth();

    if (!mounted) return;

    // Navigate based on authentication status
    if (authProvider.isAuthenticated && authProvider.user != null) {
      // User is authenticated, navigate to appropriate dashboard
      Widget dashboard;
      if (authProvider.user!.isRider) {
        dashboard = const RiderDashboard();
      } else {
        // All users (can buy and sell) go to unified dashboard
        dashboard = const UnifiedDashboard();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => dashboard),
      );
    } else {
      // User not authenticated, navigate to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo (placeholder)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.security,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'SureSend',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Tagline
            const Text(
              'Secure Escrow Payments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
