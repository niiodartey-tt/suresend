import 'package:flutter/material.dart';
import 'package:suresend/screens/dashboard/dashboard_screen.dart';
import 'package:suresend/screens/deals/deals_screen.dart';
import 'package:suresend/screens/settings/settings_screen.dart';
import 'package:suresend/screens/profile/profile_screen.dart';
import 'package:suresend/widgets/app_bottom_navigation.dart';
import 'package:suresend/widgets/create_transaction_modal.dart';

/// Main home screen with bottom navigation
/// Holds all 5 main sections of the app
class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      // Show create transaction modal instead of navigating
      _showCreateTransactionModal();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showCreateTransactionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateTransactionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        onPageChanged: (index) {
          if (index != 2) {
            // Skip the create button index
            setState(() {
              _currentIndex = index;
            });
          }
        },
        children: const [
          DashboardScreen(),
          DealsScreen(),
          SizedBox(), // Placeholder for create (handled by modal)
          SettingsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
