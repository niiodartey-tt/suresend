import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SureSendApp());
}

class SureSendApp extends StatelessWidget {
  const SureSendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SureSend',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
    
    // TODO: Add MultiProvider back when you implement providers in Stage 2:
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => AuthProvider()),
    //     ChangeNotifierProvider(create: (_) => UserProvider()),
    //     ChangeNotifierProvider(create: (_) => WalletProvider()),
    //   ],
    //   child: MaterialApp(...),
    // );
  }
}