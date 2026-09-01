import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../models/app_models.dart';

class StatusBadge extends StatelessWidget {
  final JobStatus status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case JobStatus.completed:
        bg = AppColors.successBg;
        fg = AppColors.success;
        label = "Completed";
        icon = Icons.check_circle_rounded;
        break;
      case JobStatus.inProgress:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = "In Progress";
        icon = Icons.engineering_rounded;
        break;
      case JobStatus.readyToBook:
        bg = AppColors.accentLight;
        fg = AppColors.accentDark;
        label = "Ready to Book";
        icon = Icons.person_add_alt_1_rounded;
        break;
      case JobStatus.booked:
        bg = const Color(0xFFEDE9FE);
        fg = const Color(0xFF6D28D9);
        label = "Worker Booked";
        icon = Icons.event_available_rounded;
        break;
      case JobStatus.underReview:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF9333EA);
        label = "Proof Under Review";
        icon = Icons.fact_check_rounded;
        break;
      case JobStatus.pendingPredecessor:
        bg = const Color(0xFFF1F5F9);
        fg = AppColors.textTertiary;
        label = "Waiting on Predecessor";
        icon = Icons.lock_clock_rounded;
        break;
      case JobStatus.cancelled:
        bg = const Color(0xFFF1F5F9);
        fg = AppColors.textTertiary;
        label = "Cancelled";
        icon = Icons.cancel_outlined;
        break;
      case JobStatus.blocked:
        bg = AppColors.errorBg;
        fg = AppColors.error;
        label = "Dependency Blocked";
        icon = Icons.warning_amber_rounded;
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }
}
