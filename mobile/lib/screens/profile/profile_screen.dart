import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/shared/components/custom_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showBalance = true;
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Profile', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to settings
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            children: [
              // Profile Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar and Name
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'JD',
                                    style: TextStyle(
                                      color: AppColors.primaryForeground,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(
                                      BorderSide(color: AppColors.card, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'John Doe',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '@johndoe',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Verified and Member Since
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBeafe),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Verified',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF3B82F6),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Member since Jan 2024',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bio
                      Text(
                        'Professional buyer and seller on the platform. Specializing in electronics and tech products.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 16),
                      // User ID
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'ESC-USER-16234567',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(const ClipboardData(text: 'ESC-USER-16234567'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('User ID copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.copy,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Total Balance Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Balance Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColors.primaryForeground,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Balance',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryForeground.withValues(alpha: 0.9),
                                  ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showBalance = !_showBalance;
                            });
                          },
                          child: Icon(
                            _showBalance ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.primaryForeground,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Balance Amount
                    Text(
                      _showBalance ? '\$4700.00' : '••••••',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primaryForeground,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.primaryForeground, thickness: 0.5),
                    const SizedBox(height: 20),
                    // Available and In Escrow
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryForeground.withValues(alpha: 0.8),
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _showBalance ? '\$4500.00' : '••••••',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.primaryForeground,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'In Escrow',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryForeground.withValues(alpha: 0.8),
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _showBalance ? '\$200.00' : '••••••',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.primaryForeground,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action Cards
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          // Navigate to transaction history
                        },
                        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBeafe),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: Color(0xFF3B82F6),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Transaction\nHistory',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          // Navigate to analytics
                        },
                        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.show_chart,
                                  color: Color(0xFF10B981),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Analytics &\nInsights',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) return; // Already on profile
          setState(() => _currentIndex = index);
          // Navigate to other screens based on index
        },
      ),
    );
  }
}
