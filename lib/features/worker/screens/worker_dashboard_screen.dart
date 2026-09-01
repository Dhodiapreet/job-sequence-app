import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';
import 'worker_execution_screen.dart';

import 'worker_notifications_screen.dart';

class WorkerDashboardScreen extends StatelessWidget {
  const WorkerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerNotificationsScreen()));
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeHeader(context),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildTodaySchedule(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.workerBrand,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hello, Rohan!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('You have 3 jobs scheduled for today.', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkerExecutionScreen(step: MockData.sampleJobSteps[1]),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.workerBrand,
            ),
            child: const Text('View Active Job'),
          )
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Today\'s Earnings', '\$280', Icons.payments_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Pending Requests', '2', Icons.pending_actions_rounded)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.workerBrand),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today\'s Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...MockData.sampleSchedule.take(3).map((slot) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: slot.status == SlotStatus.breakTime ? AppColors.surface : AppColors.workerBrand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: slot.status == SlotStatus.breakTime ? AppColors.border : AppColors.workerBrand.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(slot.startTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(slot.endTime, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.title ?? 'Available', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (slot.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(slot.subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ]
                    ],
                  ),
                ),
                if (slot.status == SlotStatus.booked)
                  const Icon(Icons.check_circle, color: AppColors.workerBrand)
              ],
            ),
          );
        })
      ],
    );
  }
}
