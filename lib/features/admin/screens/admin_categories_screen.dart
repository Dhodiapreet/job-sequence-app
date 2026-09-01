import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = MockData.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories & Skills',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.adminBrand.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('${categories.length}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.adminBrand)),
                      const Text('Active Categories',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.adminBrand)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.workerBrand.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${categories.fold<int>(0, (sum, c) => sum + c.workerCount)}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.workerBrand),
                      ),
                      const Text('Total Workers',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.workerBrand)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text('Service Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...categories.map((cat) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${cat.workerCount} active workers',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Switch(
                      value: true,
                      onChanged: (_) {},
                      activeThumbColor: AppColors.adminBrand,
                    ),
                    PopupMenuButton<String>(
                      onSelected: (val) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$val: ${cat.name}')),
                        );
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'Edit', child: Text('Edit')),
                        const PopupMenuItem(
                            value: 'View Workers',
                            child: Text('View Workers')),
                        const PopupMenuItem(
                            value: 'Disable', child: Text('Disable')),
                      ],
                      icon: const Icon(Icons.more_vert_rounded,
                          color: AppColors.textTertiary, size: 20),
                    ),
                  ],
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.adminBrand,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Category form opening...')),
          );
        },
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
