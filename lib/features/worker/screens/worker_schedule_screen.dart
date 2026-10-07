import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/worker_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/app_models.dart';

class WorkerScheduleScreen extends StatefulWidget {
  const WorkerScheduleScreen({super.key});

  @override
  State<WorkerScheduleScreen> createState() => _WorkerScheduleScreenState();
}

class _WorkerScheduleScreenState extends State<WorkerScheduleScreen> {
  final DateTime _selectedDate = DateTime.now();
  List<TimeSlot> _slots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    final uid = Supabase.instance.client.auth.currentUser!.id;
    final slots = await WorkerService.getWorkerAvailability(uid, _selectedDate);
    if (mounted) {
      setState(() {
        _slots = slots;
        _isLoading = false;
      });
    }
  }

  
  Future<void> _createSlot() async {
    final TimeOfDay? start = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
    if (start == null) return;
    
    if (!mounted) return;
    final TimeOfDay? end = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 12, minute: 0));
    if (end == null) return;

    if (start.hour > end.hour || (start.hour == end.hour && start.minute >= end.minute)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Start time must be before end time')));
      return;
    }

    final sTime = "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}:00";
    final eTime = "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}:00";

    final uid = Supabase.instance.client.auth.currentUser!.id;
    try {
      await WorkerService.createAvailability(uid, _selectedDate, sTime, eTime);
      _loadSchedule();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Availability added')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calendar view opened')));
            },
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _createSlot,
        backgroundColor: AppColors.workerBrand,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: _slots.isEmpty ? const Center(child: Text("No availability for this date.", style: TextStyle(color: AppColors.textSecondary))) : ListView.builder(


        padding: const EdgeInsets.all(16),
        itemCount: _slots.length,
        itemBuilder: (context, index) {
          final slot = _slots[index];
          final isBreak = slot.status == SlotStatus.breakTime;
          final isAvailable = slot.status == SlotStatus.available;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isBreak ? AppColors.surface : isAvailable ? Colors.white : AppColors.workerBrand.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isBreak ? AppColors.border : isAvailable ? AppColors.success : AppColors.workerBrand.withValues(alpha: 0.3)
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.startTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(slot.endTime, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  width: 4,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isBreak ? AppColors.border : isAvailable ? AppColors.success : AppColors.workerBrand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.title ?? 'Available Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isBreak ? AppColors.textSecondary : AppColors.textPrimary)),
                      if (slot.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(slot.subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ]
                    ],
                  ),
                ),
                if (!isBreak && !isAvailable)
                  const Icon(
                    Icons.event_busy_rounded,
                    color: AppColors.workerBrand,
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
