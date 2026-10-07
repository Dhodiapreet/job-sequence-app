import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/admin_service.dart';

class AdminWorkersScreen extends StatefulWidget {
  const AdminWorkersScreen({super.key});
  @override
  State<AdminWorkersScreen> createState() => _AdminWorkersScreenState();
}

class _AdminWorkersScreenState extends State<AdminWorkersScreen> {
  List<WorkerProfile> _workers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final workers = await AdminService.getWorkers();
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
    final verified = _workers
        .where((w) => w.verificationStatus == WorkerVerificationStatus.verified)
        .length;
    final pending = _workers
        .where((w) => w.verificationStatus == WorkerVerificationStatus.pending)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _workers.isEmpty
              ? const Center(
                  child: Text('No workers yet.',
                      style: TextStyle(color: AppColors.textSecondary)),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Expanded(child: _summary('Workers', _workers.length)),
                          const SizedBox(width: 10),
                          Expanded(child: _summary('Verified', verified)),
                          const SizedBox(width: 10),
                          Expanded(child: _summary('Pending', pending)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ..._workers.map(_workerCard),
                    ],
                  ),
                ),
    );
  }

  Widget _summary(String title, int value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _workerCard(WorkerProfile worker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.workerBrand,
            child: Text(worker.avatarInitials,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(worker.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                Text(worker.trade,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  worker.verificationStatus == WorkerVerificationStatus.verified
                      ? 'Verified'
                      : 'Pending verification',
                  style: TextStyle(
                    fontSize: 11,
                    color: worker.verificationStatus ==
                            WorkerVerificationStatus.verified
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
          Text('₹' + worker.hourlyRate.toStringAsFixed(0) + '/hr',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
