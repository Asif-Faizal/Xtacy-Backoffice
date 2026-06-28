import 'package:flutter/material.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });

  final String title;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppTheme.carbonBlue;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(icon, color: accent, size: 24),
            if (icon != null) const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.carbonGray50,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
