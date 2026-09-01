import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import 'customer_sequence_view.dart';

class CustomerProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const CustomerProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Overview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Action triggered"))); },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "ID: ${project.id}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Active Pipeline",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      "${project.locationAddress}, ${project.city}",
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetric("Total Budget", "\$${project.totalBudget.toStringAsFixed(0)}"),
                    _buildMetric("Funded Escrow", "\$${project.amountPaid.toStringAsFixed(0)}"),
                    _buildMetric("Progress", "${(project.progressPercent * 100).toInt()}%"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action CTA to Sequencing
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerSequenceView(project: project),
                ),
              );
            },
            icon: const Icon(Icons.timeline_rounded),
            label: const Text("Open Sequence Dependency Pipeline"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.customerBrand,
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Project Milestones & Steps",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          ...project.steps.map((step) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    "${step.sequenceOrder}",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${step.tradeCategory} â€¢ Est. \$${step.estimatedCost.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                _buildStepBadge(step.status),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStepBadge(JobStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case JobStatus.completed:
        bg = AppColors.successBg;
        fg = AppColors.success;
        label = "Done";
        break;
      case JobStatus.inProgress:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = "Active";
        break;
      case JobStatus.readyToBook:
        bg = AppColors.accentLight;
        fg = AppColors.accentDark;
        label = "Book Now";
        break;
      case JobStatus.booked:
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF6D28D9);
        label = "Booked";
        break;
      case JobStatus.underReview:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        label = "Review";
        break;
      case JobStatus.pendingPredecessor:
      default:
        bg = const Color(0xFFF1F5F9);
        fg = AppColors.textTertiary;
        label = "Locked";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
