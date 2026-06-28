import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.itemCount = 6,
    this.isGrid = true,
  });

  final int itemCount;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.carbonGray20,
      highlightColor: AppTheme.carbonGray10,
      child: isGrid
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: itemCount,
              itemBuilder: (_, __) => Container(
                color: Colors.white,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itemCount,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 120,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
