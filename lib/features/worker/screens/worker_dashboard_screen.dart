import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/worker_service.dart';
import 'worker_notifications_screen.dart';
import 'worker_requests_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});
  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  String _name = 'Worker';
  int _pendingRequests = 0;
  int _completedJobs = 0;
  List<TimeSlot> _todaySlots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final profileFuture = AuthService.getCurrentProfile();
      final requestsFuture = WorkerService.getWorkerBookingRequests();
      final workerId = AuthService.currentUser?.id;
      final slotsFuture = workerId == null
          ? Future.value(<TimeSlot>[])
          : WorkerService.getWorkerAvailability(workerId, DateTime.now());

      final results = await Future.wait<dynamic>([
        profileFuture,
        requestsFuture,
        slotsFuture,
      ]);
      final profile = results[0] as Map<String, dynamic>?;
      final requests = results[1] as List<WorkerBookingRequest>;
      final slots = results[2] as List<TimeSlot>;

      if (!mounted) return;
      setState(() {
        _name = (profile?['full_name'] as String?)?.trim().isNotEmpty == true
            ? (profile!['full_name'] as String).trim()
            : 'Worker';
        _pendingRequests = requests.length;
        _completedJobs = (profile?['jobs_completed'] as num?)?.toInt() ?? 0;
        _todaySlots = slots;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const WorkerNotificationsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.workerBrand,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ' + _name + '!',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pendingRequests == 0
                        ? 'No pending job requests.'
                        : _pendingRequests.toString() +
                            ' pending job request' +
                            (_pendingRequests == 1 ? '.' : 's.'),
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const WorkerRequestsScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.workerBrand,
                    ),
                    child: const Text('View Job Requests'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: _stat('Pending Requests',
                        _pendingRequests.toString(),
                        Icons.pending_actions_rounded)),
                const SizedBox(width: 12),
                Expanded(
                    child: _stat('Completed Jobs',
                        _completedJobs.toString(),
                        Icons.check_circle_outline_rounded)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Today's Schedule",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_todaySlots.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No availability for today.',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ..._todaySlots.map((slot) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(slot.startTime,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(slot.endTime,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            slot.status == SlotStatus.available
                                ? 'Available'
                                : slot.status == SlotStatus.booked
                                    ? 'Booked'
                                    : 'Blocked',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(
                          slot.status == SlotStatus.available
                              ? Icons.event_available_rounded
                              : slot.status == SlotStatus.booked
                                  ? Icons.event_busy_rounded
                                  : Icons.block_rounded,
                          color: slot.status == SlotStatus.available
                              ? AppColors.success
                              : AppColors.textTertiary,
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) {
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
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
