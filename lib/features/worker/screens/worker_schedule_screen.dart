import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';
import 'worker_execution_screen.dart';

class WorkerScheduleScreen extends StatelessWidget {
  const WorkerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calendar view opened')));
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.sampleSchedule.length,
        itemBuilder: (context, index) {
          final slot = MockData.sampleSchedule[index];
          final isBreak = slot.status == SlotStatus.breakTime;
          final isAvailable = slot.status == SlotStatus.available;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isBreak ? AppColors.surface : isAvailable ? Colors.white : AppColors.workerBrand.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isBreak ? AppColors.border : isAvailable ? AppColors.success : AppColors.workerBrand.withValues(alpha: 0.3)
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.startTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(slot.endTime, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  width: 4,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isBreak ? AppColors.border : isAvailable ? AppColors.success : AppColors.workerBrand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.title ?? 'Available Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isBreak ? AppColors.textSecondary : AppColors.textPrimary)),
                      if (slot.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(slot.subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ]
                    ],
                  ),
                ),
                if (!isBreak && !isAvailable)
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkerExecutionScreen(step: MockData.sampleJobSteps[1]),
                        ),
                      );
                    },
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
