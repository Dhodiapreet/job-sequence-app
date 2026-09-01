import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'features/role_selection/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
