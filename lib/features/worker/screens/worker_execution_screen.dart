import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';

class WorkerExecutionScreen extends StatefulWidget {
  final JobStep step;

  const WorkerExecutionScreen({
    super.key,
    required this.step,
  });

  @override
  State<WorkerExecutionScreen> createState() => _WorkerExecutionScreenState();
}

class _WorkerExecutionScreenState extends State<WorkerExecutionScreen> {
  late List<bool> _checklistCompleted;
  int _photosUploaded = 2;
  bool _isUnderReview = false;

  @override
  void initState() {
    super.initState();
    _checklistCompleted = List.generate(
      widget.step.checklist.length,
      (index) => index < 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allChecklistPassed = _checklistCompleted.every((item) => item);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Execution & Checklist"),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded),
            tooltip: "Contact Property Owner",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Calling David Sterling (Property Owner)...")),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "STEP ${widget.step.sequenceOrder} IN SEQUENCE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "IN PROGRESS",
                        style: TextStyle(
                          color: Color(0xFF065F46),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.step.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Project: Complete Master Bathroom Remodel • 742 Evergreen Terrace",
                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.payments_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "Payout on Signoff: \$${widget.step.estimatedCost.toStringAsFixed(0)} (Escrow Secured)",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Prerequisite Step 1 (Demolition) signed off. Job site is cleared and ready for rough plumbing.",
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF065F46), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Mandatory Quality Checklist",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Complete all trade verification tasks to unlock milestone payment signoff.",
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          ...widget.step.checklist.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isChecked = _checklistCompleted[idx];

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isChecked ? AppColors.workerBrand.withValues(alpha: 0.4) : AppColors.border,
                ),
              ),
              child: CheckboxListTile(
                value: isChecked,
                activeColor: AppColors.workerBrand,
                title: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    color: isChecked ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _checklistCompleted[idx] = val ?? false;
                  });
                },
              ),
            );
          }),
          const SizedBox(height: 20),

          Text(
            "Proof of Work & Inspection Photos ($_photosUploaded Uploaded)",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Photos are verified by the client and municipal inspector before releasing escrow.",
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _photosUploaded++;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mock Worksite Photo Added!")),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.workerBrand, style: BorderStyle.solid, width: 1.5),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded, color: AppColors.workerBrand, size: 24),
                      SizedBox(height: 4),
                      Text("Add Photo", style: TextStyle(fontSize: 11, color: AppColors.workerBrand, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              _buildPhotoThumbnail("PEX Lines", Icons.plumbing_rounded),
              const SizedBox(width: 12),

              _buildPhotoThumbnail("Pressure Gauge", Icons.speed_rounded),
            ],
          ),
          const SizedBox(height: 28),

          if (!_isUnderReview) ...[
            ElevatedButton(
              onPressed: allChecklistPassed
                  ? () {
                      setState(() {
                        _isUnderReview = true;
                      });
                      _showSignoffSubmittedDialog(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.workerBrand,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                allChecklistPassed
                    ? "Submit for Milestone Signoff & Release (\$1,200)"
                    : "Complete All Checklist Tasks to Submit",
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC084FC)),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fact_check_rounded, color: Color(0xFF7C3AED)),
                      SizedBox(width: 8),
                      Text(
                        "Work Submitted for Client Review",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "David Sterling has received your checklist and photos. Once approved, \$1,200 will be deposited directly to your trade wallet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF6B21A8), height: 1.3),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(String caption, IconData icon) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 28),
          const SizedBox(height: 4),
          Text(
            caption,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSignoffSubmittedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.workerBrand, size: 26),
            SizedBox(width: 8),
            Text("Proof of Work Sent!"),
          ],
        ),
        content: const Text(
          "Checklist items and pressure test photos sent to David Sterling. Downstream contractor (Electrical Rough-in) will be notified once signoff completes.",
          style: TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.workerBrand),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }
}
