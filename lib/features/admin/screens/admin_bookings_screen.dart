import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _bookings = [
    _MockBooking(id: 'BK-3401', customer: 'David Sterling', worker: 'Rohan Patel', service: 'Rough Plumbing', date: 'Oct 15, 2026', amount: 1200.0, status: JobStatus.inProgress),
    _MockBooking(id: 'BK-3402', customer: 'Sarah Jenkins', worker: 'Darius Washington', service: 'Ceiling Fan Install', date: 'Oct 22, 2026', amount: 230.0, status: JobStatus.booked),
    _MockBooking(id: 'BK-3403', customer: 'Elena Rostova', worker: 'Marcus Vance', service: 'Kitchen Demolition', date: 'Nov 01, 2026', amount: 650.0, status: JobStatus.pendingPredecessor),
    _MockBooking(id: 'BK-3404', customer: 'David Sterling', worker: 'Elena Geller', service: 'Tile Backsplash', date: 'Sep 28, 2026', amount: 645.0, status: JobStatus.completed),
    _MockBooking(id: 'BK-3405', customer: 'Michael Chang', worker: 'Tomoko Saito', service: 'AC Maintenance', date: 'Oct 10, 2026', amount: 180.0, status: JobStatus.completed),
    _MockBooking(id: 'BK-3406', customer: 'James Whitmore', worker: 'Tomoko Saito', service: 'AC Repair', date: 'Oct 18, 2026', amount: 320.0, status: JobStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.adminBrand,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.adminBrand,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(_bookings
              .where((b) =>
                  b.status == JobStatus.inProgress ||
                  b.status == JobStatus.booked ||
                  b.status == JobStatus.pendingPredecessor)
              .toList()),
          _buildBookingList(
              _bookings.where((b) => b.status == JobStatus.completed).toList()),
          _buildBookingList(
              _bookings.where((b) => b.status == JobStatus.cancelled).toList()),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<_MockBooking> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_online_rounded,
                size: 48, color: AppColors.textTertiary),
            SizedBox(height: 12),
            Text('No bookings in this category',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.adminBrand)),
                  _statusChip(b.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(b.service,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(b.customer,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  const Icon(Icons.engineering_outlined,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(b.worker,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(b.date,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textTertiary)),
                  Text('\$${b.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.workerBrand)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusChip(JobStatus status) {
    String label;
    Color color;
    Color bg;

    switch (status) {
      case JobStatus.inProgress:
        label = 'In Progress';
        color = AppColors.info;
        bg = AppColors.infoBg;
      case JobStatus.booked:
        label = 'Booked';
        color = AppColors.customerBrand;
        bg = const Color(0xFFDBEAFE);
      case JobStatus.pendingPredecessor:
        label = 'Pending';
        color = AppColors.warning;
        bg = AppColors.warningBg;
      case JobStatus.completed:
        label = 'Completed';
        color = AppColors.success;
        bg = AppColors.successBg;
      case JobStatus.cancelled:
        label = 'Cancelled';
        color = AppColors.error;
        bg = AppColors.errorBg;
      default:
        label = 'Unknown';
        color = AppColors.textTertiary;
        bg = AppColors.border;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _MockBooking {
  final String id, customer, worker, service, date;
  final double amount;
  final JobStatus status;

  const _MockBooking({
    required this.id,
    required this.customer,
    required this.worker,
    required this.service,
    required this.date,
    required this.amount,
    required this.status,
  });
}
