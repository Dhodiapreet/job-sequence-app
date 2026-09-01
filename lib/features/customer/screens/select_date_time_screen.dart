import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import 'booking_confirmation_screen.dart';

class SelectDateTimeScreen extends StatefulWidget {
  final WorkerProfile worker;

  const SelectDateTimeScreen({
    super.key,
    required this.worker,
  });

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  int _selectedDateIndex = 0;
  String _selectedTimeSlot = "09:00 AM - 01:00 PM";
  double _estimatedHours = 4.0;
  final TextEditingController _jobDescriptionController = TextEditingController(
    text: "Fix bathroom water supply line & inspect shutoff valve.",
  );
  final TextEditingController _addressController = TextEditingController(
    text: "742 Evergreen Terrace, Metro West District",
  );
  final TextEditingController _instructionsController = TextEditingController(
    text: "Water meter and main shutoff are in the basement. Call on arrival.",
  );

  final List<Map<String, String>> _dates = [
    {"day": "Tomorrow", "date": "Oct 19", "weekday": "Mon"},
    {"day": "Oct 20", "date": "Oct 20", "weekday": "Tue"},
    {"day": "Oct 21", "date": "Oct 21", "weekday": "Wed"},
    {"day": "Oct 22", "date": "Oct 22", "weekday": "Thu"},
    {"day": "Oct 23", "date": "Oct 23", "weekday": "Fri"},
  ];

  final List<Map<String, dynamic>> _slots = [
    {"slot": "08:00 AM - 12:00 PM", "label": "Morning Shift (4h)", "isAvailable": true},
    {"slot": "09:00 AM - 01:00 PM", "label": "Recommended (4h)", "isAvailable": true},
    {"slot": "01:30 PM - 05:30 PM", "label": "Afternoon Shift (4h)", "isAvailable": true},
    {"slot": "08:00 AM - 04:30 PM", "label": "Full Day (8h)", "isAvailable": false},
  ];

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final laborCost = widget.worker.hourlyRate * _estimatedHours;
    const serviceFee = 25.0;
    final totalEscrow = laborCost + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Date & Time"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Selected Worker Header Mini Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: widget.worker.avatarColor,
                  child: Text(
                    widget.worker.avatarInitials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.worker.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("${widget.worker.trade} • \$${widget.worker.hourlyRate.toInt()}/hr", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Select Date
          const Text("1. Select Appointment Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          SizedBox(
            height: 78,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final d = _dates[index];
                final isSelected = _selectedDateIndex == index;
                return InkWell(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.customerBrand : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.customerBrand : AppColors.border,
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          d["weekday"]!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white70 : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d["date"]!.split(" ")[1],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d["day"] == "Tomorrow" ? "Tomorrow" : "Oct",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),

          // 2. Select Time Slot
          const Text("2. Select Available Time Slot", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ..._slots.map((slotData) {
            final slot = slotData["slot"] as String;
            final label = slotData["label"] as String;
            final isAvailable = slotData["isAvailable"] as bool;
            final isSelected = _selectedTimeSlot == slot && isAvailable;

            return InkWell(
              onTap: isAvailable
                  ? () => setState(() {
                        _selectedTimeSlot = slot;
                        _estimatedHours = slot.contains("8h") ? 8.0 : 4.0;
                      })
                  : null,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: !isAvailable
                      ? const Color(0xFFF1F5F9)
                      : (isSelected ? AppColors.customerBrand.withValues(alpha: 0.08) : AppColors.surface),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: !isAvailable
                        ? AppColors.border
                        : (isSelected ? AppColors.customerBrand : AppColors.border),
                    width: isSelected ? 1.8 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          !isAvailable
                              ? Icons.block_rounded
                              : (isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
                          size: 18,
                          color: !isAvailable
                              ? AppColors.textTertiary
                              : (isSelected ? AppColors.customerBrand : AppColors.textSecondary),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: !isAvailable ? AppColors.textTertiary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 11,
                                color: !isAvailable ? AppColors.textTertiary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: !isAvailable ? const Color(0xFFE2E8F0) : AppColors.successBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        !isAvailable ? "Booked" : "Available",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: !isAvailable ? AppColors.textTertiary : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 22),

          // 3. Job Details & Site Address
          const Text("3. Job Details & Location", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          TextField(
            controller: _jobDescriptionController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: "Job Scope / Problem Description",
              hintText: "Describe the tasks needing attention...",
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: "Job Site Address",
              prefixIcon: Icon(Icons.location_on_outlined, size: 20),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsController,
            decoration: const InputDecoration(
              labelText: "Special Access Instructions (Optional)",
              prefixIcon: Icon(Icons.info_outline, size: 20),
            ),
          ),
          const SizedBox(height: 24),

          // Escrow Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Escrow Milestone Guarantee", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Labor (${_estimatedHours.toInt()}h @ \$${widget.worker.hourlyRate.toInt()}/hr)", style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text("\$${laborCost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Platform Guarantee & Dispute Escrow", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text("\$25.00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Milestone Deposit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("\$${totalEscrow.toStringAsFixed(2)}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              final newBooking = CustomerBooking(
                bookingId: "BK-${1000 + DateTime.now().millisecond}",
                worker: widget.worker,
                serviceTitle: "${widget.worker.trade} Appointment",
                categoryName: widget.worker.categoryId,
                bookingDate: _dates[_selectedDateIndex]["date"]!,
                timeSlot: _selectedTimeSlot,
                address: _addressController.text,
                jobDescription: _jobDescriptionController.text,
                estimatedHours: _estimatedHours,
                laborCost: laborCost,
                serviceFee: serviceFee,
                totalAmount: totalEscrow,
                status: JobStatus.booked,
                specialInstructions: _instructionsController.text,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingConfirmationScreen(booking: newBooking),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customerBrand,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Review Booking & Lock In Escrow",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
