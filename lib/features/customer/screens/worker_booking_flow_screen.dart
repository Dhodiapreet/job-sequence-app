import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/worker_service.dart';
import '../../../core/widgets/worker_card.dart';
import 'worker_profile_screen.dart';

class WorkerBookingFlowScreen extends StatefulWidget {
  final JobStep step;

  const WorkerBookingFlowScreen({
    super.key,
    required this.step,
  });

  @override
  State<WorkerBookingFlowScreen> createState() => _WorkerBookingFlowScreenState();
}

class _WorkerBookingFlowScreenState extends State<WorkerBookingFlowScreen> {
  List<WorkerProfile> _workers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final workers = await WorkerService.getWorkers(
        searchQuery: widget.step.tradeCategory,
      );
      if (!mounted) return;
      setState(() {
        _workers = workers;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Trade Worker')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.step.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.step.tradeCategory +
                              ' · ' +
                              widget.step.estimatedDuration,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_workers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Text(
                          'No matching workers are available yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._workers.map(
                      (worker) => WorkerCard(
                        worker: worker,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WorkerProfileScreen(worker: worker),
                          ),
                        ),
                        onBookNow: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WorkerProfileScreen(worker: worker),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
