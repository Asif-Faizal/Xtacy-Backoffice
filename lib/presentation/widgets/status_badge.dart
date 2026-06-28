import 'package:flutter/material.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.isSold});

  final bool isSold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSold
            ? AppTheme.successGreen.withValues(alpha: 0.15)
            : AppTheme.warningOrange.withValues(alpha: 0.15),
        border: Border.all(
          color: isSold ? AppTheme.successGreen : AppTheme.warningOrange,
        ),
      ),
      child: Text(
        isSold ? 'SOLD' : 'UNSOLD',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isSold ? AppTheme.successGreen : AppTheme.carbonGray70,
        ),
      ),
    );
  }
}
