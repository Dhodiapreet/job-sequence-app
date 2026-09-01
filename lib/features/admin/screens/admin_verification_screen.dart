import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';

class AdminVerificationScreen extends StatelessWidget {
  const AdminVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workers = MockData.sampleWorkers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Verification',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9D5FF)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded,
                    color: AppColors.adminBrand, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Verification Queue',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.adminBrand)),
                      Text(
                        'Workers must submit trade licenses, insurance certificates, and background checks.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.adminBrand.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              Expanded(
                  child: _statCard('Verified', '${workers.where((w) => w.verificationStatus == WorkerVerificationStatus.verified).length}', AppColors.success)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statCard('Pending', '${workers.where((w) => w.verificationStatus == WorkerVerificationStatus.pending).length}', AppColors.warning)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statCard('Rejected', '${workers.where((w) => w.verificationStatus == WorkerVerificationStatus.rejected).length}', AppColors.error)),
            ],
          ),
          const SizedBox(height: 20),

          const Text('Pending Verifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Pending workers
          ...workers
              .where((w) =>
                  w.verificationStatus == WorkerVerificationStatus.pending)
              .map((w) => _buildVerificationCard(context, w, isPending: true)),

          const SizedBox(height: 20),
          const Text('Recently Verified',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...workers
              .where((w) =>
                  w.verificationStatus == WorkerVerificationStatus.verified)
              .map((w) => _buildVerificationCard(context, w, isPending: false)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildVerificationCard(BuildContext context, WorkerProfile w,
      {required bool isPending}) {
    final documents = [
      _DocItem(name: 'Trade License', status: isPending ? 'Submitted' : 'Verified', icon: Icons.badge_rounded),
      _DocItem(name: 'Insurance Certificate', status: isPending ? 'Submitted' : 'Verified', icon: Icons.shield_rounded),
      _DocItem(name: 'Background Check', status: isPending ? 'Pending Review' : 'Cleared', icon: Icons.fact_check_rounded),
      _DocItem(name: 'Government ID', status: isPending ? 'Submitted' : 'Verified', icon: Icons.credit_card_rounded),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPending
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Worker header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: w.avatarColor,
                child: Text(w.avatarInitials,
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
                    Text(w.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(w.trade,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    Text('${w.experienceYears} years experience • Safety: ${w.safetyScore}/100',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPending ? AppColors.warningBg : AppColors.successBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isPending ? 'Pending' : 'Verified',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPending ? AppColors.warning : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Documents
          const Text('Submitted Documents',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...documents.map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(doc.icon,
                        size: 16,
                        color: doc.status == 'Pending Review'
                            ? AppColors.warning
                            : doc.status == 'Verified' || doc.status == 'Cleared'
                                ? AppColors.success
                                : AppColors.info),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(doc.name,
                          style: const TextStyle(fontSize: 12.5)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: doc.status == 'Pending Review'
                            ? AppColors.warningBg
                            : doc.status == 'Verified' || doc.status == 'Cleared'
                                ? AppColors.successBg
                                : AppColors.infoBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(doc.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: doc.status == 'Pending Review'
                                ? AppColors.warning
                                : doc.status == 'Verified' || doc.status == 'Cleared'
                                    ? AppColors.success
                                    : AppColors.info,
                          )),
                    ),
                  ],
                ),
              )),

          // Actions
          if (isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${w.name} verification rejected')),
                      );
                    },
                    icon: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.error),
                    label: const Text('Reject',
                        style:
                            TextStyle(fontSize: 13, color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('${w.name} approved & verified!')),
                      );
                    },
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label:
                        const Text('Approve', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DocItem {
  final String name;
  final String status;
  final IconData icon;

  const _DocItem(
      {required this.name, required this.status, required this.icon});
}
