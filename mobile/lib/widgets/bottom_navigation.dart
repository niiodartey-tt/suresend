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
      decoration: BoxDecoration(
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
              _buildNavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: 'Dashboard',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.description_outlined,
                activeIcon: Icons.description,
                label: 'Deals',
                index: 1,
              ),
              // Center FAB
              _buildCreateButton(),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                index: 2,
              ),
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
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            // Active indicator dot
            if (isActive)
              Container(
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
              color: AppColors.primary.withOpacity(0.3),
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
