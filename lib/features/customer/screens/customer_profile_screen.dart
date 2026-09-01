import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit Profile opened")),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.customerBrand,
                  child: Text(
                    "DS",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "David Sterling",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                const Text(
                  "david.sterling@example.com • +1 (555) 234-8901",
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: 14, color: AppColors.success),
                      SizedBox(width: 4),
                      Text("Verified Property Owner", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Customer Stats
          Row(
            children: [
              Expanded(
                child: _buildStatTile("Active Projects", "3", Icons.account_tree_rounded, AppColors.customerBrand),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile("Jobs Booked", "12", Icons.handyman_rounded, AppColors.workerBrand),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile("Escrow Released", "\$8.4K", Icons.payments_rounded, AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Menu Sections
          const Text("Account & Management", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),

          _buildMenuTile(
            icon: Icons.location_on_outlined,
            title: "Saved Job Site Locations",
            subtitle: "742 Evergreen Terrace + 1 more",
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.credit_card_rounded,
            title: "Payment Methods & Escrow Card",
            subtitle: "Mastercard ending in 4242",
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.receipt_long_rounded,
            title: "Invoices & Receipts",
            subtitle: "Download VAT tax compliant invoices",
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.favorite_border_rounded,
            title: "Favorite Tradespeople",
            subtitle: "4 contractors saved",
            onTap: () {},
          ),
          const SizedBox(height: 20),

          const Text("Support & Security", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),

          _buildMenuTile(
            icon: Icons.shield_outlined,
            title: "Escrow Protection Policy",
            subtitle: "Learn about 100% money-back guarantee",
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.support_agent_rounded,
            title: "Customer Concierge Support",
            subtitle: "24/7 priority live assistance",
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.swap_horiz_rounded,
            title: "Switch Portal / Role",
            subtitle: "Return to role selection",
            iconColor: AppColors.primary,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  static Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.customerBrand, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
        onTap: onTap,
      ),
    );
  }
}
