import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/worker_service.dart';
import '../../../core/widgets/worker_card.dart';
import 'worker_profile_screen.dart';

class WorkerSearchScreen extends StatefulWidget {
  const WorkerSearchScreen({super.key});

  @override
  State<WorkerSearchScreen> createState() => _WorkerSearchScreenState();
}

class _WorkerSearchScreenState extends State<WorkerSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  List<WorkerProfile> _allWorkers = [];
  List<ServiceCategory> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
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
        _allWorkers = results[0] as List<WorkerProfile>;
        _categories = results[1] as List<ServiceCategory>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<WorkerProfile> get _results {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return [];
    return _allWorkers.where((worker) {
      return worker.name.toLowerCase().contains(query) ||
          worker.trade.toLowerCase().contains(query) ||
          worker.skills.any((skill) => skill.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Search workers, trades or skills...',
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _query.isEmpty
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Browse service categories',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (_categories.isEmpty)
                      const Text(
                        'No service categories are available yet.',
                        style: TextStyle(color: AppColors.textSecondary),
                      )
                    else
                      ..._categories.map((category) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(category.icon, color: category.color),
                            title: Text(category.name),
                            subtitle: const Text(
                              'View available professionals',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing:
                                const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              _controller.text = category.name;
                              setState(() => _query = category.name);
                            },
                          )),
                  ],
                )
              : results.isEmpty
                  ? const Center(
                      child: Text(
                        'No workers found.',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final worker = results[index];
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
    );
  }
}
