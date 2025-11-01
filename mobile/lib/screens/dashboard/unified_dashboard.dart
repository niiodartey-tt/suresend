import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../models/transaction.dart';
import '../../utils/currency_formatter.dart';
import '../notifications/notification_screen.dart';
import '../wallet/fund_wallet_screen.dart';
import '../wallet/withdraw_funds_screen.dart';
import '../transactions/transaction_list_screen.dart';
import '../transactions/transaction_detail_screen.dart';

class UnifiedDashboard extends StatefulWidget {
  const UnifiedDashboard({super.key});

  @override
  State<UnifiedDashboard> createState() => _UnifiedDashboardState();
}

class _UnifiedDashboardState extends State<UnifiedDashboard> {
  bool _isInitialLoading = true;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _startNotificationPolling();
    });
  }

  @override
  void dispose() {
    _stopNotificationPolling();
    super.dispose();
  }

  void _startNotificationPolling() {
    final notificationProvider = context.read<NotificationProvider>();
    notificationProvider.fetchUnreadCount();
    notificationProvider.startPolling();
  }

  void _stopNotificationPolling() {
    final notificationProvider = context.read<NotificationProvider>();
    notificationProvider.stopPolling();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _isInitialLoading = true;
      });
    }

    try {
      final transactionProvider = context.read<TransactionProvider>();
      final authProvider = context.read<AuthProvider>();
      final walletProvider = context.read<WalletProvider>();

      await Future.wait([
        transactionProvider.fetchTransactions(refresh: true),
        transactionProvider.fetchStats(),
        authProvider.refreshProfile(),
        walletProvider.fetchWallet(),
      ]);

      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    final user = authProvider.user;
    final transactions = transactionProvider.transactions;
    final wallet = walletProvider.wallet;
    final unreadCount = notificationProvider.unreadCount;

    // Calculate stats
    final activeCount = transactions
        .where((t) =>
            t.status == 'in_escrow' ||
            t.status == 'In Progress' ||
            t.status == 'Pending')
        .length;
    final completedCount =
        transactions.where((t) => t.status == 'completed').length;
    final disputedCount =
        transactions.where((t) => t.status == 'disputed').length;
    final totalCount = transactions.length;

    // Calculate escrow balance
    final escrowBalance = transactions
        .where((t) => t.status == 'in_escrow')
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    final recentTransactions = transactions.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome and Notification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    color: AppColors.primaryForeground
                                        .withValues(alpha: 0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.fullName ?? 'John Doe',
                                  style: const TextStyle(
                                    color: AppColors.primaryForeground,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            // Notification bell
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: AppColors.primaryForeground,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationScreen(),
                                      ),
                                    );
                                  },
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        unreadCount > 99
                                            ? '99+'
                                            : unreadCount.toString(),
                                        style: const TextStyle(
                                          color: AppColors.primaryForeground,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Wallet and Escrow Balance
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Wallet Balance',
                                    style: TextStyle(
                                      color: AppColors.primaryForeground
                                          .withValues(alpha: 0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    CurrencyFormatter.formatGHS(wallet?.balance ?? 4500.00),
                                    style: const TextStyle(
                                      color: AppColors.primaryForeground,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
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
                                    'Escrow Balance',
                                    style: TextStyle(
                                      color: AppColors.primaryForeground
                                          .withValues(alpha: 0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    CurrencyFormatter.formatGHS(escrowBalance),
                                    style: const TextStyle(
                                      color: AppColors.primaryForeground,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
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
                ),
              ),

              // Stats Card - Overlapping
              Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
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
                    child: Column(
                      children: [
                        // Top Row: Active and Completed
                        Row(
                          children: [
                            _buildStatItem(
                              icon: Icons.layers_outlined,
                              iconColor: AppColors.statsActiveText,
                              iconBg: AppColors.statsActiveBg,
                              label: 'Active',
                              value: activeCount.toString(),
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.success,
                              iconBg: AppColors.statsCompletedBg,
                              label: 'Completed',
                              value: completedCount.toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Divider
                        Container(
                          height: 1,
                          color: AppColors.border,
                        ),
                        const SizedBox(height: 16),
                        // Bottom Row: Dispute and Total
                        Row(
                          children: [
                            _buildStatItem(
                              icon: Icons.warning_amber_outlined,
                              iconColor: AppColors.warning,
                              iconBg: AppColors.statsDisputeBg,
                              label: 'Dispute',
                              value: disputedCount.toString(),
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              icon: Icons.emoji_events_outlined,
                              iconColor: AppColors.purple,
                              iconBg: AppColors.statsTotalBg,
                              label: 'Total',
                              value: totalCount.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FundWalletScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryForeground,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.buttonBorderRadius),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '+ Top up wallet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const WithdrawFundsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.secondaryForeground,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.buttonBorderRadius),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recent Transactions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECENT TRANSACTIONS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'October',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: _showFilters
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _showFilters = !_showFilters;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionListScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Transaction List
              if (recentTransactions.isEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No transactions yet',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return _buildTransactionCard(transaction);
                  },
                ),

              // Bottom spacing for navigation bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final statusColors = AppColors.getStatusColors(transaction.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  TransactionDetailScreen(transactionId: transaction.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID, Date, and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.id,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(transaction.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColors.background,
                      borderRadius: BorderRadius.circular(AppTheme.badgeBorderRadius),
                    ),
                    child: Text(
                      transaction.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: statusColors.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Amount
              Text(
                CurrencyFormatter.formatGHS(transaction.amount),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                transaction.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              // Seller/Buyer
              Builder(
                builder: (context) {
                  final currentUsername =
                      context.read<AuthProvider>().user?.username;
                  final isBuyer =
                      transaction.buyer.username == currentUsername;
                  final counterparty =
                      isBuyer ? transaction.seller : transaction.buyer;
                  return Text(
                    '${isBuyer ? 'Seller: ' : 'Buyer: '}${counterparty.fullName}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Details Button
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailScreen(
                          transactionId: transaction.id,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.buttonBorderRadius),
                    ),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}
