import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  static const _notifications = [
    _AdminNotif(title: 'New Worker Registration', message: 'James Rodriguez submitted KYC documents for Electrician verification.', time: '5 min ago', icon: Icons.person_add_rounded, color: AppColors.adminBrand, isRead: false),
    _AdminNotif(title: 'Dispute Raised', message: 'David Sterling raised a dispute on Rough Plumbing job (JOB-1021). Escrow hold of \$400 applied.', time: '25 min ago', icon: Icons.gavel_rounded, color: AppColors.error, isRead: false),
    _AdminNotif(title: 'High-Value Booking', message: 'Elena Rostova booked Kitchen Demolition for \$650. Worker: Marcus Vance assigned.', time: '1h ago', icon: Icons.book_online_rounded, color: AppColors.success, isRead: false),
    _AdminNotif(title: 'Worker Verification Approved', message: 'Tomoko Saito (AC Technician) passed all KYC and background checks. Now verified.', time: '3h ago', icon: Icons.verified_rounded, color: AppColors.success, isRead: true),
    _AdminNotif(title: 'Weekly Report Ready', message: 'Platform analytics report for Oct 7–13, 2026 is now available for download.', time: '1d ago', icon: Icons.bar_chart_rounded, color: AppColors.customerBrand, isRead: true),
    _AdminNotif(title: 'System Update', message: 'Scheduled maintenance window: Oct 20, 2:00 AM – 4:00 AM UTC. No service disruption expected.', time: '2d ago', icon: Icons.update_rounded, color: AppColors.textTertiary, isRead: true),
    _AdminNotif(title: 'Customer Feedback Alert', message: 'Customer satisfaction dropped below 4.5 for Painter category. Review needed.', time: '3d ago', icon: Icons.warning_amber_rounded, color: AppColors.warning, isRead: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text('Mark all read', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: n.isRead
                ? Colors.transparent
                : AppColors.adminBrand.withValues(alpha: 0.03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: n.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(n.icon, size: 20, color: n.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(n.title,
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: n.isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700)),
                          ),
                          if (!n.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.adminBrand,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(n.message,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.3)),
                      const SizedBox(height: 4),
                      Text(n.time,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AdminNotif {
  final String title, message, time;
  final IconData icon;
  final Color color;
  final bool isRead;

  const _AdminNotif({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.isRead,
  });
}
