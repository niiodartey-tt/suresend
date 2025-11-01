import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/services/api_service.dart';

class PlaceholderHomeScreen extends StatefulWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  State<PlaceholderHomeScreen> createState() => _PlaceholderHomeScreenState();
}

class _PlaceholderHomeScreenState extends State<PlaceholderHomeScreen> {
  bool _isTestingConnection = false;
  String _connectionStatus = 'Not tested';
  Color _statusColor = Colors.grey;

  Future<void> _testBackendConnection() async {
    setState(() {
      _isTestingConnection = true;
      _connectionStatus = 'Testing...';
      _statusColor = Colors.orange;
    });

    try {
      final result = await ApiService().healthCheck();

      setState(() {
        _isTestingConnection = false;
        if (result['success'] == true) {
          _connectionStatus = 'Connected to Backend ✓';
          _statusColor = AppTheme.successColor;
        } else {
          _connectionStatus = 'Connection Failed: ${result['error']}';
          _statusColor = AppTheme.errorColor;
        }
      });
    } catch (e) {
      setState(() {
        _isTestingConnection = false;
        _connectionStatus = 'Error: ${e.toString()}';
        _statusColor = AppTheme.errorColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SureSend - Stage 1'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.security,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Welcome Text
              const Text(
                'Welcome to SureSend',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure Escrow Payments for Ghana',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Stage Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Stage 1: Setup Complete',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The project foundation is ready! Backend, Database, and Mobile app are all configured.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        'Coming in Stage 2:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem('User Registration'),
                      _buildFeatureItem('Login with OTP'),
                      _buildFeatureItem('User Profiles'),
                      _buildFeatureItem('KYC Verification'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Backend Connection Test
              Card(
                color: _statusColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _connectionStatus,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _statusColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isTestingConnection
                            ? null
                            : _testBackendConnection,
                        icon: _isTestingConnection
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.wifi),
                        label: Text(
                          _isTestingConnection
                              ? 'Testing...'
                              : 'Test Backend Connection',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Make sure backend is running on http://localhost:3000',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
