import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/admin_service.dart';

class AdminJobsScreen extends StatefulWidget {
  const AdminJobsScreen({super.key});
  @override
  State<AdminJobsScreen> createState() => _AdminJobsScreenState();
}

class _AdminJobsScreenState extends State<AdminJobsScreen> {
  List<AdminJob> _jobs = [];
  String _filter = 'All';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final jobs = await AdminService.getJobs();
      if (!mounted) return;
      setState(() {
        _jobs = jobs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<AdminJob> get _filtered {
    if (_filter == 'All') return _jobs;
    return _jobs.where((job) => job.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: ['All', 'DRAFT', 'PUBLISHED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED']
                        .map((status) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(status == 'All' ? 'All' : status),
                                selected: _filter == status,
                                onSelected: (_) =>
                                    setState(() => _filter = status),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(
                          child: Text('No live jobs yet.',
                              style: TextStyle(
                                  color: AppColors.textSecondary)))
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final job = _filtered[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          job.title,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        _status(job.status),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Customer: ' + job.customer,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary),
                                    ),
                                    if (job.location.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        job.location,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textTertiary),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Text(
                                      job.date,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _status(String status) {
    final color = switch (status) {
      'COMPLETED' => AppColors.success,
      'CANCELLED' => AppColors.error,
      'IN_PROGRESS' => AppColors.info,
      'PUBLISHED' => AppColors.customerBrand,
      _ => AppColors.warning,
    };
    return Text(status,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: color));
  }
}
