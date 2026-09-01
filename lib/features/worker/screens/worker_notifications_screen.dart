import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';

class WorkerNotificationsScreen extends StatefulWidget {
  const WorkerNotificationsScreen({super.key});

  @override
  State<WorkerNotificationsScreen> createState() => _WorkerNotificationsScreenState();
}

class _WorkerNotificationsScreenState extends State<WorkerNotificationsScreen> {
  // Local mock data specifically for worker scenarios
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: 'n1',
        title: 'New Job Request',
        message: 'Preet sent a request for AC Repair on Friday at 9:00 AM.',
        timeAgo: 'Just now',
        icon: Icons.work_outline,
        color: AppColors.workerBrand,
        isRead: false,
      ),
      NotificationItem(
        id: 'n2',
        title: 'Booking Confirmed',
        message: 'Your plumbing job for John Doe has been finalized and added to your schedule.',
        timeAgo: '1 hour ago',
        icon: Icons.check_circle_outline,
        color: AppColors.success,
        isRead: false,
      ),
      NotificationItem(
        id: 'n3',
        title: 'Message from Customer',
        message: 'Emily: "Can you arrive 15 minutes early to inspect the gate?"',
        timeAgo: '2 hours ago',
        icon: Icons.message_outlined,
        color: AppColors.primary,
        isRead: true,
      ),
      NotificationItem(
        id: 'n4',
        title: 'Schedule Reminder',
        message: 'You have an upcoming Electrical Repair job in 45 minutes.',
        timeAgo: '3 hours ago',
        icon: Icons.access_time,
        color: AppColors.warning,
        isRead: true,
      ),
      NotificationItem(
        id: 'n5',
        title: 'Payout Initiated',
        message: 'Your earnings for project #10029 have been released to your bank account.',
        timeAgo: '1 day ago',
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.success,
        isRead: true,
      ),
    ];
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
                  const Text("You will receive job updates and alerts here.", style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return InkWell(
                  onTap: () {
                    // Mark as read when tapped
                    if (!notif.isRead) {
                      setState(() {
                        _notifications[index] = NotificationItem(
                          id: notif.id,
                          title: notif.title,
                          message: notif.message,
                          timeAgo: notif.timeAgo,
                          icon: notif.icon,
                          color: notif.color,
                          isRead: true,
                        );
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: notif.isRead ? AppColors.surface : AppColors.workerBrand.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: notif.isRead ? AppColors.border : AppColors.workerBrand.withValues(alpha: 0.3),
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
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: notif.isRead ? AppColors.textTertiary : AppColors.workerBrand,
                                      fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif.message,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
