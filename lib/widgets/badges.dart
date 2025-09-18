import 'package:flutter/material.dart';
import 'package:ahwa/constants/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({super.key, required this.text, required this.color, this.icon});

  const StatusBadge.pending({super.key}) : text = 'Pending', color = AppTheme.pendingOrange, icon = Icons.schedule;

  const StatusBadge.completed({super.key}) : text = 'Completed', color = AppTheme.successGreen, icon = Icons.check_circle;

  const StatusBadge.error({super.key}) : text = 'Error', color = AppTheme.errorRed, icon = Icons.error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM, vertical: AppTheme.spaceXS),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppTheme.radiusXLarge)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: Colors.white), const SizedBox(width: AppTheme.spaceXS)],
          Text(text, style: AppTheme.whiteText.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class PriceBadge extends StatelessWidget {
  final double price;
  final String? prefix;

  const PriceBadge({super.key, required this.price, this.prefix});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM, vertical: AppTheme.spaceXS),
      decoration: BoxDecoration(color: AppTheme.primaryBrown, borderRadius: BorderRadius.circular(AppTheme.radiusLarge), boxShadow: AppTheme.buttonShadow),
      child: Text('${prefix ?? ''}\$${price.toStringAsFixed(1)}', style: AppTheme.whiteText.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}

class CountBadge extends StatelessWidget {
  final int count;
  final String label;

  const CountBadge({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM, vertical: AppTheme.spaceXS),
      decoration: BoxDecoration(color: AppTheme.primaryBrown, borderRadius: BorderRadius.circular(AppTheme.radiusXLarge)),
      child: Text('$count $label', style: AppTheme.whiteText.copyWith(fontSize: 12)),
    );
  }
}
