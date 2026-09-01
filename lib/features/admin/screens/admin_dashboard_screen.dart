import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Platform Overview & Analytics',
                style:
                    TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Revenue Banner ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF581C87), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Platform Revenue',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13)),
                const SizedBox(height: 6),
                const Text('\$2,84,500',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _revenuePill('This Month', '\$42,300'),
                    const SizedBox(width: 12),
                    _revenuePill('Last Month', '\$38,100'),
                    const SizedBox(width: 12),
                    _revenuePill('Growth', '+11.0%'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── KPI Grid ──
          Row(
            children: [
              Expanded(
                  child: _kpiCard('Total Workers', '320',
                      Icons.engineering_rounded, AppColors.workerBrand)),
              const SizedBox(width: 10),
              Expanded(
                  child: _kpiCard('Active Workers', '186',
                      Icons.person_pin_rounded, AppColors.success)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _kpiCard('Total Customers', '1,240',
                      Icons.people_rounded, AppColors.customerBrand)),
              const SizedBox(width: 10),
              Expanded(
                  child: _kpiCard('Pending Verifications', '14',
                      Icons.pending_actions_rounded, AppColors.warning)),
            ],
          ),
          const SizedBox(height: 20),

          // ── Jobs Summary ──
          const Text('Jobs Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _jobStatCard(
                      'Active', '48', AppColors.info, AppColors.infoBg)),
              const SizedBox(width: 8),
              Expanded(
                  child: _jobStatCard('Pending', '23', AppColors.warning,
                      AppColors.warningBg)),
              const SizedBox(width: 8),
              Expanded(
                  child: _jobStatCard('Completed', '1,847',
                      AppColors.success, AppColors.successBg)),
              const SizedBox(width: 8),
              Expanded(
                  child: _jobStatCard('Cancelled', '36', AppColors.error,
                      AppColors.errorBg)),
            ],
          ),
          const SizedBox(height: 24),

          // ── Jobs by Status (Bar Chart) ──
          const Text('Jobs by Status',
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
                _barRow('Active', 48, 100, AppColors.info),
                const SizedBox(height: 10),
                _barRow('Pending', 23, 100, AppColors.warning),
                const SizedBox(height: 10),
                _barRow('In Progress', 35, 100, AppColors.customerBrand),
                const SizedBox(height: 10),
                _barRow('Completed', 92, 100, AppColors.success),
                const SizedBox(height: 10),
                _barRow('Cancelled', 8, 100, AppColors.error),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Jobs by Category ──
          const Text('Jobs by Category',
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
                ...MockData.categories.take(6).map((cat) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _barRow(
                          cat.name,
                          cat.workerCount,
                          MockData.categories
                              .fold<int>(
                                  0, (max, c) => c.workerCount > max ? c.workerCount : max),
                          cat.color),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Worker Activity ──
          const Text('Worker Activity (Last 7 Days)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _activityBar('Mon', 0.6, AppColors.adminBrand),
                _activityBar('Tue', 0.8, AppColors.adminBrand),
                _activityBar('Wed', 0.75, AppColors.adminBrand),
                _activityBar('Thu', 0.9, AppColors.adminBrand),
                _activityBar('Fri', 0.85, AppColors.adminBrand),
                _activityBar('Sat', 0.45, AppColors.textTertiary),
                _activityBar('Sun', 0.2, AppColors.textTertiary),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Booking Trends ──
          const Text('Booking Trends (Monthly)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _activityBar('Jun', 0.4, AppColors.customerBrand),
                _activityBar('Jul', 0.55, AppColors.customerBrand),
                _activityBar('Aug', 0.65, AppColors.customerBrand),
                _activityBar('Sep', 0.78, AppColors.customerBrand),
                _activityBar('Oct', 0.9, AppColors.customerBrand),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Quick Actions ──
          const Text('Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _actionChip(context, Icons.person_add_rounded, 'Add Worker'),
              _actionChip(context, Icons.verified_rounded, 'Verify Worker'),
              _actionChip(context, Icons.receipt_long_rounded, 'View Reports'),
              _actionChip(context, Icons.support_agent_rounded, 'Support'),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _revenuePill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _kpiCard(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: color),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('↑',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _jobStatCard(
      String label, String value, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _barRow(String label, int value, int max, Color color) {
    return Row(
      children: [
        SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / max,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
            width: 30,
            child: Text('$value',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _activityBar(String day, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 100 * height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(day,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _actionChip(BuildContext context, IconData icon, String label) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.adminBrand),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$label tapped')));
      },
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
    );
  }
}
