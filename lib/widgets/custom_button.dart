import 'package:flutter/material.dart';
import 'package:ahwa/constants/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomButton({super.key, required this.text, required this.onPressed, this.isLoading = false, this.backgroundColor, this.textColor, this.icon, this.width, this.padding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryBrown,
          foregroundColor: textColor ?? Colors.white,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL, vertical: AppTheme.spaceM),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
          elevation: 4,
        ),
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: AppTheme.spaceS)],
                  Text(text, style: AppTheme.whiteText.copyWith(fontSize: 16)),
                ],
              ),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const IconTextButton({super.key, required this.icon, required this.text, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppTheme.primaryBrown;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceS),
        decoration: BoxDecoration(
          color: buttonColor.withAlpha(25),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: buttonColor.withAlpha(76)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: buttonColor, size: 16),
            const SizedBox(width: AppTheme.spaceS),
            Text(
              text,
              style: TextStyle(color: buttonColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
