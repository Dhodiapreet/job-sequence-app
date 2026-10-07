import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/app_theme.dart';
import 'supabase_service.dart';
import '../models/app_models.dart';

class WorkerService {
  static final SupabaseClient _client = SupabaseService.client;

  // --- CATEGORIES ---

  static Future<List<ServiceCategory>> getCategories() async {
    try {
      final response = await _client.from('service_categories').select();
      return (response as List).map((e) => _mapCategory(e)).toList();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      return [];
    }
  }

  static ServiceCategory _mapCategory(Map<String, dynamic> json) {
    // Map icon_name string to actual Flutter Icons
    IconData iconData = Icons.build_rounded;
    final iconStr = json['icon_name'] as String?;
    if (iconStr != null) {
      if (iconStr.contains('bolt') || iconStr.contains('electric')) { iconData = Icons.bolt_rounded; }
      else if (iconStr.contains('plumb')) { iconData = Icons.plumbing_rounded; }
      else if (iconStr.contains('carpent') || iconStr.contains('wood')) { iconData = Icons.carpenter_rounded; }
      else if (iconStr.contains('paint')) { iconData = Icons.format_paint_rounded; }
      else if (iconStr.contains('ac_') || iconStr.contains('snow')) { iconData = Icons.ac_unit_rounded; }
      else if (iconStr.contains('clean')) { iconData = Icons.cleaning_services_rounded; }
      else if (iconStr.contains('weld') || iconStr.contains('hardware')) { iconData = Icons.hardware_rounded; }
      else if (iconStr.contains('mason') || iconStr.contains('foundation')) { iconData = Icons.foundation_rounded; }
    }

    // Map color_hex to Color
    Color color = Colors.blueGrey;
    final colorStr = json['color_hex'] as String?;
    if (colorStr != null && colorStr.length == 7 && colorStr.startsWith('#')) {
      try {
        color = Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
      } catch (_) {}
    }

    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: iconData,
      color: color,
      workerCount: 0, // Placeholder: Would require an aggregate query or view in the future
    );
  }

  // --- WORKER DISCOVERY ---

  static Future<List<WorkerProfile>> getWorkers({
    String? categoryId,
    String? searchQuery,
    bool approvedOnly = true,
  }) async {
    try {
      // Query worker_profiles, left join with worker_skills
      // Note: Supabase relational queries use nested syntax:
      var query = _client.from('worker_profiles').select('''
        *,
        service_categories (id, name),
        worker_skills (skill_name)
      ''');

      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('category_id', categoryId);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('full_name', '%$searchQuery%');
      }

      final response = await query;
      final rows = List<Map<String, dynamic>>.from(
        (response as List).map((row) => Map<String, dynamic>.from(row)),
      );

      if (rows.isEmpty) return [];

      final workerIds = rows
          .map((row) => row['user_id']?.toString())
          .whereType<String>()
          .toList();

      final today = DateTime.now();
      final dateValue =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      final availabilityRows = await _client
          .from('worker_availability')
          .select('worker_id')
          .inFilter('worker_id', workerIds)
          .eq('slot_date', dateValue)
          .eq('status', 'AVAILABLE');

      final availableWorkerIds = (availabilityRows as List)
          .map((row) => row['worker_id']?.toString())
          .whereType<String>()
          .toSet();

      final verificationRows = await _client
          .from('worker_verifications')
          .select('worker_id, status, created_at')
          .inFilter('worker_id', workerIds)
          .eq('status', 'APPROVED')
          .order('created_at', ascending: false);

      final verifiedWorkerIds = (verificationRows as List)
          .map((row) => row['worker_id']?.toString())
          .whereType<String>()
          .toSet();

      final visibleRows = approvedOnly
          ? rows.where(
              (row) => verifiedWorkerIds.contains(
                row['user_id']?.toString(),
              ),
            )
          : rows;

      return visibleRows
          .map((row) => _mapWorker(
                row,
                isAvailableToday:
                    availableWorkerIds.contains(row['user_id']?.toString()),
                isVerified:
                    verifiedWorkerIds.contains(row['user_id']?.toString()),
              ))
          .toList();
    } catch (e) {
      debugPrint("Error fetching workers: $e");
      return [];
    }
  }

  static WorkerProfile _mapWorker(
    Map<String, dynamic> json, {
    bool isAvailableToday = false,
    bool isVerified = false,
  }) {
    final skills = (json['worker_skills'] as List?)?.map((s) => s['skill_name'].toString()).toList() ?? [];
    
    return WorkerProfile(
      id: json['user_id'] as String,
      name: json['full_name'] as String? ?? 'Unknown',
      trade: json['trade'] as String? ?? 'Professional',
      categoryId: json['category_id'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
      jobsCompleted: (json['jobs_completed'] as num?)?.toInt() ?? 0,
      experienceYears: 0, // Not stored in the current schema.
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble() ?? 0.0,
      dailyRate: (json['daily_rate'] as num?)?.toDouble() ?? 0.0,
      location: "Not specified",
      distanceKm: 0.0,
      isAvailableToday: isAvailableToday,
      verificationStatus: isVerified
          ? WorkerVerificationStatus.verified
          : WorkerVerificationStatus.pending,
      skills: skills,
      badges: [],
      bio: json['bio'] as String? ?? '',
      avatarInitials: _getInitials(json['full_name'] as String? ?? 'W'),
      avatarColor: Colors.blueAccent,
      safetyScore: 0,
      portfolioTags: [],
      reviews: [], // Would fetch from reviews table
    );
  }

  static String _getInitials(String name) {
    if (name.isEmpty) return 'W';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

// --- SCHEDULE & AVAILABILITY ---

  static Future<List<TimeSlot>> getWorkerAvailability(
    String workerId,
    DateTime date, {
    bool excludeReserved = false,
  }) async {
    try {
      final dateValue = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final response = await _client
          .from('worker_availability')
          .select()
          .eq('worker_id', workerId)
          .eq('slot_date', dateValue)
          .order('start_time');

      final slots = (response as List)
          .map((json) => TimeSlot.fromJson(json))
          .toList();

      if (!excludeReserved) return slots;

      // A REQUESTED or ACCEPTED booking reserves a slot from the customer's
      // perspective even though worker_availability.status remains AVAILABLE
      // until the booking state machine accepts it.
      final activeBookings = await _client
          .from('bookings')
          .select('slot_id')
          .eq('worker_id', workerId)
          .inFilter('status', ['REQUESTED', 'ACCEPTED']);
      final reservedSlotIds = (activeBookings as List)
          .map((row) => row['slot_id']?.toString())
          .whereType<String>()
          .toSet();

      return slots.where((slot) => !reservedSlotIds.contains(slot.id)).toList();
    } catch (e) {
      debugPrint("Error fetching availability: $e");
      return [];
    }
  }

  static Future<void> createAvailability(String workerId, DateTime date, String startTime, String endTime) async {
    await _client.from('worker_availability').insert({
      'worker_id': workerId,
      'slot_date': "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      'start_time': startTime,
      'end_time': endTime,
      'status': 'AVAILABLE',
    });
  }

  static Future<void> deleteAvailability(String slotId) async {
    await _client.from('worker_availability').delete().eq('id', slotId);
  }

  // --- BOOKING REQUESTS ---

  static Future<List<WorkerBookingRequest>> getWorkerBookingRequests() async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) throw Exception('Worker session is not available.');

    try {
      final bookings = await _client
          .from('bookings')
          .select('id, step_id, slot_id, status, labor_cost, service_fee, total_amount, created_at')
          .eq('worker_id', workerId)
          .eq('status', 'REQUESTED')
          .order('created_at', ascending: false);

      if (bookings.isEmpty) return [];

      final stepIds = bookings
          .map((row) => row['step_id']?.toString())
          .whereType<String>()
          .toList();

      final steps = await _client
          .from('job_sequence_items')
          .select('id, job_id, sequence_date, sequence_order, start_time, end_time, status')
          .inFilter('id', stepIds);

      final stepById = <String, Map<String, dynamic>>{
        for (final row in steps) row['id'].toString(): Map<String, dynamic>.from(row),
      };

      final jobIds = steps
          .map((row) => row['job_id']?.toString())
          .whereType<String>()
          .toList();
      final jobs = jobIds.isEmpty
          ? <dynamic>[]
          : await _client
              .from('jobs')
              .select('id, title, description, site_address, special_instructions, total_budget, status')
              .inFilter('id', jobIds);

      final jobById = <String, Map<String, dynamic>>{
        for (final row in jobs) row['id'].toString(): Map<String, dynamic>.from(row),
      };

      return bookings.map((row) {
        final booking = Map<String, dynamic>.from(row);
        final step = stepById[booking['step_id']?.toString()] ?? const <String, dynamic>{};
        final job = jobById[step['job_id']?.toString()] ?? const <String, dynamic>{};
        return WorkerBookingRequest.fromJson(booking, step, job);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching worker booking requests: $e');
      rethrow;
    }
  }

  static Future<List<NotificationItem>> getWorkerNotifications() async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) throw Exception('Worker session is not available.');

    final rows = await _client
        .from('notifications')
        .select('id, title, message, type, is_read, created_at')
        .eq('user_id', workerId)
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
        color: AppColors.workerBrand,
        isRead: row['is_read'] == true,
      );
    }).toList();
  }

  static Future<void> markAllWorkerNotificationsRead() async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) return;
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', workerId)
        .eq('is_read', false);
  }

  static String _timeAgo(String? value) {
    if (value == null) return '';
    final date = DateTime.tryParse(value);
    if (date == null) return '';
    final diff = DateTime.now().toUtc().difference(date.toUtc());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return diff.inMinutes.toString() + 'm ago';
    if (diff.inDays < 1) return diff.inHours.toString() + 'h ago';
    if (diff.inDays < 7) return diff.inDays.toString() + 'd ago';
    return date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString();
  }

  static Future<List<Map<String, dynamic>>> getWorkerBookings() async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) throw Exception('Worker session is not available.');

    final rows = await _client
        .from('bookings')
        .select('id, status, total_amount, labor_cost, service_fee, created_at')
        .eq('worker_id', workerId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(
      (rows as List).map((row) => Map<String, dynamic>.from(row)),
    );
  }

  static Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) throw Exception('Worker session is not available.');
    if (!{'ACCEPTED', 'DECLINED'}.contains(status)) {
      throw Exception('Invalid worker booking action.');
    }

    try {
      await _client
          .from('bookings')
          .update({'status': status})
          .eq('id', bookingId)
          .eq('worker_id', workerId)
          .eq('status', 'REQUESTED')
          .select('id')
          .single();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }
}

