import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized access layer to the Supabase client.
/// This prevents scattering `Supabase.instance.client` throughout the codebase.
class SupabaseService {
  // Returns the globally initialized SupabaseClient
  static SupabaseClient get client => Supabase.instance.client;
}
