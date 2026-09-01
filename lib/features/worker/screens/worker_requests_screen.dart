import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';

class WorkerRequestsScreen extends StatelessWidget {
  const WorkerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Requests', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: MockData.sampleJobRequests.isEmpty
          ? const Center(child: Text('No new job requests at the moment.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.sampleJobRequests.length,
              itemBuilder: (context, index) {
                final req = MockData.sampleJobRequests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(req.serviceTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('\$${req.estimatedEarnings.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.workerBrand)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(req.customerName, style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text('${req.date} at ${req.time}', style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text('${req.location} (${req.distanceKm} km away)', style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request declined')));
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.error),
                                  foregroundColor: AppColors.error,
                                ),
                                child: const Text('Decline'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request accepted! Added to schedule.')));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.workerBrand,
                                ),
                                child: const Text('Accept'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
