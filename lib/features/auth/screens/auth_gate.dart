import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/auth_service.dart';
import '../../role_selection/welcome_screen.dart';
import '../../customer/screens/customer_main_screen.dart';
import '../../worker/screens/worker_main_screen.dart';
import '../../admin/screens/admin_main_screen.dart';
import '../../../app/theme/app_theme.dart';
import 'update_password_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkSessionAndRoute();
    });

    // Listen for auth state changes (e.g., logout)
    _authSubscription = AuthService.authStateChanges.listen(
      (data) {
        final AuthChangeEvent event = data.event;
        if (event == AuthChangeEvent.passwordRecovery) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const UpdatePasswordScreen()),
              );
            }
          });
          return;
        }

        if (event == AuthChangeEvent.signedOut) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            }
          });
        } else if (event == AuthChangeEvent.signedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _checkSessionAndRoute();
          });
        }
      },
      onError: (error, stackTrace) {
        if (mounted) {
          setState(() {
            _errorMessage =
                'Authentication connection error. Please try again.';
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkSessionAndRoute() async {
    // Yield the frame to ensure initState completes before we attempt to navigate
    await Future.microtask(() {});

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final session = AuthService.currentSession;
    if (session == null) {
      // Unauthenticated
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
      return;
    }

    // Authenticated - fetch profile
    try {
      final profile = await AuthService.getCurrentProfile();
      if (profile == null) {
        setState(() {
          _errorMessage = "Profile not found. Please contact support.";
          _isLoading = false;
        });
        return;
      }

      final role = profile['role'] as String?;
      if (!mounted) return;

      if (role == 'CUSTOMER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerMainScreen()),
        );
      } else if (role == 'WORKER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WorkerMainScreen()),
        );
      } else if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminMainScreen()),
        );
      } else {
        setState(() {
          _errorMessage = "Unknown role assigned.";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage ?? "Authentication Error",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () => AuthService.signOut(),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
