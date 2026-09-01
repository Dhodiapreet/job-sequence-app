import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';

class WorkerBookingFlowScreen extends StatefulWidget {
  final JobStep step;

  const WorkerBookingFlowScreen({
    super.key,
    required this.step,
  });

  @override
  State<WorkerBookingFlowScreen> createState() => _WorkerBookingFlowScreenState();
}

class _WorkerBookingFlowScreenState extends State<WorkerBookingFlowScreen> {
  WorkerProfile? _selectedWorker;
  String _selectedDate = "Tomorrow (Oct 19)";

  @override
  void initState() {
    super.initState();
    _selectedWorker = MockData.sampleWorkers.firstWhere(
      (w) => w.trade.toLowerCase().contains(widget.step.tradeCategory.toLowerCase().split(" ")[0]),
      orElse: () => MockData.sampleWorkers[1],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Vetted Trade Worker"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.build_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Target Step: ${widget.step.title}",
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        "Trade: ${widget.step.tradeCategory} • Est. Duration: ${widget.step.estimatedDuration}",
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Available Certified Workers",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          ...MockData.sampleWorkers.map((worker) {
            final isSelected = _selectedWorker?.id == worker.id;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedWorker = worker;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: worker.avatarColor,
                          child: Text(
                            worker.avatarInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    worker.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, size: 15, color: AppColors.customerBrand),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                worker.trade,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${worker.rating} (${worker.reviewsCount} reviews)",
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                                  Text(
                                    "${worker.distanceKm} km away",
                                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${worker.hourlyRate.toStringAsFixed(0)}/hr",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              "or \$480/day",
                              style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: worker.skills.take(3).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(s, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          const Text(
            "Select Scheduled Time Slot",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildChoiceChip(
                  title: "Oct 19, 2026",
                  subtitle: "Earliest Slot",
                  isSelected: _selectedDate == "Tomorrow (Oct 19)",
                  onTap: () => setState(() => _selectedDate = "Tomorrow (Oct 19)"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildChoiceChip(
                  title: "Oct 20, 2026",
                  subtitle: "Flexible",
                  isSelected: _selectedDate == "Oct 20",
                  onTap: () => setState(() => _selectedDate = "Oct 20"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Escrow Milestone Protection",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your deposit is held in platform escrow and is ONLY released to the tradesperson after you review and approve their uploaded proof of work photos.",
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Estimated Labor (2 Days)", style: TextStyle(fontSize: 13)),
                    Text("\$${widget.step.estimatedCost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Platform Escrow & Guarantee Fee (5%)", style: TextStyle(fontSize: 13)),
                    Text("\$47.50", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Milestone Escrow", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(
                      "\$${(widget.step.estimatedCost + 47.50).toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              _showBookingSuccessModal(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.customerBrand,
            ),
            child: const Text(
              "Lock In Sequence & Fund Milestone Escrow",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChoiceChip({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
            SizedBox(width: 10),
            Text("Booking Confirmed!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Step 3 (${widget.step.title}) has been scheduled with ${_selectedWorker?.name}.",
              style: const TextStyle(fontSize: 13.5, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Milestone escrow deposit is secured. The contractor has been alerted and will arrive once Step 2 rough plumbing inspection signs off.",
                style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Return to Timeline"),
          ),
        ],
      ),
    );
  }
}
