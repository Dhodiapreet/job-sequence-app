import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting reports...')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Date range selector
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded,
                    color: AppColors.adminBrand, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Oct 1, 2026 - Oct 31, 2026',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Action triggered"))); },
                  child: const Text('Change',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Revenue section
          const Text('Revenue Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _reportCard('Gross Revenue', '\$42,300',
                      Icons.trending_up_rounded, AppColors.success)),
              const SizedBox(width: 10),
              Expanded(
                  child: _reportCard('Platform Fees', '\$6,345',
                      Icons.account_balance_rounded, AppColors.adminBrand)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _reportCard('Worker Payouts', '\$35,955',
                      Icons.payments_rounded, AppColors.workerBrand)),
              const SizedBox(width: 10),
              Expanded(
                  child: _reportCard('Avg. Job Value', '\$285',
                      Icons.insights_rounded, AppColors.customerBrand)),
            ],
          ),
          const SizedBox(height: 24),

          // Revenue Trend
          const Text('Revenue Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _trendRow('Week 1', 8200, 12000, AppColors.success),
                const SizedBox(height: 8),
                _trendRow('Week 2', 10500, 12000, AppColors.success),
                const SizedBox(height: 8),
                _trendRow('Week 3', 12000, 12000, AppColors.adminBrand),
                const SizedBox(height: 8),
                _trendRow('Week 4', 11600, 12000, AppColors.success),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Performance metrics
          const Text('Performance Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _performanceRow('Avg. Response Time', '12 min', AppColors.success),
          _performanceRow('Customer Satisfaction', '4.7 / 5.0', AppColors.success),
          _performanceRow('Job Completion Rate', '96.2%', AppColors.success),
          _performanceRow('Repeat Customer Rate', '64%', AppColors.info),
          _performanceRow('Dispute Rate', '1.8%', AppColors.warning),
          _performanceRow('Cancellation Rate', '3.2%', AppColors.error),

          const SizedBox(height: 24),

          // Top Workers
          const Text('Top Workers This Month',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _topWorkerRow(1, 'Rohan Patel', 'Plumber', 24, 4.95),
          _topWorkerRow(2, 'Darius Washington', 'Electrician', 21, 4.88),
          _topWorkerRow(3, 'Tomoko Saito', 'AC Technician', 18, 4.92),
          _topWorkerRow(4, 'Elena Geller', 'Mason/Tiler', 16, 4.78),
          _topWorkerRow(5, 'Marcus Vance', 'Carpenter', 14, 4.65),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _reportCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _trendRow(String week, int value, int max, Color color) {
    return Row(
      children: [
        SizedBox(
            width: 60,
            child: Text(week,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / max,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
            width: 50,
            child: Text('\$${(value / 1000).toStringAsFixed(1)}K',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _performanceRow(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13)),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ),
        ],
      ),
    );
  }

  Widget _topWorkerRow(
      int rank, String name, String trade, int jobs, double rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: rank <= 3
                ? AppColors.accent
                : AppColors.border,
            child: Text('$rank',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: rank <= 3
                        ? Colors.white
                        : AppColors.textSecondary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(trade,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$jobs jobs',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 12, color: Colors.amber),
                  Text(' $rating',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
