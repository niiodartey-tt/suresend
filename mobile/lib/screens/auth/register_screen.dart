import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

/// Register Screen matching ui_reference/sign_up.png
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service and Privacy Policy'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final result = await authProvider.register(
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result['success']) {
      final phoneNumber = _phoneController.text.trim();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: phoneNumber,
            purpose: 'registration',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Registration failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 60),
              width: double.infinity,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryForeground,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.primaryForeground,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join us today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryForeground.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Card with negative margin to overlap header
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full Name
                      Text(
                        'Full Name',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'John Doe',
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.ring, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Username
                      Text(
                        'Username',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'johndoe',
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.ring, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This will be used for transactions',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Address
                      Text(
                        'Email Address',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'your@email.com',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.ring, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      Text(
                        'Phone Number',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '+1 (234) 567-8900',
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.ring, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Can also be used for transactions',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.ring, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      Text(
                        'Confirm Password',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.ring, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Terms & Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  'I agree to the ',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to Terms of Service
                                  },
                                  child: Text(
                                    'Terms of Service',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Text(
                                  ' and ',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to Privacy Policy
                                  },
                                  child: Text(
                                    'Privacy Policy',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Create Account Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primaryForeground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonBorderRadius),
                            ),
                            elevation: 0,
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(AppColors.primaryForeground),
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sign In Link
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