class WorkerBookingRequest {
  final String bookingId;
  final String title;
  final String description;
  final String siteAddress;
  final String specialInstructions;
  final DateTime sequenceDate;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String status;

  const WorkerBookingRequest({
    required this.bookingId,
    required this.title,
    required this.description,
    required this.siteAddress,
    required this.specialInstructions,
    required this.sequenceDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
  });

  factory WorkerBookingRequest.fromJson(
    Map<String, dynamic> booking,
    Map<String, dynamic> step,
    Map<String, dynamic> job,
  ) {
    final rawDate = step['sequence_date']?.toString();
    final parsedDate = rawDate == null
        ? DateTime.now()
        : DateTime.parse(rawDate);
    return WorkerBookingRequest(
      bookingId: booking['id'].toString(),
      title: job['title']?.toString() ?? 'Job Request',
      description: job['description']?.toString() ?? '',
      siteAddress: job['site_address']?.toString() ?? '',
      specialInstructions: job['special_instructions']?.toString() ?? '',
      sequenceDate: parsedDate,
      startTime: _formatTime(step['start_time']?.toString() ?? ''),
      endTime: _formatTime(step['end_time']?.toString() ?? ''),
      totalAmount: (booking['total_amount'] as num?)?.toDouble() ?? 0,
      status: booking['status']?.toString() ?? 'REQUESTED',
    );
  }

  static String _formatTime(String value) {
    if (value.length >= 5) return value.substring(0, 5);
    return value;
  }
}