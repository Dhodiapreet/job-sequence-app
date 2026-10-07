import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/admin_service.dart';
import 'admin_verification_screen.dart';
import 'admin_reports_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, int> _counts = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final counts = await AdminService.getOverviewCounts();
      if (!mounted) return;
      setState(() {
        _counts = counts;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load platform metrics.';
        _loading = false;
      });
    }
  }

  int _count(String key) => _counts[key] ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text('Live Platform Overview',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: _card('Customers', _count('customers'))),
                        const SizedBox(width: 10),
                        Expanded(child: _card('Workers', _count('workers'))),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: _card('Jobs', _count('jobs')),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _card('Bookings', _count('bookings_requested') +
                              _count('bookings_accepted') +
                              _count('bookings_completed') +
                              _count('bookings_cancelled')),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      const Text('Booking Status',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _statusRow('Requested', _count('bookings_requested')),
                      _statusRow('Accepted', _count('bookings_accepted')),
                      _statusRow('Completed', _count('bookings_completed')),
                      _statusRow('Cancelled', _count('bookings_cancelled')),
                      const SizedBox(height: 24),
                      const Text('Job Status',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _statusRow('In Progress', _count('jobs_in_progress')),
                      _statusRow('Completed', _count('jobs_completed')),
                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminVerificationScreen(),
                              ),
                            ),
                            icon: const Icon(Icons.verified_user_outlined),
                            label: const Text('Worker Verification'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminReportsScreen(),
                              ),
                            ),
                            icon: const Icon(Icons.analytics_outlined),
                            label: const Text('Reports'),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
    );
  }

  Widget _card(String label, int value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value.toString(),
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _statusRow(String label, int value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
