import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  String _customerName = 'Customer';
  String _customerEmail = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await AuthService.getCurrentProfile();
    if (!mounted || profile == null) return;

    final name = (profile['full_name'] as String?)?.trim();
    final email = (profile['email'] as String?)?.trim();

    setState(() {
      _customerName = (name != null && name.isNotEmpty) ? name : 'Customer';
      _customerEmail = email ?? '';
    });
  }

  String get _customerInitials {
    final parts = _customerName.trim()
        .split(RegExp(r'\\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'CU';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

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
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.customerBrand,
                  child: Text(
                    _customerInitials,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _customerName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _customerEmail,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
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
            onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section opened"))); },
          ),
          _buildMenuTile(
            icon: Icons.credit_card_rounded,
            title: "Payment Methods & Escrow Card",
            subtitle: "Mastercard ending in 4242",
            onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section opened"))); },
          ),
          _buildMenuTile(
            icon: Icons.receipt_long_rounded,
            title: "Invoices & Receipts",
            subtitle: "Download VAT tax compliant invoices",
            onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section opened"))); },
          ),
          _buildMenuTile(
            icon: Icons.favorite_border_rounded,
            title: "Favorite Tradespeople",
            subtitle: "4 contractors saved",
            onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section opened"))); },
          ),
          const SizedBox(height: 20),

          const Text("Support & Security", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),

          _buildMenuTile(
            icon: Icons.shield_outlined,
            title: "Escrow Protection Policy",
            subtitle: "Learn about 100% money-back guarantee",
            onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section opened"))); },
          ),
          _buildMenuTile(
            icon: Icons.support_agent_rounded,
            title: "Customer Concierge Support",
            subtitle: "24/7 priority live assistance",
            onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section opened"))); },
          ),
          _buildMenuTile(
            icon: Icons.logout_rounded,
            title: "Sign Out",
            subtitle: "Log out of your account",
            iconColor: AppColors.primary,
            onTap: () async {
              try {
                await AuthService.signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                );
              }
            },
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


