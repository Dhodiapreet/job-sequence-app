import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _autoApproveVerified = false;
  bool _maintenanceMode = false;
  double _platformFeePercent = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications section
          const Text('Notifications',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _settingSwitch(
            Icons.email_rounded,
            'Email Notifications',
            'Receive email alerts for disputes, verifications, and reports',
            _emailNotifications,
            (val) => setState(() => _emailNotifications = val),
          ),
          _settingSwitch(
            Icons.notifications_active_rounded,
            'Push Notifications',
            'Real-time alerts for urgent platform events',
            _pushNotifications,
            (val) => setState(() => _pushNotifications = val),
          ),

          const SizedBox(height: 20),

          // Platform section
          const Text('Platform Configuration',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          _settingSwitch(
            Icons.verified_rounded,
            'Auto-Approve Verified Workers',
            'Automatically approve workers who pass all checks',
            _autoApproveVerified,
            (val) => setState(() => _autoApproveVerified = val),
          ),

          // Platform fee slider
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.percent_rounded,
                        size: 20, color: AppColors.adminBrand),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Platform Service Fee',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    Text('${_platformFeePercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.adminBrand)),
                  ],
                ),
                Slider(
                  value: _platformFeePercent,
                  min: 5,
                  max: 25,
                  divisions: 20,
                  activeColor: AppColors.adminBrand,
                  onChanged: (val) =>
                      setState(() => _platformFeePercent = val),
                ),
                const Text(
                    'Fee charged on each booking (applied to customer total)',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textTertiary)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Danger zone
          const Text('Danger Zone',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error)),
          const SizedBox(height: 8),
          _settingSwitch(
            Icons.construction_rounded,
            'Maintenance Mode',
            'Temporarily disable new bookings and worker registrations',
            _maintenanceMode,
            (val) => setState(() => _maintenanceMode = val),
            dangerColor: true,
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded,
                  color: AppColors.error, size: 22),
              title: const Text('Clear Test Data',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.error)),
              subtitle: const Text(
                  'Remove all mock/test data from the platform',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textTertiary, size: 20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('This action requires confirmation')),
                );
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _settingSwitch(IconData icon, String title, String subtitle,
      bool value, ValueChanged<bool> onChanged,
      {bool dangerColor = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color:
                  dangerColor ? AppColors.error : AppColors.adminBrand),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor:
                dangerColor ? AppColors.error : AppColors.adminBrand,
          ),
        ],
      ),
    );
  }
}
