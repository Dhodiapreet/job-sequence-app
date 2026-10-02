import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class BookingService {
  static final SupabaseClient _client = SupabaseService.client;

  static Future<CreatedBooking> createCustomerJobBooking({
    required String workerId,
    required String slotId,
    required String title,
    required String description,
    required String siteAddress,
    String? specialInstructions,
  }) async {
    if (title.trim().isEmpty) {
      throw Exception('Job title is required.');
    }
    if (description.trim().isEmpty) {
      throw Exception('Job description is required.');
    }
    if (siteAddress.trim().isEmpty) {
      throw Exception('Job site address is required.');
    }

    try {
      final result = await _client.rpc(
        'create_customer_job_booking',
        params: {
          'p_worker_id': workerId,
          'p_slot_id': slotId,
          'p_title': title.trim(),
          'p_description': description.trim(),
          'p_site_address': siteAddress.trim(),
          'p_special_instructions': specialInstructions?.trim(),
        },
      );

      if (result is! Map<String, dynamic>) {
        throw Exception('Invalid booking response from server.');
      }

      return CreatedBooking.fromJson(result);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}

class CreatedBooking {
  final String jobId;
  final String stepId;
  final String bookingId;
  final String slotId;
  final String status;
  final double laborCost;
  final double serviceFee;
  final double totalAmount;
  final int sequenceOrder;

  const CreatedBooking({
    required this.jobId,
    required this.stepId,
    required this.bookingId,
    required this.slotId,
    required this.status,
    required this.laborCost,
    required this.serviceFee,
    required this.totalAmount,
    required this.sequenceOrder,
  });

  factory CreatedBooking.fromJson(Map<String, dynamic> json) {
    return CreatedBooking(
      jobId: json['job_id'] as String,
      stepId: json['step_id'] as String,
      bookingId: json['booking_id'] as String,
      slotId: json['slot_id'] as String,
      status: json['status'] as String,
      laborCost: (json['labor_cost'] as num).toDouble(),
      serviceFee: (json['service_fee'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      sequenceOrder: (json['sequence_order'] as num).toInt(),
    );
  }
}
