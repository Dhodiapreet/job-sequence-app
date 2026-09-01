import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';

class CustomerBookingDetailsScreen extends StatelessWidget {
  final CustomerBooking booking;

  const CustomerBookingDetailsScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "BOOKING ${booking.bookingId}",
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        booking.status == JobStatus.completed ? "COMPLETED" : "CONFIRMED",
                        style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  booking.serviceTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.event_available_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "${booking.bookingDate} • ${booking.timeSlot}",
                      style: const TextStyle(color: Colors.white, fontSize: 12.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Worker Card info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: booking.worker.avatarColor,
                  child: Text(
                    booking.worker.avatarInitials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(booking.worker.name, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 15, color: AppColors.customerBrand),
                        ],
                      ),
                      Text(booking.worker.trade, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text("${booking.worker.rating} (${booking.worker.reviewsCount} reviews)", style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.customerBrand),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Calling ${booking.worker.name}...")),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Job details & location
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Service Details & Scope", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(booking.jobDescription, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                const Text("Job Site Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: AppColors.customerBrand),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(booking.address, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
                if (booking.specialInstructions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes_rounded, size: 16, color: AppColors.textTertiary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text("Note: ${booking.specialInstructions}", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Payment & Escrow Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Escrow Payment Summary", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Labor (${booking.estimatedHours.toInt()} hrs @ \$${booking.worker.hourlyRate.toInt()}/hr)", style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text("\$${booking.laborCost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Platform Guarantee & Escrow Fee", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text("\$${booking.serviceFee.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Milestone Held", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("\$${booking.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          if (booking.status == JobStatus.booked) ...[
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Connecting with worker on live messaging...")),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: const Text("Message Worker"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.customerBrand,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                _showCancelDialog(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Reschedule / Cancel Booking"),
            ),
          ] else if (booking.status == JobStatus.completed) ...[
            ElevatedButton.icon(
              onPressed: () {
                _showReviewDialog(context);
              },
              icon: const Icon(Icons.star_rounded, size: 18),
              label: const Text("Leave 5-Star Review"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancel Booking?"),
        content: const Text("Cancelling more than 12 hours before appointment will refund 100% of your escrow deposit immediately."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Keep Booking")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking cancelled and escrow refunded to wallet.")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text("Confirm Cancellation"),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Review Trade Worker"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
                Icon(Icons.star, color: Colors.amber, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: "Share your experience with the craftsmanship...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Review submitted! Thank you.")),
              );
            },
            child: const Text("Submit Review"),
          ),
        ],
      ),
    );
  }
}
