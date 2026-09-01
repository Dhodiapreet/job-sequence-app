import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/worker_card.dart';
import 'worker_profile_screen.dart';

class WorkerSearchScreen extends StatefulWidget {
  const WorkerSearchScreen({super.key});

  @override
  State<WorkerSearchScreen> createState() => _WorkerSearchScreenState();
}

class _WorkerSearchScreenState extends State<WorkerSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = "";

  final List<String> _popularSearches = [
    "Master Plumber",
    "EV Charger Installation",
    "Drywall Patching",
    "Water Heater Replacement",
    "Tiling & Schluter",
    "Cabinet Joinery",
    "AC Mini-Split Repair",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _query.isEmpty
        ? <WorkerProfile>[]
        : MockData.sampleWorkers.where((w) {
            final q = _query.toLowerCase();
            return w.name.toLowerCase().contains(q) ||
                w.trade.toLowerCase().contains(q) ||
                w.skills.any((s) => s.toLowerCase().contains(q));
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (val) {
            setState(() {
              _query = val;
            });
          },
          decoration: InputDecoration(
            hintText: "Search workers, trades, skills...",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _query = "";
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _query.isEmpty
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Popular Searches",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _popularSearches.map((term) {
                    return ActionChip(
                      label: Text(term),
                      avatar: const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.customerBrand),
                      onPressed: () {
                        _controller.text = term;
                        setState(() {
                          _query = term;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Browse by Trade Category",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                ...MockData.categories.map((c) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(c.icon, color: c.color, size: 20),
                  ),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text("${c.workerCount} certified workers nearby", style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
                  onTap: () {
                    _controller.text = c.name;
                    setState(() {
                      _query = c.name;
                    });
                  },
                )),
              ],
            )
          : searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: 12),
                      Text("No trades found matching '$_query'", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text("Try searching for Electrician, Plumber, Tiler or Mason", style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final worker = searchResults[index];
                    return WorkerCard(
                      worker: worker,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkerProfileScreen(worker: worker),
                          ),
                        );
                      },
                      onBookNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkerProfileScreen(worker: worker),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
