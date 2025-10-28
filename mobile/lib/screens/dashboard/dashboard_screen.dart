import 'package:flutter/material.dart';
import 'package:suresend/theme/app_theme.dart';
import 'package:suresend/shared/components/custom_bottom_nav.dart';
import 'widgets/wallet_balance_widget.dart';
import 'widgets/stats_card.dart';
import 'widgets/transaction_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Blue Header Section
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0A57E6), Color(0xFF003EB5)],
                  ),
                ),
                child: const WalletBalanceWidget(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded),
                onPressed: () {
                  // Navigate to notifications
                },
              ),
            ],
          ),

          // Stats Grid
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => StatsCard(index: index),
                childCount: 4,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppTheme.spacingM,
                crossAxisSpacing: AppTheme.spacingM,
                childAspectRatio: 1.5,
              ),
            ),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to top up wallet
                      },
                      child: const Text('Top Up Wallet'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to withdraw
                      },
                      child: const Text('Withdraw'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recent Transactions
          const SliverPadding(
            padding: EdgeInsets.all(AppTheme.spacingM),
            sliver: TransactionsList(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show transaction type modal
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}