import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import 'worker_booking_flow_screen.dart';

class CustomerSequenceView extends StatelessWidget {
  final Project project;

  const CustomerSequenceView({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Sequencing & Timeline"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              _showSequenceInfo(context);
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
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "SEQUENCING DAG PIPELINE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "6 Steps Total",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Location: ${project.locationAddress}, ${project.city}",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sequence Progress",
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: project.progressPercent,
                              backgroundColor: Colors.white.withValues(alpha: 0.25),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${(project.progressPercent * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_clock_rounded, size: 20, color: Color(0xFF2563EB)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Job Sequencing Rules: Downstream trade tasks (like Drywall & Tiling) are automatically locked until upstream prerequisite work (Rough Plumbing & Electrical) passes verification.",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF1E40AF),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Trade Execution Pipeline",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          ...project.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == project.steps.length - 1;

            return _buildTimelineStepCard(context, step, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStepCard(BuildContext context, JobStep step, bool isLast) {
    Color connectorColor;
    IconData stepIcon;
    Color iconColor;

    switch (step.status) {
      case JobStatus.completed:
        connectorColor = AppColors.success;
        stepIcon = Icons.check_circle_rounded;
        iconColor = AppColors.success;
        break;
      case JobStatus.inProgress:
        connectorColor = AppColors.info;
        stepIcon = Icons.engineering_rounded;
        iconColor = AppColors.info;
        break;
      case JobStatus.readyToBook:
        connectorColor = AppColors.accent;
        stepIcon = Icons.lock_open_rounded;
        iconColor = AppColors.accent;
        break;
      case JobStatus.booked:
        connectorColor = const Color(0xFF7C3AED);
        stepIcon = Icons.person_pin_rounded;
        iconColor = const Color(0xFF7C3AED);
        break;
      case JobStatus.underReview:
        connectorColor = const Color(0xFF9333EA);
        stepIcon = Icons.fact_check_rounded;
        iconColor = const Color(0xFF9333EA);
        break;
      case JobStatus.cancelled:
      case JobStatus.pendingPredecessor:
      case JobStatus.blocked:
        connectorColor = AppColors.border;
        stepIcon = Icons.lock_outline_rounded;
        iconColor = AppColors.textTertiary;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor, width: 1.5),
                  ),
                  child: Icon(stepIcon, size: 16, color: iconColor),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: connectorColor.withValues(alpha: 0.4),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: step.status == JobStatus.readyToBook
                        ? AppColors.accent.withValues(alpha: 0.6)
                        : (step.status == JobStatus.inProgress
                            ? AppColors.info.withValues(alpha: 0.6)
                            : AppColors.border),
                    width: (step.status == JobStatus.readyToBook || step.status == JobStatus.inProgress) ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            "Step ${step.sequenceOrder}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          step.tradeCategory,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        _buildStatusChip(step.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          step.estimatedDuration,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 14),
                        const Icon(Icons.payments_outlined, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          "\$${step.estimatedCost.toStringAsFixed(0)} Est.",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),

                    if (step.assignedWorkerName != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                step.assignedWorkerAvatar ?? "W",
                                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${step.assignedWorkerName} (${step.assignedWorkerTrade})",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Icon(Icons.verified_rounded, size: 14, color: AppColors.success),
                          ],
                        ),
                      ),
                    ],

                    if (step.status == JobStatus.readyToBook) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkerBookingFlowScreen(step: step),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_search_rounded, size: 16),
                          label: const Text("Find & Book Trade Worker"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],

                    if (step.status == JobStatus.pendingPredecessor) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Requires Step ${step.dependsOnStepIds.map((id) => id.replaceAll('step-', '')).join(', ')} completion before hiring",
                              style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(JobStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case JobStatus.completed:
        bg = AppColors.successBg;
        fg = AppColors.success;
        label = "Completed";
        break;
      case JobStatus.inProgress:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = "In Progress";
        break;
      case JobStatus.readyToBook:
        bg = AppColors.accentLight;
        fg = AppColors.accentDark;
        label = "Ready to Book";
        break;
      case JobStatus.booked:
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF6D28D9);
        label = "Booked";
        break;
      case JobStatus.underReview:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        label = "In Review";
        break;
      case JobStatus.cancelled:
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

  void _showSequenceInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.schema_rounded, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text(
                    "Job Sequencing DAG Logic",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Our platform uses a Directed Acyclic Graph (DAG) for blue-collar renovation projects. Contractors are only dispatched when their upstream dependencies are satisfied, preventing expensive scheduling clashes and waiting delays.",
                style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Understood"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
