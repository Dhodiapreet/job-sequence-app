import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/widgets/worker_card.dart';
import 'worker_profile_screen.dart';

class WorkerFiltersSheet extends StatefulWidget {
  final String? initialCategory;
  final Function(String? category, double maxPrice, double minRating, bool onlyAvailable) onApply;

  const WorkerFiltersSheet({
    super.key,
    this.initialCategory,
    required this.onApply,
  });

  @override
  State<WorkerFiltersSheet> createState() => _WorkerFiltersSheetState();
}

class _WorkerFiltersSheetState extends State<WorkerFiltersSheet> {
  String? _selectedCategory;
  double _maxPrice = 80.0;
  double _minRating = 4.5;
  bool _onlyAvailable = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Workers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _maxPrice = 100.0;
                    _minRating = 4.0;
                    _onlyAvailable = false;
                  });
                },
                child: const Text("Reset All"),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),

          const Text("Service Trade", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text("All Trades"),
                selected: _selectedCategory == null,
                onSelected: (val) => setState(() => _selectedCategory = null),
              ),
              ...MockData.categories.map((c) => ChoiceChip(
                label: Text(c.name),
                selected: _selectedCategory == c.id,
                onSelected: (val) => setState(() => _selectedCategory = val ? c.id : null),
              )),
            ],
          ),
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Max Hourly Rate", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("\$${_maxPrice.toInt()}/hr", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          Slider(
            value: _maxPrice,
            min: 30,
            max: 100,
            divisions: 14,
            activeColor: AppColors.customerBrand,
            onChanged: (val) => setState(() => _maxPrice = val),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Minimum Rating", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text("${_minRating.toStringAsFixed(1)}+", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Slider(
            value: _minRating,
            min: 4.0,
            max: 5.0,
            divisions: 10,
            activeColor: Colors.amber,
            onChanged: (val) => setState(() => _minRating = val),
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Available Today Only", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text("Show trades ready for immediate booking", style: TextStyle(fontSize: 12)),
            activeThumbColor: AppColors.customerBrand,
            value: _onlyAvailable,
            onChanged: (val) => setState(() => _onlyAvailable = val),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(_selectedCategory, _maxPrice, _minRating, _onlyAvailable);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.customerBrand,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Apply Filters", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkerListScreen extends StatefulWidget {
  final String? selectedCategoryId;
  final String? initialSearchQuery;

  const WorkerListScreen({
    super.key,
    this.selectedCategoryId,
    this.initialSearchQuery,
  });

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  late TextEditingController _searchController;
  String? _activeCategory;
  double _maxPrice = 100.0;
  double _minRating = 4.0;
  bool _onlyAvailable = false;

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedCategoryId;
    _searchController = TextEditingController(text: widget.initialSearchQuery ?? "");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredWorkers = MockData.sampleWorkers.where((w) {
      if (_activeCategory != null && w.categoryId != _activeCategory) {
        return false;
      }
      if (w.hourlyRate > _maxPrice) {
        return false;
      }
      if (w.rating < _minRating) {
        return false;
      }
      if (_onlyAvailable && !w.isAvailableToday) {
        return false;
      }
      if (query.isNotEmpty) {
        final matchName = w.name.toLowerCase().contains(query);
        final matchTrade = w.trade.toLowerCase().contains(query);
        final matchSkill = w.skills.any((s) => s.toLowerCase().contains(query));
        return matchName || matchTrade || matchSkill;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_activeCategory != null
            ? "${MockData.categories.firstWhere((c) => c.id == _activeCategory).name}s"
            : "Available Workers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: "Filter Workers",
            onPressed: () => _openFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search by name, trade or skill...",
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _openFilterSheet(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (_activeCategory != null || _onlyAvailable || _minRating > 4.0)
                          ? AppColors.customerBrand.withValues(alpha: 0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: (_activeCategory != null || _onlyAvailable || _minRating > 4.0)
                            ? AppColors.customerBrand
                            : AppColors.border,
                      ),
                    ),
                    child: Icon(
                      Icons.filter_list_rounded,
                      color: (_activeCategory != null || _onlyAvailable || _minRating > 4.0)
                          ? AppColors.customerBrand
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categories horizontal strip
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text("All"),
                    selected: _activeCategory == null,
                    onSelected: (val) => setState(() => _activeCategory = null),
                  ),
                ),
                ...MockData.categories.map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(cat.icon, size: 14, color: _activeCategory == cat.id ? Colors.white : cat.color),
                    label: Text(cat.name),
                    selected: _activeCategory == cat.id,
                    onSelected: (val) => setState(() => _activeCategory = val ? cat.id : null),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  "${filteredWorkers.length} certified professionals found",
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Workers List
          Expanded(
            child: filteredWorkers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: AppColors.textTertiary),
                        const SizedBox(height: 12),
                        const Text("No workers match your filter criteria", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("Try relaxing your filters or searching another trade", style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _activeCategory = null;
                              _maxPrice = 100;
                              _minRating = 4.0;
                              _onlyAvailable = false;
                            });
                          },
                          child: const Text("Reset All Filters"),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredWorkers.length,
                    itemBuilder: (context, index) {
                      final worker = filteredWorkers[index];
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
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => WorkerFiltersSheet(
        initialCategory: _activeCategory,
        onApply: (category, maxPrice, minRating, onlyAvailable) {
          setState(() {
            _activeCategory = category;
            _maxPrice = maxPrice;
            _minRating = minRating;
            _onlyAvailable = onlyAvailable;
          });
        },
      ),
    );
  }
}
