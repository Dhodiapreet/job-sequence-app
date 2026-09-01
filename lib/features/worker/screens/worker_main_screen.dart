import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'worker_dashboard_screen.dart';
import 'worker_schedule_screen.dart';
import 'worker_requests_screen.dart';
import 'worker_earnings_screen.dart';
import 'worker_profile_tab_screen.dart';

class WorkerMainScreen extends StatefulWidget {
  const WorkerMainScreen({super.key});

  @override
  State<WorkerMainScreen> createState() => _WorkerMainScreenState();
}

class _WorkerMainScreenState extends State<WorkerMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const WorkerDashboardScreen(),
      const WorkerScheduleScreen(),
      const WorkerRequestsScreen(),
      const WorkerEarningsScreen(),
      const WorkerProfileTabScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.workerBrand),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today_rounded, color: AppColors.workerBrand),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Badge(
              smallSize: 8,
              child: Icon(Icons.inbox_outlined),
            ),
            selectedIcon: Icon(Icons.inbox_rounded, color: AppColors.workerBrand),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded, color: AppColors.workerBrand),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.workerBrand),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
