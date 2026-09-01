import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';

class CustomerNotificationsScreen extends StatefulWidget {
  const CustomerNotificationsScreen({super.key});

  @override
  State<CustomerNotificationsScreen> createState() => _CustomerNotificationsScreenState();
}

class _CustomerNotificationsScreenState extends State<CustomerNotificationsScreen> {
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(MockData.sampleNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _notifications = _notifications.map((n) => NotificationItem(
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  timeAgo: n.timeAgo,
                  icon: n.icon,
                  color: n.color,
                  isRead: true,
                )).toList();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All notifications marked as read")),
              );
            },
            child: const Text("Mark All Read"),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 54, color: AppColors.textTertiary),
                  const SizedBox(height: 12),
                  const Text("No notifications yet", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("You will receive updates on booking milestones here.", style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notif.isRead ? AppColors.surface : const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: notif.isRead ? AppColors.border : const Color(0xFFBFDBFE),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notif.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(notif.icon, color: notif.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  notif.timeAgo,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.message,
                              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35),
                            ),
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
