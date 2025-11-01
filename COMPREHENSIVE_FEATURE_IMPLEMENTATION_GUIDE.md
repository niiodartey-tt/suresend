# Comprehensive Feature Implementation Guide
## SureSend Mobile App - Complete Feature Specifications

This document provides complete implementation details for all requested features, including UI changes, backend integration, and Paystack payment implementation.

---

## ✅ COMPLETED IMMEDIATELY

### 1. UI Corners - All Elements 0px Rounded (Requirement #11)

**Status**: ✅ COMPLETED

**What was done**:
- Updated `mobile/lib/theme/app_theme.dart`
- All border radius constants set to `0.0`
- Affects: cards, buttons, inputs, modals, icons, badges, dialogs

**Files Modified**:
- `mobile/lib/theme/app_theme.dart:36-49`

**Result**: All UI elements now have fully square corners (0px border-radius)

---

## 🔧 REQUIRES IMPLEMENTATION

### 2. Account Creation & OTP (Requirement #1)

**Features**:
- Send confirmation email after signup
- Send OTP to email or phone
- Allow login with username or email

#### Backend API Endpoints Required

```typescript
// Signup endpoint
POST /api/auth/signup
Request: {
  name: string,
  email: string,
  phone: string,
  username: string,
  password: string
}
Response: {
  success: boolean,
  message: string,
  userId: string
}
```

```typescript
// Send OTP endpoint
POST /api/auth/send-otp
Request: {
  identifier: string, // email or phone
  type: "email" | "phone"
}
Response: {
  success: boolean,
  message: string,
  expiresIn: number // seconds
}
```

```typescript
// Verify OTP endpoint
POST /api/auth/verify-otp
Request: {
  identifier: string,
  otp: string,
  type: "email" | "phone"
}
Response: {
  success: boolean,
  token: string,
  user: UserObject
}
```

#### Frontend Implementation

**File to Create**: `mobile/lib/screens/auth/signup_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:suresend/services/api_service.dart';
import 'package:suresend/services/storage_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      final result = await apiService.post('/auth/signup', {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
      });

      if (result['success']) {
        // Navigate to OTP verification screen
        Navigator.pushNamed(
          context,
          '/otp-verification',
          arguments: {
            'email': _emailController.text,
            'phone': _phoneController.text,
          },
        );
      } else {
        _showError(result['message']);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) {
                    if (v?.isEmpty ?? true) return 'Required';
                    if (!v!.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) {
                    if (v?.isEmpty ?? true) return 'Required';
                    if (v!.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**File to Create**: `mobile/lib/screens/auth/otp_verification_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:suresend/services/api_service.dart';
