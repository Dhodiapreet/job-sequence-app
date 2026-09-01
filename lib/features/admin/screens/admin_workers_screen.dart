import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';

class AdminWorkersScreen extends StatefulWidget {
  const AdminWorkersScreen({super.key});

  @override
  State<AdminWorkersScreen> createState() => _AdminWorkersScreenState();
}

class _AdminWorkersScreenState extends State<AdminWorkersScreen> {
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final workers = MockData.sampleWorkers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Verified', 'Pending', 'Rejected']
                  .map((s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          selected: _filterStatus == s,
                          selectedColor:
                              AppColors.adminBrand.withValues(alpha: 0.15),
                          onSelected: (_) =>
                              setState(() => _filterStatus = s),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Summary row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${workers.length} workers',
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('Export', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          // Worker list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final w = workers[index];
                return _WorkerCard(
                  worker: w,
                  onTap: () => _showWorkerDetail(context, w),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.adminBrand,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Worker form opening...')),
          );
        },
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Workers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('By Trade',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Electrician', 'Plumber', 'Carpenter', 'Painter', 'AC Tech']
                  .map((t) => FilterChip(
                        label: Text(t, style: const TextStyle(fontSize: 12)),
                        onSelected: (_) {},
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('By Rating',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['4.5+', '4.0+', '3.5+', 'Any']
                  .map((r) => FilterChip(
                        label: Text(r, style: const TextStyle(fontSize: 12)),
                        onSelected: (_) {},
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminBrand),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkerDetail(BuildContext context, WorkerProfile w) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: w.avatarColor,
                child: Text(w.avatarInitials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(w.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Text(w.trade,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _detailStat('Rating', '${w.rating}'),
                _detailStat('Jobs', '${w.jobsCompleted}'),
                _detailStat('Experience', '${w.experienceYears}yr'),
                _detailStat('Safety', '${w.safetyScore}%'),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on_rounded,
                  color: AppColors.textSecondary, size: 20),
              title: Text(w.location,
                  style: const TextStyle(fontSize: 13)),
              dense: true,
            ),
            ListTile(
              leading: Icon(
                w.isAvailableToday
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: w.isAvailableToday
                    ? AppColors.success
                    : AppColors.error,
                size: 20,
              ),
              title: Text(
                w.isAvailableToday
                    ? 'Available Today'
                    : 'Not Available Today',
                style: const TextStyle(fontSize: 13),
              ),
              dense: true,
            ),
            const SizedBox(height: 8),
            const Text('Skills',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: w.skills
                  .map((s) => Chip(
                        label: Text(s, style: const TextStyle(fontSize: 11)),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Action taken on ${w.name}')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.adminBrand),
                    child: const Text('Manage'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final WorkerProfile worker;
  final VoidCallback onTap;

  const _WorkerCard({required this.worker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              radius: 22,
              backgroundColor: worker.avatarColor,
              child: Text(worker.avatarInitials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(worker.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      if (worker.verificationStatus ==
                          WorkerVerificationStatus.verified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            size: 14, color: AppColors.customerBrand),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(worker.trade,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${worker.rating}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      Icon(
                        worker.isAvailableToday
                            ? Icons.circle
                            : Icons.circle_outlined,
                        size: 8,
                        color: worker.isAvailableToday
                            ? AppColors.success
                            : AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        worker.isAvailableToday
                            ? 'Available'
                            : 'Unavailable',
                        style: TextStyle(
                          fontSize: 11,
                          color: worker.isAvailableToday
                              ? AppColors.success
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${worker.jobsCompleted} jobs',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
