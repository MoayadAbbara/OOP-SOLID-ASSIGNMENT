import 'package:flutter/material.dart';
import 'package:ahwa/constants/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle, this.action});

  const EmptyState.noOrders({super.key, this.action}) : icon = Icons.receipt_long, title = 'No orders yet', subtitle = 'Start ordering from the menu';

  const EmptyState.error({super.key, required String errorMessage, this.action}) : icon = Icons.error_outline, title = 'Something went wrong', subtitle = errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: AppTheme.spaceL),
            Text(
              title,
              style: AppTheme.titleLarge.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceS),
            Text(
              subtitle,
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: AppTheme.spaceXL), action!],
          ],
        ),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBrown)),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spaceL),
            Text(
              message!,
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
