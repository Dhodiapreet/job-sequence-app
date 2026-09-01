import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../models/app_models.dart';

class WorkerCard extends StatelessWidget {
  final WorkerProfile worker;
  final VoidCallback onTap;
  final VoidCallback? onBookNow;
  final bool compact;

  const WorkerCard({
    super.key,
    required this.worker,
    required this.onTap,
    this.onBookNow,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: worker.avatarColor,
                    child: Text(
                      worker.avatarInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                worker.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (worker.verificationStatus == WorkerVerificationStatus.verified) ...[
                              const SizedBox(width: 3),
                              const Icon(Icons.verified, size: 13, color: AppColors.customerBrand),
                            ],
                          ],
                        ),
                        Text(
                          worker.trade,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        "${worker.rating}",
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " (${worker.reviewsCount})",
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  Text(
                    "${worker.distanceKm} km",
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${worker.hourlyRate.toStringAsFixed(0)}/hr",
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: worker.isAvailableToday ? AppColors.successBg : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      worker.isAvailableToday ? "Available" : "Booked",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: worker.isAvailableToday ? AppColors.success : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: worker.avatarColor,
                  child: Text(
                    worker.avatarInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (worker.verificationStatus == WorkerVerificationStatus.verified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 15, color: AppColors.customerBrand),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${worker.trade} • ${worker.experienceYears} yrs exp",
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            "${worker.rating}",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " (${worker.reviewsCount} reviews)",
                            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textTertiary),
                          Text(
                            "${worker.distanceKm} km",
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: worker.isAvailableToday ? AppColors.successBg : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        worker.isAvailableToday ? "Available" : "Busy Today",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: worker.isAvailableToday ? AppColors.success : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: worker.skills.take(3).map((skill) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    )).toList(),
                  ),
                ),
                if (onBookNow != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onBookNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customerBrand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Book", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
