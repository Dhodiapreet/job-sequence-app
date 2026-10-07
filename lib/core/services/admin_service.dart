import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import 'worker_service.dart';
import '../models/app_models.dart';

class AdminService {
  static final SupabaseClient _client = SupabaseService.client;

  static Future<Map<String, int>> getOverviewCounts() async {
    final profiles = await _client.from('profiles').select('id, role');
    final bookings = await _client.from('bookings').select('id, status');
    final jobs = await _client.from('jobs').select('id, status');
    final workers = await _client.from('worker_profiles').select('user_id');

    int roleCount(String role) =>
        profiles.where((row) => row['role'] == role).length;
    int bookingCount(String status) =>
        bookings.where((row) => row['status'] == status).length;
    int jobCount(String status) =>
        jobs.where((row) => row['status'] == status).length;

    return {
      'customers': roleCount('CUSTOMER'),
      'workers': workers.length,
      'bookings_requested': bookingCount('REQUESTED'),
      'bookings_accepted': bookingCount('ACCEPTED'),
      'bookings_completed': bookingCount('COMPLETED'),
      'bookings_cancelled': bookingCount('CANCELLED'),
      'jobs': jobs.length,
      'jobs_in_progress': jobCount('IN_PROGRESS'),
      'jobs_completed': jobCount('COMPLETED'),
    };
  }

  static Future<List<WorkerProfile>> getWorkers() =>
      WorkerService.getWorkers(approvedOnly: false);

  static Future<List<Map<String, dynamic>>> getCustomers() async {
    final profiles = await _client
        .from('profiles')
        .select('id, email, role, created_at')
        .eq('role', 'CUSTOMER')
        .order('created_at', ascending: false);
    final ids = (profiles as List)
        .map((row) => row['id']?.toString())
        .whereType<String>()
        .toList();
    if (ids.isEmpty) return [];

    final customers = await _client
        .from('customer_profiles')
        .select('user_id, full_name')
        .inFilter('user_id', ids);
    final names = <String, String>{
      for (final row in customers)
        row['user_id'].toString():
            row['full_name']?.toString() ?? 'Customer',
    };
    return profiles
        .map((row) => {
              ...Map<String, dynamic>.from(row),
              'full_name': names[row['id']?.toString()] ?? 'Customer',
            })
        .toList();
  }

  static Future<List<AdminBooking>> getBookings() async {
    final rows = await _client
        .from('bookings')
        .select('id, customer_id, worker_id, status, total_amount, created_at')
        .order('created_at', ascending: false);
    if (rows.isEmpty) return [];

    final customerIds = rows.map((r) => r['customer_id']?.toString())
        .whereType<String>().toSet().toList();
    final workerIds = rows.map((r) => r['worker_id']?.toString())
        .whereType<String>().toSet().toList();

    final customers = customerIds.isEmpty
        ? <dynamic>[]
        : await _client.from('customer_profiles')
            .select('user_id, full_name').inFilter('user_id', customerIds);
    final workers = workerIds.isEmpty
        ? <dynamic>[]
        : await _client.from('worker_profiles')
            .select('user_id, full_name').inFilter('user_id', workerIds);

    final customerNames = <String, String>{
      for (final row in customers)
        row['user_id'].toString(): row['full_name']?.toString() ?? 'Customer',
    };
    final workerNames = <String, String>{
      for (final row in workers)
        row['user_id'].toString(): row['full_name']?.toString() ?? 'Worker',
    };

    return rows.map((row) {
      final created = DateTime.tryParse(row['created_at']?.toString() ?? '');
      final date = created == null
          ? 'Date not available'
          : '${created.day}/${created.month}/${created.year}';
      return AdminBooking(
        id: row['id'].toString(),
        customer: customerNames[row['customer_id']?.toString()] ?? 'Customer',
        worker: workerNames[row['worker_id']?.toString()] ?? 'Worker',
        status: row['status']?.toString() ?? 'REQUESTED',
        amount: (row['total_amount'] as num?)?.toDouble() ?? 0,
        date: date,
      );
    }).toList();
  }

  static Future<List<AdminJob>> getJobs() async {
    final rows = await _client
        .from('jobs')
        .select('id, customer_id, title, status, site_address, created_at')
        .order('created_at', ascending: false);
    if (rows.isEmpty) return [];

    final customerIds = rows.map((r) => r['customer_id']?.toString())
        .whereType<String>().toSet().toList();
    final customers = customerIds.isEmpty
        ? <dynamic>[]
        : await _client.from('customer_profiles')
            .select('user_id, full_name').inFilter('user_id', customerIds);
    final names = <String, String>{
      for (final row in customers)
        row['user_id'].toString(): row['full_name']?.toString() ?? 'Customer',
    };

    return rows.map((row) {
      final created = DateTime.tryParse(row['created_at']?.toString() ?? '');
      return AdminJob(
        id: row['id'].toString(),
        customer: names[row['customer_id']?.toString()] ?? 'Customer',
        title: row['title']?.toString() ?? 'Job',
        status: row['status']?.toString() ?? 'DRAFT',
        location: row['site_address']?.toString() ?? '',
        date: created == null
            ? 'Date not available'
            : '${created.day}/${created.month}/${created.year}',
      );
    }).toList();
  }

  static Future<List<AdminNotification>> getNotifications() async {
    final rows = await _client
        .from('notifications')
        .select('id, title, message, type, is_read, created_at')
        .order('created_at', ascending: false);

    return (rows as List).map((row) {
      final type = (row['type']?.toString() ?? '').toLowerCase();
      final icon = type.contains('booking')
          ? Icons.book_online_rounded
          : type.contains('worker')
              ? Icons.engineering_rounded
              : Icons.notifications_outlined;
      return AdminNotification(
        id: row['id'].toString(),
        title: row['title']?.toString() ?? 'Notification',
        message: row['message']?.toString() ?? '',
        isRead: row['is_read'] == true,
        createdAt: row['created_at']?.toString() ?? '',
        icon: icon,
      );
    }).toList();
  }
}

class AdminBooking {
  final String id;
  final String customer;
  final String worker;
  final String status;
  final double amount;
  final String date;

  const AdminBooking({
    required this.id,
    required this.customer,
    required this.worker,
    required this.status,
    required this.amount,
    required this.date,
  });
}

class AdminJob {
  final String id;
  final String customer;
  final String title;
  final String status;
  final String location;
  final String date;

  const AdminJob({
    required this.id,
    required this.customer,
    required this.title,
    required this.status,
    required this.location,
    required this.date,
  });
}

class AdminNotification {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;
  final IconData icon;

  const AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.icon,
  });
}
