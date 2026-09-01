import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'admin_dashboard_screen.dart';
import 'admin_workers_screen.dart';
import 'admin_customers_screen.dart';
import 'admin_jobs_screen.dart';
import 'admin_verification_screen.dart';
import 'admin_categories_screen.dart';
import 'admin_bookings_screen.dart';
import 'admin_reports_screen.dart';
import 'admin_notifications_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_settings_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  static const List<_DrawerItem> _drawerItems = [
    _DrawerItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _DrawerItem(icon: Icons.engineering_rounded, label: 'Workers'),
    _DrawerItem(icon: Icons.people_rounded, label: 'Customers'),
    _DrawerItem(icon: Icons.work_rounded, label: 'Jobs'),
    _DrawerItem(icon: Icons.verified_user_rounded, label: 'Verification'),
    _DrawerItem(icon: Icons.category_rounded, label: 'Categories'),
    _DrawerItem(icon: Icons.book_online_rounded, label: 'Bookings'),
    _DrawerItem(icon: Icons.bar_chart_rounded, label: 'Reports'),
    _DrawerItem(icon: Icons.notifications_rounded, label: 'Notifications'),
    _DrawerItem(icon: Icons.person_rounded, label: 'Profile'),
    _DrawerItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardScreen();
      case 1:
        return const AdminWorkersScreen();
      case 2:
        return const AdminCustomersScreen();
      case 3:
        return const AdminJobsScreen();
      case 4:
        return const AdminVerificationScreen();
      case 5:
        return const AdminCategoriesScreen();
      case 6:
        return const AdminBookingsScreen();
      case 7:
        return const AdminReportsScreen();
      case 8:
        return const AdminNotificationsScreen();
      case 9:
        return const AdminProfileScreen();
      case 10:
        return const AdminSettingsScreen();
      default:
        return const AdminDashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF581C87), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.admin_panel_settings_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 12),
                    const Text('Admin Panel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text('Platform Operations Hub',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _drawerItems.length,
                  itemBuilder: (context, index) {
                    final item = _drawerItems[index];
                    final isSelected = _selectedIndex == index;
                    return ListTile(
                      leading: Icon(item.icon,
                          color: isSelected
                              ? AppColors.adminBrand
                              : AppColors.textSecondary,
                          size: 22),
                      title: Text(item.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.adminBrand
                                : AppColors.textPrimary,
                          )),
                      selected: isSelected,
                      selectedTileColor:
                          AppColors.adminBrand.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      dense: true,
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.swap_horiz_rounded,
                    color: AppColors.adminBrand),
                title: const Text('Switch Role',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.adminBrand,
                        fontSize: 14)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex < 5 ? _selectedIndex : 0,
        onDestinationSelected: (idx) {
          setState(() => _selectedIndex = idx);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon:
                Icon(Icons.dashboard_rounded, color: AppColors.adminBrand),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon:
                Icon(Icons.engineering_rounded, color: AppColors.adminBrand),
            label: 'Workers',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon:
                Icon(Icons.people_rounded, color: AppColors.adminBrand),
            label: 'Customers',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outlined),
            selectedIcon:
                Icon(Icons.work_rounded, color: AppColors.adminBrand),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.verified_user_outlined),
            selectedIcon: Icon(Icons.verified_user_rounded,
                color: AppColors.adminBrand),
            label: 'Verify',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;

  const _DrawerItem({required this.icon, required this.label});
}
