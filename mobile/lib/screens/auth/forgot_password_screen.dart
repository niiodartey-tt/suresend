import 'package:flutter/material.dart';
import 'package:suresend/config/app_colors.dart';
import 'package:suresend/config/theme.dart';

/// Forgot Password Screen
/// Allows users to reset their password via email
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSubmitted = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.spacing24,
                    right: AppTheme.spacing24,
                    top: AppTheme.spacing16,
                    bottom: AppTheme.spacing32 + AppTheme.spacing32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.primaryForeground,
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: AppTheme.spacing16),

                      // Title
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              color: AppColors.primaryForeground,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),

                      // Subtitle
                      Text(
                        'No worries, we\'ll send you reset instructions',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  AppColors.primaryForeground.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form card (overlapping header)
              Transform.translate(
                offset: const Offset(0, -32),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
                  child: Card(
                    elevation: AppTheme.elevationLg,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email field
                            Text(
                              'Email Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'your@email.com',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppTheme.spacing8),

                            // Helper text
                            Text(
                              'Enter the email associated with your account',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacing24),

                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSubmit,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryForeground,
                                          ),
                                        ),
                                      )
                                    : const Text('Send Reset Link'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Back to login link
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 16),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      'Back to Login',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        size: 32,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),

                    // Title
                    Text(
                      'Check Your Email',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing8),

                    // Message
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        children: [
                          const TextSpan(
                            text: 'We\'ve sent a password reset link to ',
                          ),
                          TextSpan(
                            text: _emailController.text,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),

                    // Additional info
                    Text(
                      'Didn\'t receive the email? Check your spam folder or try again.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing24),

                    // Back to login button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Back to Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