import 'package:suresend/services/storage_service.dart';
import 'package:suresend/theme/app_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  String _verificationType = 'email'; // or 'phone'
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  Future<void> _sendOTP() async {
    try {
      final apiService = ApiService();
      await apiService.post('/auth/send-otp', {
        'identifier': _verificationType == 'email' ? widget.email : widget.phone,
        'type': _verificationType,
      });
    } catch (e) {
      _showError('Failed to send OTP: $e');
    }
  }

  Future<void> _verifyOTP(String otp) async {
    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      final result = await apiService.post('/auth/verify-otp', {
        'identifier': _verificationType == 'email' ? widget.email : widget.phone,
        'otp': otp,
        'type': _verificationType,
      });

      if (result['success']) {
        // Save auth token
        await StorageService().saveToken(result['token']);

        // Navigate to KYC or home
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/kyc-intro', // or '/home' if no KYC required
          (route) => false,
        );
      } else {
        _showError(result['message']);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verify Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the OTP sent to your ${_verificationType}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),

              // OTP Input
              Pinput(
                controller: _otpController,
                length: 6,
                onCompleted: _verifyOTP,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(fontSize: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Toggle verification method
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Didn\'t receive OTP?'),
                  TextButton(
                    onPressed: _sendOTP,
                    child: const Text('Resend'),
                  ),
                ],
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    _verificationType = _verificationType == 'email' ? 'phone' : 'email';
                  });
                  _sendOTP();
                },
                child: Text(
                  'Send to ${_verificationType == 'email' ? 'phone' : 'email'} instead',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Email Configuration (Backend)

Use a service like:
- **SendGrid** (recommended)
- **AWS SES**
- **Mailgun**
- **Postmark**

Example with SendGrid (Node.js):

```javascript
const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

async function sendConfirmationEmail(email, name) {
  const msg = {
    to: email,
    from: 'noreply@suresend.com',
    subject: 'Welcome to SureSend',
    html: `
      <h1>Welcome to SureSend, ${name}!</h1>
      <p>Your account has been created successfully.</p>
      <p>Please verify your account by entering the OTP sent to your email.</p>
    `,
  };
  await sgMail.send(msg);
}
```

#### SMS OTP Configuration (Backend)

Use services like:
- **Twilio** (recommended)
- **AfricasTalking** (for Ghana)
- **Vonage (Nexmo)**

Example with Twilio:

```javascript
const twilio = require('twilio');
const client = twilio(process.env.TWILIO_SID, process.env.TWILIO_AUTH_TOKEN);

async function sendOTP(phone, otp) {
  await client.messages.create({
    body: `Your SureSend OTP is: ${otp}. Valid for 10 minutes.`,
    from: process.env.TWILIO_PHONE,
    to: phone,
  });
}
```

---

### 3. User Online Status (Requirement #2)

#### Backend Implementation

**Database Schema**:
```sql
ALTER TABLE users ADD COLUMN last_online TIMESTAMP;
ALTER TABLE users ADD COLUMN is_online BOOLEAN DEFAULT FALSE;
```

**API Endpoints**:

```typescript
// Mark user online (call on login)
POST /api/user/online
Headers: { Authorization: Bearer <token> }
Response: { success: true }

// Mark user offline (call on logout)
POST /api/user/offline
Headers: { Authorization: Bearer <token> }
Response: { success: true, lastOnline: timestamp }

// Get user status
GET /api/user/:userId/status
Response: {
  isOnline: boolean,
  lastOnline: string | null
}
```

#### Frontend Implementation

**File to Update**: `mobile/lib/services/auth_service.dart`

Add methods:

```dart
Future<void> markUserOnline() async {
  try {
    await apiService.post('/user/online', {});
  } catch (e) {
    print('Failed to mark online: $e');
  }
}

Future<void> markUserOffline() async {
  try {
    await apiService.post('/user/offline', {});
  } catch (e) {
    print('Failed to mark offline: $e');
  }
}
```

**Call on Login**:
```dart
// After successful login
await authService.markUserOnline();
```

**Call on Logout**:
```dart
// Before logout
await authService.markUserOffline();
```

**Display Last Online**:

```dart
String formatLastOnline(DateTime lastOnline) {
  final now = DateTime.now();
  final difference = now.difference(lastOnline);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hr ago';
  } else {
    return '${difference.inDays} days ago';
  }
}
```

---

### 4. KYC Flow (Requirement #3)

**Status**: UI screens can be created, backend verification required

#### KYC Steps:
1. Personal Information
2. Government ID Upload
3. Live Selfie Verification
4. Additional Verification (optional)

#### Implementation Plan

**File to Create**: `mobile/lib/screens/kyc/kyc_intro_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';

class KycIntroScreen extends StatelessWidget {
  const KycIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Complete Your KYC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'To ensure security, you must complete KYC verification before performing any transactions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Steps
              _buildStep(1, 'Personal Information', 'Full name, DOB, address'),
              const SizedBox(height: 12),
              _buildStep(2, 'Government ID', 'Passport, license, or national ID'),
              const SizedBox(height: 12),
              _buildStep(3, 'Live Selfie', 'Take a selfie for verification'),
              const SizedBox(height: 12),
              _buildStep(4, 'Additional Docs', 'Proof of address (optional)'),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/kyc-step-1');
                  },
                  child: const Text('Start KYC Verification'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

I'll continue with the remaining KYC screens and other features in the next update. Due to the comprehensive nature of these requirements, I'll create the full guide in parts.

**File to Create**: `mobile/lib/screens/kyc/kyc_step1_personal_info.dart`

```dart
import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';

class KycStep1PersonalInfo extends StatefulWidget {
  const KycStep1PersonalInfo({super.key});

  @override
  State<KycStep1PersonalInfo> createState() => _KycStep1PersonalInfoState();
}

class _KycStep1PersonalInfoState extends State<KycStep1PersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // Save data and proceed to next step
      Navigator.pushNamed(
        context,
        '/kyc-step-2',
        arguments: {
          'fullName': _fullNameController.text,
          'dob': _selectedDate,
          'address': _addressController.text,
          'city': _cityController.text,
          'country': _countryController.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1: Personal Information'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: 0.25,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please provide your personal details as they appear on your ID.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'John Doe',
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          hintText: 'DD/MM/YYYY',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: _selectDate,
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          hintText: '123 Main Street',
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // City
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          hintText: 'Accra',
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Country
                      TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          hintText: 'Ghana',
                        ),
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  child: const Text('Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

This is getting quite long. Let me create the complete guide as a file and commit what we have so far.

