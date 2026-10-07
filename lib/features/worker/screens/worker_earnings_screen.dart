import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/worker_service.dart';

class WorkerEarningsScreen extends StatefulWidget {
  const WorkerEarningsScreen({super.key});
  @override
  State<WorkerEarningsScreen> createState() => _WorkerEarningsScreenState();
}

class _WorkerEarningsScreenState extends State<WorkerEarningsScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final bookings = await WorkerService.getWorkerBookings();
      if (!mounted) return;
      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  double get _completedTotal => _bookings
      .where((b) => b['status'] == 'COMPLETED')
      .fold(0.0, (sum, b) => sum + ((b['labor_cost'] as num?)?.toDouble() ?? 0));

  @override
  Widget build(BuildContext context) {
    final completed = _bookings.where((b) => b['status'] == 'COMPLETED').toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Wallet',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.workerBrand, Color(0xFF047857)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text('Completed Earnings',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          '₹' + _completedTotal.toStringAsFixed(2),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Payment and bank withdrawal are not connected yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('Completed Booking Earnings',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (completed.isEmpty)
                    const Text('No completed earnings yet.',
                        style: TextStyle(color: AppColors.textSecondary))
                  else
                    ...completed.map((booking) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.successBg,
                            child: Icon(Icons.payments_rounded,
                                color: AppColors.success),
                          ),
                          title: Text(
                            'Booking ' + booking['id'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Completed booking'),
                          trailing: Text(
                            '₹' +
                                ((booking['labor_cost'] as num?)
                                        ?.toDouble() ??
                                    0)
                                    .toStringAsFixed(2),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success),
                          ),
                        )),
                ],
              ),
            ),
    );
  }
}
