import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.adminBrand,
                  child: Icon(Icons.admin_panel_settings_rounded,
                      color: Colors.white, size: 38),
                ),
                const SizedBox(height: 14),
                const Text('Platform Admin',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text('admin@sequencepro.io',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.8))),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.adminBrand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Super Admin',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.adminBrand)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Account section
          const Text('Account',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _profileTile(Icons.person_rounded, 'Personal Information',
              'Name, phone, profile photo', () {}),
          _profileTile(Icons.security_rounded, 'Security',
              'Password, 2FA, login history', () {}),
          _profileTile(Icons.email_rounded, 'Email Preferences',
              'Notification emails, digests', () {}),

          const SizedBox(height: 20),

          // Platform section
          const Text('Platform',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _profileTile(Icons.group_rounded, 'Team Members',
              '3 admins, 2 moderators', () {}),
          _profileTile(Icons.history_rounded, 'Activity Log',
              'Recent admin actions and changes', () {}),
          _profileTile(Icons.api_rounded, 'API Keys',
              'Manage platform API access', () {}),

          const SizedBox(height: 20),

          // Support section
          const Text('Support',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _profileTile(Icons.help_outline_rounded, 'Help Center',
              'Documentation & guides', () {}),
          _profileTile(Icons.bug_report_rounded, 'Report a Bug',
              'Send feedback to engineering', () {}),

          const SizedBox(height: 24),

          // Logout
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            label: const Text('Log Out',
                style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('Version 1.0.0 (Build 42)',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary.withValues(alpha: 0.6))),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _profileTile(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.adminBrand, size: 22),
        title: Text(title,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textTertiary, size: 20),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
