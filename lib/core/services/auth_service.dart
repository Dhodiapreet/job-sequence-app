import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AppAuthException implements Exception {
  final String message;
  AppAuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static final GoTrueClient _auth = SupabaseService.client.auth;

  /// Stream of authentication state changes
  static Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  /// Get current session
  static Session? get currentSession => _auth.currentSession;

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Sign Up (Always creates a CUSTOMER based on DB trigger).
  /// Returns true when Supabase created an authenticated session immediately,
  /// or false when email confirmation is required.
  static Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      return response.session != null;
    } on AuthException catch (e) {
      throw AppAuthException(_friendlySignUpError(e));
    } on PostgrestException {
      throw AppAuthException('Unable to create your account. Please try again.');
    } catch (e) {
      throw AppAuthException('Unable to create your account. Please try again.');
    }
  }

  /// Sign In
  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AppAuthException(_friendlySignInError(e));
    } catch (e) {
      throw AppAuthException('Invalid email or password.');
    }
  }

  static String _friendlySignUpError(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many account creation attempts. Please wait and try again.';
    }
    if (message.contains('already registered') || message.contains('already exists')) {
      return 'An account with this email already exists.';
    }
    return 'Unable to create your account. Please try again.';
  }

  static String _friendlySignInError(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many sign-in attempts. Please wait and try again.';
    }
    return 'Invalid email or password.';
  }

  /// Request a password reset email.
  static Future<void> resetPasswordForEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (e) {
      throw AppAuthException(_friendlyAuthError(e));
    } catch (_) {
      throw AppAuthException(
        'Unable to send the password reset email. Please check your connection and try again.',
      );
    }
  }

  /// Verify OTP for password recovery
  static Future<void> verifyRecoveryOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _auth.verifyOTP(type: OtpType.recovery, token: otp, email: email);
    } on AuthException catch (e) {
      throw AppAuthException(_friendlyAuthError(e));
    } catch (_) {
      throw AppAuthException('Invalid or expired OTP. Please try again.');
    }
  }

  /// Update the password during a Supabase password recovery session.
  static Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw AppAuthException(_friendlyAuthError(e));
    } catch (_) {
      throw AppAuthException(
        'Unable to update your password. Please try again.',
      );
    }
  }

  static String _friendlyAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many reset requests. Please wait a while and try again.';
    }
    if (message.contains('network') || message.contains('connection')) {
      return 'Network error. Please check your connection and try again.';
    }
    if (message.contains('expired') || message.contains('invalid')) {
      return 'This password reset link is invalid or has expired. Please request a new one.';
    }
    return 'Unable to complete the password reset request. Please try again.';
  }

  /// Sign Out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AppAuthException('Failed to sign out. Please try again.');
    }
  }

  /// Fetch the current user's profile and role-specific display data.
  static Future<Map<String, dynamic>?> getCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) return null;

      final profile = Map<String, dynamic>.from(data);
      final role = profile['role'] as String?;

      if (role == 'CUSTOMER') {
        final customerProfile = await SupabaseService.client
            .from('customer_profiles')
            .select('full_name, avatar_url')
            .eq('user_id', user.id)
            .maybeSingle();

        final metadataName = user.userMetadata?['full_name'] as String?;
        final databaseName = customerProfile?['full_name'] as String?;

        profile['full_name'] = (databaseName?.trim().isNotEmpty ?? false)
            ? databaseName!.trim()
            : ((metadataName?.trim().isNotEmpty ?? false)
                ? metadataName!.trim()
                : (user.email?.split('@').first ?? 'Customer'));

        profile['avatar_url'] = customerProfile?['avatar_url'];
      } else {
        profile['full_name'] =
            (user.userMetadata?['full_name'] as String?)?.trim() ??
                user.email?.split('@').first ??
                'User';
      }

      profile['email'] = profile['email'] ?? user.email;
      return profile;
    } catch (e) {
      throw AppAuthException('Failed to load user profile.');
    }
  }
}
