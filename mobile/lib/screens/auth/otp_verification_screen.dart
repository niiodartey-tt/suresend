import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../dashboard/unified_dashboard.dart';
import '../dashboard/rider_dashboard.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String purpose; // 'registration' or 'login'

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.purpose,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isResending = false;
  int _resendCountdown = 0;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a 6-digit OTP'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final result = await authProvider.verifyOTP(
      phoneNumber: widget.phoneNumber,
      otpCode: _otpController.text,
      purpose: widget.purpose,
    );

    if (!mounted) return;

    if (result['success']) {
      // Get user type and navigate to appropriate dashboard
      final user = authProvider.user;

      Widget dashboard;
      if (user?.isRider == true) {
        dashboard = const RiderDashboard();
      } else {
        // All users (can buy and sell) go to unified dashboard
        dashboard = const UnifiedDashboard();
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => dashboard),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Authentication successful!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'OTP verification failed'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _handleResendOTP() async {
    if (_resendCountdown > 0) return;

    setState(() {
      _isResending = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final result = await authProvider.resendOTP(
      phoneNumber: widget.phoneNumber,
      purpose: widget.purpose,
    );

    if (!mounted) return;

    setState(() {
      _isResending = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP sent successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      // Start countdown
      setState(() {
        _resendCountdown = 60;
      });

      _startCountdown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to resend OTP'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppTheme.primaryColor, width: 2),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sms_outlined,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Enter OTP Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'We\'ve sent a 6-digit code to\n${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // OTP Input
              Pinput(
                controller: _otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onCompleted: (pin) => _handleVerifyOTP(),
              ),
              const SizedBox(height: 32),

              // Verify Button
              CustomButton(
                text: 'Verify OTP',
                onPressed: _handleVerifyOTP,
                isLoading: authProvider.isLoading,
                width: double.infinity,
              ),
              const SizedBox(height: 24),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Didn\'t receive code? '),
                  if (_resendCountdown > 0)
                    Text(
                      'Resend in ${_resendCountdown}s',
                      style: const TextStyle(color: Colors.grey),
                    )
                  else if (_isResending)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    TextButton(
                      onPressed: _handleResendOTP,
                      child: const Text('Resend'),
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // Info Card
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'In development mode, check your terminal/console for the OTP code',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                          ),
                        ),
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
}
