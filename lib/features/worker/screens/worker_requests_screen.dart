import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/worker_service.dart';

class WorkerRequestsScreen extends StatefulWidget {
  const WorkerRequestsScreen({super.key});

  @override
  State<WorkerRequestsScreen> createState() => _WorkerRequestsScreenState();
}

class _WorkerRequestsScreenState extends State<WorkerRequestsScreen> {
  List<WorkerBookingRequest> _requests = [];
  bool _isLoading = true;
  String? _error;
  final Set<String> _processing = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final requests = await WorkerService.getWorkerBookingRequests();
      if (!mounted) return;
      setState(() => _requests = requests);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRequestAction(WorkerBookingRequest req, bool isAccept) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAccept ? 'Accept Job Request?' : 'Decline Job Request?'),
        content: Text(isAccept
            ? 'Accept ${req.title} for ${req.startTime}–${req.endTime}?' 
            : 'Decline this booking request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccept ? AppColors.workerBrand : AppColors.error,
            ),
            child: Text(isAccept ? 'Accept' : 'Decline'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _processing.add(req.bookingId));
    try {
      await WorkerService.updateBookingStatus(
        bookingId: req.bookingId,
        status: isAccept ? 'ACCEPTED' : 'DECLINED',
      );
      if (!mounted) return;
      setState(() {
        _requests.removeWhere((item) => item.bookingId == req.bookingId);
        _processing.remove(req.bookingId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAccept ? 'Request accepted.' : 'Request declined.'),
          backgroundColor: isAccept ? AppColors.workerBrand : AppColors.error,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _processing.remove(req.bookingId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Requests', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text(_error!)),
                    ],
                  )
                : _requests.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(child: Text('No new booking requests.')),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _requests.length,
                        itemBuilder: (context, index) {
                          final req = _requests[index];
                          final busy = _processing.contains(req.bookingId);
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
                                      Expanded(child: Text(req.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                      Text('\$${req.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.workerBrand)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(req.description, style: const TextStyle(color: AppColors.textSecondary)),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 8),
                                    Text('${req.sequenceDate.year}-${req.sequenceDate.month.toString().padLeft(2, '0')}-${req.sequenceDate.day.toString().padLeft(2, '0')} at ${req.startTime}–${req.endTime}', style: const TextStyle(color: AppColors.textSecondary)),
                                  ]),
                                  const SizedBox(height: 8),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(req.siteAddress, style: const TextStyle(color: AppColors.textSecondary))),
                                  ]),
                                  if (req.specialInstructions.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text('Instructions: ${req.specialInstructions}', style: const TextStyle(color: AppColors.textSecondary)),
                                  ],
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: busy ? null : () => _handleRequestAction(req, false),
                                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                                          child: const Text('Decline'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: busy ? null : () => _handleRequestAction(req, true),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.workerBrand),
                                          child: busy
                                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                              : const Text('Accept'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
