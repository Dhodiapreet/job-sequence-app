import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/admin_service.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});
  @override
  State<AdminVerificationScreen> createState() => _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
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
        .toList();
    final pending = _workers
        .where((w) => w.verificationStatus == WorkerVerificationStatus.pending)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Verification',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Live Verification Queue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Worker verification data is shown only when it exists in the database.',
                    style: TextStyle(
                        fontSize: 12.5, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  _count('Pending', pending.length, AppColors.warning),
                  const SizedBox(height: 12),
                  if (pending.isEmpty)
                    const Text('No pending verifications.',
                        style: TextStyle(color: AppColors.textSecondary))
                  else
                    ...pending.map((w) => _workerCard(w)),
                  const SizedBox(height: 22),
                  _count('Verified', verified.length, AppColors.success),
                  const SizedBox(height: 12),
                  if (verified.isEmpty)
                    const Text('No verified workers yet.',
                        style: TextStyle(color: AppColors.textSecondary))
                  else
                    ...verified.map((w) => _workerCard(w)),
                ],
              ),
            ),
    );
  }

  Widget _count(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        Text(value.toString(),
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _workerCard(WorkerProfile worker) {
    final verified =
        worker.verificationStatus == WorkerVerificationStatus.verified;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(worker.trade,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(verified ? 'Verified' : 'Pending',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: verified ? AppColors.success : AppColors.warning)),
        ],
      ),
    );
  }
}
