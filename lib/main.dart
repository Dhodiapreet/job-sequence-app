 import 'package:flutter/material.dart';
    import 'package:supabase_flutter/supabase_flutter.dart';
    import 'app/theme/app_theme.dart';
    import 'features/role_selection/splash_screen.dart';

    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();

      // Manually initialize Supabase here
      await Supabase.initialize(
        url: 'https://tifnkiacgincptxcpupo.supabase.co',
        publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpZm5raWFjZ2luY3B0eGNwdXBvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAwODgzMTQsImV4cCI6MjEwNTY2NDMxNH0.hcXGaNb_Tu4Cn6-NVoo0JUFnL-RTLZAE8FJxIsUqd0A'
      );

      runApp(const JobSequencingApp());
    }

    class JobSequencingApp extends StatelessWidget {
      const JobSequencingApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'JobSequence Pro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
        );
      }
    }
