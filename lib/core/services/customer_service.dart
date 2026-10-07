import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/app_models.dart';
import '../../app/theme/app_theme.dart';

class CustomerService {
  static final SupabaseClient _client = SupabaseService.client;

  static Future<List<CustomerBooking>> getBookings() async {
    final customerId = _client.auth.currentUser?.id;
    if (customerId == null) throw Exception('Customer session is not available.');

    final rows = await _client
        .from('bookings')
        .select('id, step_id, worker_id, status, labor_cost, service_fee, total_amount, created_at')
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);

    if (rows.isEmpty) return [];

    final stepIds = rows.map((r) => r['step_id']?.toString()).whereType<String>().toList();
    final workerIds = rows.map((r) => r['worker_id']?.toString()).whereType<String>().toSet().toList();

    final steps = stepIds.isEmpty
        ? <dynamic>[]
        : await _client
            .from('job_sequence_items')
            .select('id, job_id, sequence_date, start_time, end_time, category_id')
            .inFilter('id', stepIds);

    final jobIds = steps.map((r) => r['job_id']?.toString()).whereType<String>().toSet().toList();
    final jobs = jobIds.isEmpty
        ? <dynamic>[]
        : await _client
            .from('jobs')
            .select('id, title, description, site_address, special_instructions')
            .inFilter('id', jobIds);

    final workers = workerIds.isEmpty
        ? <dynamic>[]
        : await _client
            .from('worker_profiles')
            .select('user_id, full_name, trade, category_id, hourly_rate, daily_rate, rating, reviews_count, jobs_completed, bio, is_accepting_jobs')
            .inFilter('user_id', workerIds);

    final categoryIds = [
      ...steps.map((r) => r['category_id']?.toString()).whereType<String>(),
      ...workers.map((r) => r['category_id']?.toString()).whereType<String>(),
    ].toSet().toList();

    final categories = categoryIds.isEmpty
        ? <dynamic>[]
        : await _client.from('service_categories').select('id, name').inFilter('id', categoryIds);    final stepById = <String, Map<String, dynamic>>{
      for (final r in steps) r['id'].toString(): Map<String, dynamic>.from(r),
    };
    final jobById = <String, Map<String, dynamic>>{
      for (final r in jobs) r['id'].toString(): Map<String, dynamic>.from(r),
    };
    final workerById = <String, Map<String, dynamic>>{
      for (final r in workers) r['user_id'].toString(): Map<String, dynamic>.from(r),
    };
    final categoryById = <String, String>{
      for (final r in categories) r['id'].toString(): r['name'].toString(),
    };

    return rows.map((raw) {
      final booking = Map<String, dynamic>.from(raw);
      final step = stepById[booking['step_id']?.toString()] ?? const {};
      final job = jobById[step['job_id']?.toString()] ?? const {};
      final worker = workerById[booking['worker_id']?.toString()] ?? const {};
      final categoryId = step['category_id']?.toString() ?? worker['category_id']?.toString() ?? '';
      final start = step['start_time']?.toString() ?? '';
      final end = step['end_time']?.toString() ?? '';

      final workerProfile = WorkerProfile(
        id: worker['user_id']?.toString() ?? booking['worker_id']?.toString() ?? '',
        name: worker['full_name']?.toString() ?? 'Worker',
        trade: worker['trade']?.toString() ?? 'Professional',
        categoryId: categoryId,
        rating: (worker['rating'] as num?)?.toDouble() ?? 0,
        reviewsCount: (worker['reviews_count'] as num?)?.toInt() ?? 0,
        jobsCompleted: (worker['jobs_completed'] as num?)?.toInt() ?? 0,
        experienceYears: 0,
        hourlyRate: (worker['hourly_rate'] as num?)?.toDouble() ?? 0,
        dailyRate: (worker['daily_rate'] as num?)?.toDouble() ?? 0,
        location: 'Not specified',
        distanceKm: 0,
        isAvailableToday: false,
        verificationStatus: WorkerVerificationStatus.pending,
        skills: const [],
        badges: const [],
        bio: worker['bio']?.toString() ?? '',
        avatarInitials: _initials(worker['full_name']?.toString() ?? 'Worker'),
        avatarColor: Colors.blueAccent,
        safetyScore: 0,
      );

      return CustomerBooking(
        bookingId: booking['id'].toString(),
        worker: workerProfile,
        serviceTitle: job['title']?.toString() ?? 'Job',
        categoryName: categoryById[categoryId] ?? '',
        bookingDate: _formatDate(step['sequence_date']?.toString()),
        timeSlot: '${_formatTime(start)} - ${_formatTime(end)}',
        address: job['site_address']?.toString() ?? '',
        jobDescription: job['description']?.toString() ?? '',
        estimatedHours: _durationHours(start, end),
        laborCost: (booking['labor_cost'] as num?)?.toDouble() ?? 0,
        serviceFee: (booking['service_fee'] as num?)?.toDouble() ?? 0,
        totalAmount: (booking['total_amount'] as num?)?.toDouble() ?? 0,
        status: _mapJobStatus(booking['status']?.toString()),
        bookingStatus: booking['status']?.toString() ?? 'REQUESTED',
        specialInstructions: job['special_instructions']?.toString() ?? '',
      );
    }).toList();
  }
  static Future<List<NotificationItem>> getNotifications() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw Exception('Customer session is not available.');

    final rows = await _client
        .from('notifications')
        .select('id, title, message, type, is_read, created_at')
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return (rows as List).map((row) {
      final type = (row['type']?.toString() ?? '').toLowerCase();
      final icon = type.contains('booking')
          ? Icons.calendar_today_rounded
          : type.contains('payment')
              ? Icons.payments_rounded
              : Icons.notifications_outlined;
      return NotificationItem(
        id: row['id'].toString(),
        title: row['title']?.toString() ?? 'Notification',
        message: row['message']?.toString() ?? '',
        timeAgo: _timeAgo(row['created_at']?.toString()),
        icon: icon,
        color: AppColors.customerBrand,
        isRead: row['is_read'] == true,
      );
    }).toList();
  }

  static Future<void> markAllNotificationsRead() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', uid)
        .eq('is_read', false);
  }

  static String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'Date not set';
    final parts = value.split('-');
    if (parts.length != 3) return value;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  static String _formatTime(String value) => value.length >= 5 ? value.substring(0, 5) : value;

  static double _durationHours(String start, String end) {
    if (start.length < 5 || end.length < 5) return 0;
    int minutes(String v) => int.parse(v.substring(0, 2)) * 60 + int.parse(v.substring(3, 5));
    return ((minutes(end) - minutes(start)) / 60).clamp(0, 24).toDouble();
  }

  static JobStatus _mapJobStatus(String? status) {
    switch (status) {
      case 'ACCEPTED':
        return JobStatus.booked;
      case 'COMPLETED':
        return JobStatus.completed;
      case 'CANCELLED':
      case 'DECLINED':
        return JobStatus.cancelled;
      case 'REQUESTED':
      default:
        return JobStatus.readyToBook;
    }
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'W';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static String _timeAgo(String? value) {
    if (value == null) return '';
    final date = DateTime.tryParse(value);
    if (date == null) return '';
    final diff = DateTime.now().toUtc().difference(date.toUtc());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
