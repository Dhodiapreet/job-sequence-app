import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  static const _customers = [
    _MockCustomer(name: 'David Sterling', email: 'david.s@email.com', phone: '+1 (555) 234-8901', bookings: 12, spent: 4850.0, joined: 'Jun 2025', status: 'Active'),
    _MockCustomer(name: 'Sarah Jenkins', email: 'sarah.j@email.com', phone: '+1 (555) 876-5432', bookings: 8, spent: 2100.0, joined: 'Aug 2025', status: 'Active'),
    _MockCustomer(name: 'Michael Chang', email: 'michael.c@email.com', phone: '+1 (555) 345-6789', bookings: 5, spent: 1350.0, joined: 'Oct 2025', status: 'Active'),
    _MockCustomer(name: 'Elena Rostova', email: 'elena.r@email.com', phone: '+1 (555) 112-3344', bookings: 15, spent: 8920.0, joined: 'Mar 2025', status: 'Active'),
    _MockCustomer(name: 'James Whitmore', email: 'james.w@email.com', phone: '+1 (555) 998-7654', bookings: 2, spent: 480.0, joined: 'Sep 2026', status: 'New'),
    _MockCustomer(name: 'Priya Sharma', email: 'priya.sh@email.com', phone: '+1 (555) 443-2211', bookings: 0, spent: 0.0, joined: 'Sep 2026', status: 'Inactive'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Summary row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _summaryCard('Total', '1,240', AppColors.customerBrand)),
                const SizedBox(width: 8),
                Expanded(child: _summaryCard('Active', '892', AppColors.success)),
                const SizedBox(width: 8),
                Expanded(child: _summaryCard('New (30d)', '67', AppColors.info)),
                const SizedBox(width: 8),
                Expanded(child: _summaryCard('Inactive', '81', AppColors.textTertiary)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final c = _customers[index];
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
                        radius: 22,
                        backgroundColor: AppColors.customerBrand.withValues(alpha: 0.1),
                        child: Text(
                          c.name.split(' ').map((e) => e[0]).join(),
                          style: const TextStyle(
                              color: AppColors.customerBrand,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(c.name,
                                    style: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: c.status == 'Active'
                                        ? AppColors.successBg
                                        : c.status == 'New'
                                            ? AppColors.infoBg
                                            : AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(c.status,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: c.status == 'Active'
                                            ? AppColors.success
                                            : c.status == 'New'
                                                ? AppColors.info
                                                : AppColors.textTertiary,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(c.email,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('${c.bookings} bookings',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textTertiary)),
                                const SizedBox(width: 10),
                                Text('\$${c.spent.toStringAsFixed(0)} spent',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(width: 10),
                                Text('Since ${c.joined}',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textTertiary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$val: ${c.name}')),
                          );
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'View', child: Text('View Profile')),
                          const PopupMenuItem(value: 'Bookings', child: Text('View Bookings')),
                          const PopupMenuItem(value: 'Suspend', child: Text('Suspend')),
                        ],
                        icon: const Icon(Icons.more_vert_rounded,
                            color: AppColors.textTertiary, size: 20),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

class _MockCustomer {
  final String name, email, phone, joined, status;
  final int bookings;
  final double spent;

  const _MockCustomer({
    required this.name,
    required this.email,
    required this.phone,
    required this.bookings,
    required this.spent,
    required this.joined,
    required this.status,
  });
}
