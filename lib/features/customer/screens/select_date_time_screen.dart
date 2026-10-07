import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import 'booking_confirmation_screen.dart';
import '../../../core/services/worker_service.dart';
import '../../../core/services/booking_service.dart';

class SelectDateTimeScreen extends StatefulWidget {
  final WorkerProfile worker;

  const SelectDateTimeScreen({super.key, required this.worker});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  int _selectedDateIndex = 0;
  String? _selectedTimeSlot;
  String? _selectedSlotId;
  bool _isCreatingBooking = false;
  double _estimatedHours = 4.0;
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionsController =
      TextEditingController();

  final List<DateTime> _actualDates = [];
  List<TimeSlot> _slots = [];
  bool _isLoadingSlots = false;

  String _monthLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[date.month - 1];
  }

  List<Map<String, String>> get _dates => _actualDates.map((date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final label = date.toIso8601String().split('T').first;
    return {
      'day': 'Day ${_actualDates.indexOf(date) + 1}',
      'date': label,
      'weekday': weekdays[date.weekday - 1],
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    for (int i = 1; i <= 5; i++) {
      _actualDates.add(today.add(Duration(days: i)));
    }
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() => _isLoadingSlots = true);
    final slots = await WorkerService.getWorkerAvailability(
      widget.worker.id,
      _actualDates[_selectedDateIndex],
      excludeReserved: true,
    );
    if (mounted) {
      setState(() {
        _slots = slots.where((s) => s.status == SlotStatus.available).toList();
        _selectedSlotId = _slots.isNotEmpty ? _slots.first.id : null;
        _selectedTimeSlot = _slots.isNotEmpty
            ? "${_slots.first.startTime} - ${_slots.first.endTime}"
            : null;
        _isLoadingSlots = false;
      });
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
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
      appBar: AppBar(title: const Text("Select Date & Time")),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.worker.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${widget.worker.trade} • \$${widget.worker.hourlyRate.toInt()}/hr",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Select Date
          const Text(
            "1. Select Appointment Date",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 86,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final d = _dates[index];
                final isSelected = _selectedDateIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedDateIndex = index);
                    _loadSlots();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.customerBrand
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.customerBrand
                            : AppColors.border,
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
                            color: isSelected
                                ? Colors.white70
                                : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${DateTime.parse(d["date"]!).day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _monthLabel(DateTime.parse(d["date"]!)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
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
          const Text(
            "2. Select Available Time Slot",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          if (_isLoadingSlots)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!_isLoadingSlots && _slots.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("No available slots for this date.")),
            ),
          if (!_isLoadingSlots)
            ..._slots.map((slotData) {
              final slot = "${slotData.startTime} - ${slotData.endTime}";
              final label = slotData.title ?? "Available";
              final isAvailable = slotData.status == SlotStatus.available;
              final isSelected = _selectedTimeSlot == slot && isAvailable;

              return InkWell(
                onTap: isAvailable
                    ? () => setState(() {
                        _selectedTimeSlot = slot;
                        final selected = _slots.firstWhere(
                          (s) => "${s.startTime} - ${s.endTime}" == slot,
                        );
                        _selectedSlotId = selected.id;
                        _estimatedHours =
                            (DateTime(
                                  2026,
                                  1,
                                  1,
                                  int.parse(selected.endTime.split(':')[0]),
                                  int.parse(selected.endTime.split(':')[1]),
                                )
                                .difference(
                                  DateTime(
                                    2026,
                                    1,
                                    1,
                                    int.parse(selected.startTime.split(':')[0]),
                                    int.parse(selected.startTime.split(':')[1]),
                                  ),
                                )
                                .inMinutes /
                            60.0);
                        // Server recalculates the authoritative duration and price.
                      })
                    : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? const Color(0xFFF1F5F9)
                        : (isSelected
                              ? AppColors.customerBrand.withValues(alpha: 0.08)
                              : AppColors.surface),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !isAvailable
                          ? AppColors.border
                          : (isSelected
                                ? AppColors.customerBrand
                                : AppColors.border),
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
                                : (isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off),
                            size: 18,
                            color: !isAvailable
                                ? AppColors.textTertiary
                                : (isSelected
                                      ? AppColors.customerBrand
                                      : AppColors.textSecondary),
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
                                  color: !isAvailable
                                      ? AppColors.textTertiary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: !isAvailable
                                      ? AppColors.textTertiary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: !isAvailable
                              ? const Color(0xFFE2E8F0)
                              : AppColors.successBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          !isAvailable ? "Booked" : "Available",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: !isAvailable
                                ? AppColors.textTertiary
                                : AppColors.success,
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
          const Text(
            "3. Job Details & Location",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _jobTitleController,
            decoration: const InputDecoration(
              labelText: "Job Title",
              hintText: "Enter a title for this job",
            ),
          ),
          const SizedBox(height: 12),
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
                const Text(
                  "Escrow Milestone Guarantee",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Labor (${_estimatedHours.toInt()}h @ \$${widget.worker.hourlyRate.toInt()}/hr)",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      "\$${laborCost.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Platform Guarantee & Dispute Escrow",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      "\$25.00",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Milestone Deposit",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${totalEscrow.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isCreatingBooking
                ? null
                : () async {
                    if (_selectedSlotId == null || _selectedTimeSlot == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select an available time slot.',
                          ),
                        ),
                      );
                      return;
                    }
                    if (_jobTitleController.text.trim().isEmpty ||
                        _jobDescriptionController.text.trim().isEmpty ||
                        _addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Job title, description, and address are required.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() => _isCreatingBooking = true);
                    try {
                      final created =
                          await BookingService.createCustomerJobBooking(
                            workerId: widget.worker.id,
                            slotId: _selectedSlotId!,
                            title: _jobTitleController.text,
                            description: _jobDescriptionController.text,
                            siteAddress: _addressController.text,
                            specialInstructions: _instructionsController.text,
                          );

                      final newBooking = CustomerBooking(
                        bookingId: created.bookingId,
                        worker: widget.worker,
                        serviceTitle: _jobTitleController.text.trim(),
                        categoryName: widget.worker.categoryId,
                        bookingDate: _dates[_selectedDateIndex]["date"]!,
                        timeSlot: _selectedTimeSlot ?? "",
                        address: _addressController.text,
                        jobDescription: _jobDescriptionController.text,
                        estimatedHours: _estimatedHours,
                        laborCost: created.laborCost,
                        serviceFee: created.serviceFee,
                        totalAmount: created.totalAmount,
                        status: JobStatus.readyToBook,
                        specialInstructions: _instructionsController.text,
                        bookingStatus: created.status,
                      );

                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingConfirmationScreen(booking: newBooking),
                        ),
                      );
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString().replaceFirst('Exception: ', ''),
                            ),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _isCreatingBooking = false);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customerBrand,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isCreatingBooking
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "Submit Booking Request",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
