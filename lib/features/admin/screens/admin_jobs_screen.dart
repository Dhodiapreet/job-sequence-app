import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';



class AdminJobsScreen extends StatefulWidget {
  const AdminJobsScreen({super.key});

  @override
  State<AdminJobsScreen> createState() => _AdminJobsScreenState();
}

class _AdminJobsScreenState extends State<AdminJobsScreen> {
  String _statusFilter = 'All';

  static const _mockJobs = [
    _MockJob(id: 'JOB-1021', customer: 'David Sterling', worker: 'Rohan Patel', service: 'Rough Plumbing', date: 'Oct 15, 2026', time: '09:00 AM', status: JobStatus.inProgress, location: '742 Evergreen Terrace'),
    _MockJob(id: 'JOB-1022', customer: 'Sarah Jenkins', worker: 'Darius Washington', service: 'Ceiling Fan Install', date: 'Oct 22, 2026', time: '10:00 AM', status: JobStatus.booked, location: '12 Maple Street'),
    _MockJob(id: 'JOB-1023', customer: 'Michael Chang', worker: 'Unassigned', service: 'Leaky Pipe Repair', date: 'Oct 24, 2026', time: '02:30 PM', status: JobStatus.readyToBook, location: '88 Oak Avenue'),
    _MockJob(id: 'JOB-1024', customer: 'Elena Rostova', worker: 'Marcus Vance', service: 'Kitchen Demolition', date: 'Nov 01, 2026', time: '08:00 AM', status: JobStatus.pendingPredecessor, location: '128 Commerce Blvd'),
    _MockJob(id: 'JOB-1025', customer: 'David Sterling', worker: 'Elena Geller', service: 'Tile Backsplash', date: 'Sep 28, 2026', time: '08:30 AM', status: JobStatus.completed, location: '742 Evergreen Terrace'),
    _MockJob(id: 'JOB-1026', customer: 'James Whitmore', worker: 'Tomoko Saito', service: 'AC Repair', date: 'Oct 18, 2026', time: '01:00 PM', status: JobStatus.cancelled, location: '55 Pine Road'),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredJobs = _statusFilter == 'All'
        ? _mockJobs
        : _mockJobs.where((j) => _statusLabel(j.status) == _statusFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Action triggered"))); }),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'In Progress', 'Booked', 'Ready', 'Pending', 'Completed', 'Cancelled']
                  .map((s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(s, style: const TextStyle(fontSize: 12)),
                          selected: _statusFilter == s,
                          selectedColor: AppColors.adminBrand.withValues(alpha: 0.15),
                          onSelected: (_) => setState(() => _statusFilter = s),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${filteredJobs.length} jobs',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Action triggered"))); },
                  icon: const Icon(Icons.sort_rounded, size: 16),
                  label: const Text('Sort', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final j = filteredJobs[index];
                return _buildJobCard(context, j);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, _MockJob job) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(job.id,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.adminBrand)),
              _statusBadge(job.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(job.service,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(job.customer,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 16),
              const Icon(Icons.engineering_outlined,
                  size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(job.worker,
                  style: TextStyle(
                    fontSize: 12,
                    color: job.worker == 'Unassigned'
                        ? AppColors.warning
                        : AppColors.textSecondary,
                    fontWeight: job.worker == 'Unassigned'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 13, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text('${job.date} at ${job.time}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined,
                  size: 13, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(job.location,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Job Details: ${job.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('Category: ${job.service}', style: const TextStyle(fontSize: 14)),
                          Text('Location: ${job.location}', style: const TextStyle(fontSize: 14)),
                          Text('Date: ${job.date} - ${job.time}', style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('View Details',
                    style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              if (job.status == JobStatus.readyToBook)
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Assigning worker to ${job.id}')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminBrand,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Text('Assign Worker',
                      style: TextStyle(fontSize: 11)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(JobStatus status) {
    Color color;
    Color bg;
    String label = _statusLabel(status);

    switch (status) {
      case JobStatus.inProgress:
        color = AppColors.info;
        bg = AppColors.infoBg;
      case JobStatus.booked:
        color = AppColors.customerBrand;
        bg = const Color(0xFFDBEAFE);
      case JobStatus.readyToBook:
        color = AppColors.warning;
        bg = AppColors.warningBg;
      case JobStatus.pendingPredecessor:
        color = AppColors.textTertiary;
        bg = AppColors.border;
      case JobStatus.completed:
        color = AppColors.success;
        bg = AppColors.successBg;
      case JobStatus.cancelled:
        color = AppColors.error;
        bg = AppColors.errorBg;
      default:
        color = AppColors.textTertiary;
        bg = AppColors.border;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  String _statusLabel(JobStatus status) {
    switch (status) {
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.booked:
        return 'Booked';
      case JobStatus.readyToBook:
        return 'Ready';
      case JobStatus.pendingPredecessor:
        return 'Pending';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}

class _MockJob {
  final String id, customer, worker, service, date, time, location;
  final JobStatus status;

  const _MockJob({
    required this.id,
    required this.customer,
    required this.worker,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    required this.location,
  });
}
