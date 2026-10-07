import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/worker_service.dart';
import '../../../core/widgets/worker_card.dart';
import 'worker_profile_screen.dart';

class WorkerFiltersSheet extends StatefulWidget {
  final List<ServiceCategory> categories;
  final String? initialCategory;
  final Function(String? category, double maxPrice, double minRating, bool onlyAvailable) onApply;

  const WorkerFiltersSheet({
    super.key,
    required this.categories,
    this.initialCategory,
    required this.onApply,
  });

  @override
  State<WorkerFiltersSheet> createState() => _WorkerFiltersSheetState();
}

class _WorkerFiltersSheetState extends State<WorkerFiltersSheet> {
  String? _selectedCategory;
  double _maxPrice = 5000;
  double _minRating = 0;
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
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Workers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => setState(() {
                  _selectedCategory = null;
                  _maxPrice = 5000;
                  _minRating = 0;
                  _onlyAvailable = false;
                }),
                child: const Text('Reset'),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text('Service Category',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (_) => setState(() => _selectedCategory = null),
              ),
              ...widget.categories.map((category) => ChoiceChip(
                    label: Text(category.name),
                    selected: _selectedCategory == category.id,
                    onSelected: (selected) => setState(
                        () => _selectedCategory = selected ? category.id : null),
                  )),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Maximum Hourly Rate'),
              Text('₹' + _maxPrice.toInt().toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _maxPrice,
            min: 0,
            max: 5000,
            divisions: 50,
            activeColor: AppColors.customerBrand,
            onChanged: (value) => setState(() => _maxPrice = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Minimum Rating'),
              Text(_minRating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: Colors.amber,
            onChanged: (value) => setState(() => _minRating = value),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Available Today'),
            value: _onlyAvailable,
            onChanged: (value) => setState(() => _onlyAvailable = value),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onApply(
                  _selectedCategory, _maxPrice, _minRating, _onlyAvailable);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.customerBrand),
            child: const Text('Apply Filters'),
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
  final _searchController = TextEditingController();
  List<WorkerProfile> _workers = [];
  List<ServiceCategory> _categories = [];
  String? _activeCategory;
  double _maxPrice = 5000;
  double _minRating = 0;
  bool _onlyAvailable = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedCategoryId;
    _searchController.text = widget.initialSearchQuery ?? '';
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        WorkerService.getWorkers(),
        WorkerService.getCategories(),
      ]);
      if (!mounted) return;
      setState(() {
        _workers = results[0] as List<WorkerProfile>;
        _categories = results[1] as List<ServiceCategory>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load workers.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorkerProfile> get _filteredWorkers {
    final query = _searchController.text.trim().toLowerCase();
    return _workers.where((worker) {
      if (_activeCategory != null && worker.categoryId != _activeCategory) {
        return false;
      }
      if (worker.hourlyRate > _maxPrice) return false;
      if (worker.rating < _minRating) return false;
      if (_onlyAvailable && !worker.isAvailableToday) return false;
      if (query.isEmpty) return true;
      return worker.name.toLowerCase().contains(query) ||
          worker.trade.toLowerCase().contains(query) ||
          worker.skills.any((s) => s.toLowerCase().contains(query));
    }).toList();
  }

  String get _title {
    if (_activeCategory == null) return 'Available Workers';
    final category =
        _categories.where((c) => c.id == _activeCategory).toList();
    return category.isEmpty ? 'Available Workers' : category.first.name;
  }

  @override
  Widget build(BuildContext context) {
    final workers = _filteredWorkers;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: _loading ? null : () => _openFilters(context),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search by name, trade or skill...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: const Text('All'),
                              selected: _activeCategory == null,
                              onSelected: (_) =>
                                  setState(() => _activeCategory = null),
                            ),
                          ),
                          ..._categories.map((category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category.name),
                                  selected:
                                      _activeCategory == category.id,
                                  onSelected: (selected) => setState(() =>
                                      _activeCategory =
                                          selected ? category.id : null),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          workers.length.toString() + ' workers found',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    Expanded(
                      child: workers.isEmpty
                          ? const Center(
                              child: Text(
                                'No workers available yet.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                itemCount: workers.length,
                                itemBuilder: (context, index) {
                                  final worker = workers[index];
                                  return WorkerCard(
                                    worker: worker,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            WorkerProfileScreen(worker: worker),
                                      ),
                                    ),
                                    onBookNow: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            WorkerProfileScreen(worker: worker),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }

  void _openFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => WorkerFiltersSheet(
        categories: _categories,
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
