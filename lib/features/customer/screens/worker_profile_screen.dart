import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import 'select_date_time_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  final WorkerProfile worker;

  const WorkerProfileScreen({
    super.key,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${worker.name} saved to favorites")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Worker Profile Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: worker.avatarColor,
                  child: Text(
                    worker.avatarInitials,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      worker.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (worker.verificationStatus == WorkerVerificationStatus.verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, size: 20, color: AppColors.customerBrand),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  worker.trade,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: worker.isAvailableToday ? AppColors.successBg : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: worker.isAvailableToday ? AppColors.success : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            worker.isAvailableToday ? "Available for Booking" : "Busy Today",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: worker.isAvailableToday ? AppColors.success : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            "${worker.distanceKm} km away",
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(),
                const SizedBox(height: 12),

                // 4 Key Stats Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("Rating", "${worker.rating} ★", Colors.amber[800]!),
                    _buildStatItem("Experience", "${worker.experienceYears} Years", AppColors.textPrimary),
                    _buildStatItem("Completed", "${worker.jobsCompleted} Jobs", AppColors.success),
                    _buildStatItem("Safety", "${worker.safetyScore}%", AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pricing Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pricing & Rates", style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "\$${worker.hourlyRate.toStringAsFixed(0)}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                        const Text(" / hour", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Day Rate (8 hrs)", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text(
                        "\$${worker.dailyRate.toStringAsFixed(0)} / day",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About Section
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
                const Text("About Tradesperson", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  worker.bio,
                  style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.45),
                ),
                const SizedBox(height: 14),
                const Text("Badges & Certifications", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: worker.badges.map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.customerBrand.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.customerBrand.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined, size: 13, color: AppColors.customerBrand),
                        const SizedBox(width: 4),
                        Text(b, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.customerBrand)),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Skills Section
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
                const Text("Specialized Skills", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: worker.skills.map((skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reviews Section
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Client Reviews", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("${worker.reviewsCount} Total", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                if (worker.reviews.isEmpty) ...[
                  const Text("No written reviews yet for this trade worker.", style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ] else ...[
                  ...worker.reviews.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: Text(r.authorAvatar, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text(r.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text("${r.rating}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("Job: ${r.projectTitle}", style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 6),
                        Text(r.comment, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35)),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary Book Worker CTA
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectDateTimeScreen(worker: worker),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.customerBrand,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Book ${worker.name.split(' ')[0]} Now",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: valueColor),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
