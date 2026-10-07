import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/customer_service.dart';
import 'customer_booking_details_screen.dart';

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() => _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState extends State<CustomerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CustomerBooking> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final bookings = await CustomerService.getBookings();
      if (!mounted) return;
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load your bookings.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CustomerBooking> get _active => _bookings
      .where((b) =>
          b.bookingStatus == 'ACCEPTED' || b.bookingStatus == 'REQUESTED')
      .toList();

  List<CustomerBooking> get _pending =>
      _bookings.where((b) => b.bookingStatus == 'REQUESTED').toList();

  List<CustomerBooking> get _completed =>
      _bookings.where((b) => b.bookingStatus == 'COMPLETED').toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.customerBrand,
          indicatorColor: AppColors.customerBrand,
          tabs: [
            Tab(text: 'Active (' + _active.length.toString() + ')'),
            Tab(text: 'Pending (' + _pending.length.toString() + ')'),
            Tab(text: 'Completed (' + _completed.length.toString() + ')'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorState(message: _error!, onRetry: _loadBookings)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingList(_active),
                    _buildBookingList(_pending),
                    _buildBookingList(_completed),
                  ],
                ),
    );
  }

  Widget _buildBookingList(List<CustomerBooking> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          'No bookings yet.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerBookingDetailsScreen(booking: booking),
              ),
            ),
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
                      Text(
                        booking.bookingId,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      _statusChip(booking.bookingStatus),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    booking.serviceTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking.worker.name + ' · ' + booking.worker.trade,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    booking.bookingDate + ' · ' + booking.timeSlot,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total: ₹' + booking.totalAmount.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    final values = switch (status) {
      'ACCEPTED' => ('Accepted', AppColors.success, AppColors.successBg),
      'COMPLETED' => ('Completed', AppColors.success, AppColors.successBg),
      'DECLINED' => ('Declined', AppColors.error, AppColors.errorBg),
      'CANCELLED' => ('Cancelled', AppColors.error, AppColors.errorBg),
      _ => ('Pending Worker', AppColors.warning, AppColors.warningBg),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: values.$3,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        values.$1,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: values.$2,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
