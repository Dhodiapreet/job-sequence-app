import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../role_selection/role_selection_screen.dart';

class WorkerProfileTabScreen extends StatelessWidget {
  const WorkerProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.workerBrand,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text('Rohan Patel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Master Plumber', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    const Text('4.95', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(' (128 reviews)', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSettingsTile(context, Icons.person_outline, 'Personal Information'),
          _buildSettingsTile(context, Icons.verified_outlined, 'Skills & Certifications'),
          _buildSettingsTile(context, Icons.access_time, 'Availability Settings'),
          _buildSettingsTile(context, Icons.location_on_outlined, 'Service Area'),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('Switch Portal / Role'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.workerBrand),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opened $title')));
      },
    );
  }
}
