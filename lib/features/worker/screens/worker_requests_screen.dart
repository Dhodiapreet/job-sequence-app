import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';

class WorkerRequestsScreen extends StatefulWidget {
  const WorkerRequestsScreen({super.key});

  @override
  State<WorkerRequestsScreen> createState() => _WorkerRequestsScreenState();
}

class _WorkerRequestsScreenState extends State<WorkerRequestsScreen> {
  // Local state to track the status of requests (pending, accepted, declined)
  final Map<String, String> _requestStatuses = {};

  void _handleRequestAction(JobRequest req, bool isAccept) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAccept ? 'Accept Job Request?' : 'Decline Job Request?'),
        content: Text(isAccept 
            ? 'Are you sure you want to accept the request for ${req.serviceTitle} from ${req.customerName}? This will be added to your schedule.'
            : 'Are you sure you want to decline this request? The customer will be notified to find another worker.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Cancel makes no changes
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _requestStatuses[req.id] = isAccept ? 'accepted' : 'declined';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isAccept ? 'Request accepted! Added to schedule.' : 'Request declined.'),
                  backgroundColor: isAccept ? AppColors.workerBrand : AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccept ? AppColors.workerBrand : AppColors.error,
            ),
            child: Text(isAccept ? 'Accept' : 'Decline'),
          ),
        ],
      ),
    );
  }

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
                final status = _requestStatuses[req.id] ?? 'pending';
                
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
                            Expanded(child: Text(req.serviceTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
                            Expanded(child: Text('${req.location} (${req.distanceKm} km away)', style: const TextStyle(color: AppColors.textSecondary))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        if (status == 'pending')
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _handleRequestAction(req, false),
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
                                  onPressed: () => _handleRequestAction(req, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.workerBrand,
                                  ),
                                  child: const Text('Accept'),
                                ),
                              ),
                            ],
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: status == 'accepted' 
                                  ? AppColors.workerBrand.withValues(alpha: 0.1)
                                  : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  status == 'accepted' ? Icons.check_circle : Icons.cancel,
                                  color: status == 'accepted' ? AppColors.workerBrand : AppColors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  status == 'accepted' ? 'Request Accepted' : 'Request Declined',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: status == 'accepted' ? AppColors.workerBrand : AppColors.error,
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
