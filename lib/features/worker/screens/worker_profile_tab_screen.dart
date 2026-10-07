import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';

class WorkerProfileTabScreen extends StatefulWidget {
  const WorkerProfileTabScreen({super.key});
  @override
  State<WorkerProfileTabScreen> createState() => _WorkerProfileTabScreenState();
}

class _WorkerProfileTabScreenState extends State<WorkerProfileTabScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final profile = await AuthService.getCurrentProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String get _name => (_profile?['full_name'] as String?)?.trim().isNotEmpty == true
      ? (_profile!['full_name'] as String).trim()
      : 'Worker';
  String get _email => (_profile?['email'] as String?) ?? '';
  String get _trade => (_profile?['trade'] as String?)?.trim() ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.workerBrand,
                        child: Text(
                          _name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(_name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      if (_trade.isNotEmpty)
                        Text(_trade,
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Text(_email,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSettingsTile(
                    context, Icons.person_outline, 'Personal Information'),
                _buildSettingsTile(context, Icons.verified_outlined,
                    'Skills & Certifications'),
                _buildSettingsTile(
                    context, Icons.access_time, 'Availability Settings'),
                _buildSettingsTile(
                    context, Icons.location_on_outlined, 'Service Area'),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () async {
                    await AuthService.signOut();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.workerBrand),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title is not connected yet.')),
      ),
    );
  }
}
