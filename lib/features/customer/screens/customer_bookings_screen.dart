import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';
import 'customer_booking_details_screen.dart';

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() => _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final upcomingBookings = MockData.sampleBookings.where((b) => b.status == JobStatus.booked || b.status == JobStatus.inProgress).toList();
    final completedBookings = MockData.sampleBookings.where((b) => b.status == JobStatus.completed).toList();
    final pendingBookings = MockData.sampleBookings.where((b) => b.status == JobStatus.readyToBook || b.status == JobStatus.underReview).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.customerBrand,
          indicatorColor: AppColors.customerBrand,
          tabs: [
            Tab(text: "Active (${upcomingBookings.length})"),
            Tab(text: "Ready / In Review (${pendingBookings.length})"),
            Tab(text: "Completed (${completedBookings.length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(upcomingBookings),
          _buildBookingList(pendingBookings),
          _buildBookingList(completedBookings),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<CustomerBooking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_outlined, size: 54, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            const Text("No bookings in this category", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Book certified tradespeople from the dashboard", style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerBookingDetailsScreen(booking: booking),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        booking.bookingId,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    _buildStatusChip(booking.status),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  booking.serviceTitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: booking.worker.avatarColor,
                      child: Text(
                        booking.worker.avatarInitials,
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${booking.worker.name} (${booking.worker.trade})",
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(booking.bookingDate, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(booking.timeSlot, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Escrow: \$${booking.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const Row(
                      children: [
                        Text("View Details", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.customerBrand)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.customerBrand),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(JobStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case JobStatus.booked:
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF6D28D9);
        label = "Booked & Confirmed";
        break;
      case JobStatus.inProgress:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = "Worker On Site";
        break;
      case JobStatus.completed:
        bg = AppColors.successBg;
        fg = AppColors.success;
        label = "Completed & Paid";
        break;
      case JobStatus.readyToBook:
      default:
        bg = AppColors.accentLight;
        fg = AppColors.accentDark;
        label = "Pending Worker";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
    );
  }
}
