import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class CustomerSettingsScreen extends StatefulWidget {
  const CustomerSettingsScreen({super.key});

  @override
  State<CustomerSettingsScreen> createState() => _CustomerSettingsScreenState();
}

class _CustomerSettingsScreenState extends State<CustomerSettingsScreen> {
  bool _pushNotifications = true;
  bool _smsUpdates = true;
  bool _escrowAutoRelease = false;
  bool _darkMode = false;
  String _selectedCurrency = "USD (\$)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings & Preferences"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications Settings
          const Text("Notifications & Alerts", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Push Notifications", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text("Instant alerts when workers depart or submit proof", style: TextStyle(fontSize: 12)),
                  activeThumbColor: AppColors.customerBrand,
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text("SMS Milestones Updates", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text("Receive verification codes and arrival PINs via SMS", style: TextStyle(fontSize: 12)),
                  activeThumbColor: AppColors.customerBrand,
                  value: _smsUpdates,
                  onChanged: (val) => setState(() => _smsUpdates = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Escrow & Payments Settings
          const Text("Escrow & Booking Safeguards", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Require 2-Factor Signoff for Payouts", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text("Always confirm with biometric/PIN before releasing escrow", style: TextStyle(fontSize: 12)),
                  activeThumbColor: AppColors.customerBrand,
                  value: !_escrowAutoRelease,
                  onChanged: (val) => setState(() => _escrowAutoRelease = !val),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text("Default Currency", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(_selectedCurrency, style: const TextStyle(fontSize: 12, color: AppColors.customerBrand)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
                  onTap: () {
                    _showCurrencyPicker(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance & General
          const Text("General Preferences", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Dark Theme (Beta)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text("Switch to high-contrast dark palette", style: TextStyle(fontSize: 12)),
                  activeThumbColor: AppColors.customerBrand,
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text("Privacy & Data Permissions", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
                  onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preference selected"))); },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text("Terms of Service & Guarantee", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
                  onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preference selected"))); },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Text(
              "JobSequence Pro v1.0.0 (Build 2026.09)",
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Currency", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              title: const Text("USD (\$) - United States Dollar"),
              onTap: () {
                setState(() => _selectedCurrency = "USD (\$)");
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("CAD (\$) - Canadian Dollar"),
              onTap: () {
                setState(() => _selectedCurrency = "CAD (\$)");
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("GBP (£) - British Pound"),
              onTap: () {
                setState(() => _selectedCurrency = "GBP (£)");
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
