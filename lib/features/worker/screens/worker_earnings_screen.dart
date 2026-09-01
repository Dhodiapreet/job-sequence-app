import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class WorkerEarningsScreen extends StatelessWidget {
  const WorkerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.workerBrand, Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                const Text('\$1,250.00', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Withdrawal'),
                          content: const Text('Withdraw \$450.00 to your linked bank account ending in 4242?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.workerBrand),
                              onPressed: () {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal initiated successfully!')));
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.workerBrand,
                    ),
                    child: const Text('Withdraw to Bank'),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTransactionRow('Electrical Repair', 'Oct 22, 2026', 150.0),
          _buildTransactionRow('Plumbing Fix', 'Oct 20, 2026', 85.0),
          _buildTransactionRow('AC Maintenance', 'Oct 18, 2026', 120.0),
          _buildTransactionRow('Withdrawal', 'Oct 15, 2026', -400.0, isWithdrawal: true),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(String title, String date, double amount, {bool isWithdrawal = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isWithdrawal ? AppColors.surface : AppColors.successBg,
        child: Icon(
          isWithdrawal ? Icons.account_balance_rounded : Icons.payments_rounded,
          color: isWithdrawal ? AppColors.textSecondary : AppColors.success,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: Text(
        '${isWithdrawal ? '' : '+'}\$${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isWithdrawal ? AppColors.textPrimary : AppColors.success,
        ),
      ),
    );
  }
}
