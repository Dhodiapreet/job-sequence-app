import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

/// A reusable statistical card used across Admin and Worker dashboards.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color brandColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brandColor),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// A standardized empty state widget to replace `Center(child: Text('No data'))`
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              )
            ]
          ],
        ),
      ),
    );
  }
}

/// A standardized loading state
class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: const TextStyle(color: AppColors.textSecondary)),
          ]
        ],
      ),
    );
  }
}

/// A specialized button that adapts to the portal's branding color
class PortalButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color portalColor;
  final bool isOutlined;
  final bool isLoading;

  const PortalButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.portalColor,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: portalColor,
          side: BorderSide(color: portalColor),
        ),
        child: isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(label),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: portalColor,
        foregroundColor: Colors.white,
      ),
      child: isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label),
    );
  }
}
