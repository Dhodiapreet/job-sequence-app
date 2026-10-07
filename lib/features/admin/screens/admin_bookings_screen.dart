import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/admin_service.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});
  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  List<AdminBooking> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await AdminService.getBookings();
      if (!mounted) return;
      setState(() {
        _bookings = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<AdminBooking> _byStatus(Set<String> statuses) =>
      _bookings.where((b) => statuses.contains(b.status)).toList();

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _byStatus({'REQUESTED', 'ACCEPTED'});
    final completed = _byStatus({'COMPLETED'});
    final cancelled = _byStatus({'CANCELLED', 'DECLINED'});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabs,
          labelColor: AppColors.adminBrand,
          indicatorColor: AppColors.adminBrand,
          tabs: [
            Tab(text: 'Active (' + active.length.toString() + ')'),
            Tab(text: 'Completed (' + completed.length.toString() + ')'),
            Tab(text: 'Cancelled (' + cancelled.length.toString() + ')'),
            Tab(text: 'All (' + _bookings.length.toString() + ')'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _list(active),
                _list(completed),
                _list(cancelled),
                _list(_bookings),
              ],
            ),
    );
  }

  Widget _list(List<AdminBooking> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text('No live bookings yet.',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final b = bookings[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b.id,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.adminBrand)),
                    _status(b.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(b.customer + ' → ' + b.worker,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(b.date,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text('\$' + b.amount.toStringAsFixed(2),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.workerBrand)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _status(String status) {
    Color color;
    Color bg;
    switch (status) {
      case 'ACCEPTED':
      case 'COMPLETED':
        color = AppColors.success;
        bg = AppColors.successBg;
      case 'CANCELLED':
      case 'DECLINED':
        color = AppColors.error;
        bg = AppColors.errorBg;
      default:
        color = AppColors.warning;
        bg = AppColors.warningBg;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(status,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
