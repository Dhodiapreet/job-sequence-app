import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';
import 'customer_booking_details_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final CustomerBooking booking;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Confirmation"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Big Success Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success.withValues(alpha: 0.4), width: 2),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Booking Confirmed!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Booking ID: ${booking.bookingId}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your trade appointment is secured. The contractor has been alerted with your job site requirements.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Booking Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Appointment Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildSummaryRow(Icons.person_outline, "Worker", "${booking.worker.name} (${booking.worker.trade})"),
                _buildSummaryRow(Icons.calendar_today_outlined, "Date", booking.bookingDate),
                _buildSummaryRow(Icons.access_time_outlined, "Time Slot", booking.timeSlot),
                _buildSummaryRow(Icons.location_on_outlined, "Location", booking.address),
                const Divider(height: 20),
                _buildSummaryRow(Icons.shield_outlined, "Escrow Secured", "\$${booking.totalAmount.toStringAsFixed(2)}"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Escrow protection banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_rounded, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Your funds are held securely in platform escrow. Payment is released to the worker only after work completion is verified.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Navigation CTA
          ElevatedButton(
            onPressed: () {
              // Add booking to sample in-memory mock if needed
              MockData.sampleBookings.insert(0, booking);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerBookingDetailsScreen(booking: booking),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customerBrand,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("View Booking Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text("Return to Dashboard"),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
