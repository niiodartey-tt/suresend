import 'package:flutter/material.dart';
import 'package:suresend/config/app_colors.dart';

/// Bottom Navigation Bar Component
/// Matches the Figma design with 5 navigation items including a centered FAB
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCreateTransaction;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCreateTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Dashboard - Grid icon
              _buildNavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Dashboard',
                index: 0,
              ),
              // 2. Deals - Document/list icon
              _buildNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Deals',
                index: 1,
              ),
              // 3. Create (center) - Large circular "+" button, elevated
              _buildCreateButton(),
              // 4. Settings - Gear icon
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                index: 2,
              ),
              // 5. Profile - User icon
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active state: Blue background fill, white icon
            // Inactive state: Gray icon, no background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                size: 24,
                color: isActive ? Colors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCreateTransaction,
            customBorder: const CircleBorder(),
            child: const Icon(
              Icons.add,
              size: 28,
              color: AppColors.primaryForeground,
            ),
          ),
        ),
      ),
    );
  }
}
