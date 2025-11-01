import 'package:flutter/material.dart';
import 'package:suresend/theme/app_colors.dart';
import '../dashboard/unified_dashboard.dart';
import '../deals/deals_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';
import '../transactions/transaction_type_modal.dart';

/// Main navigation screen with bottom navigation bar
/// Matches the Figma design with Dashboard, Deals, FAB, Settings, and Profile tabs
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = const [
    UnifiedDashboard(),
    DealsScreen(),
    SizedBox.shrink(), // Placeholder for FAB (index 2)
    SettingsScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    // Index 2 is the FAB - show transaction modal instead of changing screen
    if (index == 2) {
      _showTransactionModal();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _showTransactionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const TransactionTypeModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTransactionModal,
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: AppColors.primaryForeground,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: AppColors.card,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      elevation: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Dashboard',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.article_outlined,
              activeIcon: Icons.article,
              label: 'Deals',
            ),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(
              index: 3,
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: 'Settings',
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
