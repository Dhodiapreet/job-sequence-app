import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/admin_service.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});
  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  Map<String, int> _counts = {};
  List<AdminBooking> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait<dynamic>([
        AdminService.getOverviewCounts(),
        AdminService.getBookings(),
      ]);
      if (!mounted) return;
      setState(() {
        _counts = results[0] as Map<String, int>;
        _bookings = results[1] as List<AdminBooking>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = _bookings.where((b) => b.status == 'COMPLETED');
    final accepted = _bookings.where((b) => b.status == 'ACCEPTED');
    final requested = _bookings.where((b) => b.status == 'REQUESTED');
    final total = _bookings.fold<double>(0, (sum, b) => sum + b.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Live Database Report',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  _metric('Customers', _counts['customers'] ?? 0),
                  _metric('Workers', _counts['workers'] ?? 0),
                  _metric('Jobs', _counts['jobs'] ?? 0),
                  _metric('Requested Bookings', requested.length),
                  _metric('Accepted Bookings', accepted.length),
                  _metric('Completed Bookings', completed.length),
                  _metric('Booking Value', total.toStringAsFixed(2)),
                  const SizedBox(height: 20),
                  const Text(
                    'No historical or trend values are shown here until they exist in the live database.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _metric(String label, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
