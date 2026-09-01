import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_sequencing_app/app/theme/app_theme.dart';
import 'package:job_sequencing_app/core/widgets/core_widgets.dart';
import 'package:job_sequencing_app/core/models/app_models.dart';

void main() {
  group('Theme & Core Widgets Tests', () {
    testWidgets('StatusBadge renders correctly with given status', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: JobStatus.inProgress),
          ),
        ),
      );

      // Verify that the text for inProgress status is present
      expect(find.text('In Progress'), findsOneWidget);
    });

    test('AppTheme generates valid light theme', () {
      final theme = AppTheme.lightTheme;
      
      expect(theme.useMaterial3, isTrue);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.primary);
    });
  });
}
