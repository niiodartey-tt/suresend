import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suresend/theme/app_colors.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showBalance = true;
  final _storageService = StorageService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // For demo purposes, using static data
    // In production, this would fetch from storage service or API
    setState(() {
      _userData = {
        'name': 'John Doe',
        'username': '@johndoe',
        'userId': 'ESC-USER-16234567',
        'bio': 'Professional buyer and seller on the platform. Specializing in electronics and tech products.',
        'memberSince': 'Jan 2024',
        'isVerified': true,
        'totalBalance': 4700.00,
        'availableBalance': 4500.00,
        'escrowBalance': 200.00,
      };
    });
  }

  String _getInitials(String name) {
    return name.split(' ').map((word) => word[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              Navigator.pushNamed(context, '/settings');
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
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(_userData!['name']),
                                    style: const TextStyle(
                                      color: AppColors.primaryForeground,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              if (_userData!['isVerified'])
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
                                      _userData!['name'],
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    if (_userData!['isVerified']) ...[
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.verified,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _userData!['username'],
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
                          if (_userData!['isVerified'])
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
                          if (_userData!['isVerified']) const SizedBox(width: 8),
                          Text(
                            'Member since ${_userData!['memberSince']}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bio
                      Text(
                        _userData!['bio'],
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
                                _userData!['userId'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: _userData!['userId']));
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
                      _showBalance ? '\$${_userData!['totalBalance'].toStringAsFixed(2)}' : '••••••',
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
                                _showBalance ? '\$${_userData!['availableBalance'].toStringAsFixed(2)}' : '••••••',
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
                                _showBalance ? '\$${_userData!['escrowBalance'].toStringAsFixed(2)}' : '••••••',
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
                          Navigator.pushNamed(context, '/transaction/list');
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Analytics feature coming soon')),
                          );
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
