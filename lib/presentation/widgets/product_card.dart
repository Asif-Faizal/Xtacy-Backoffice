import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';
import 'package:xtacy_backoffice/core/utils/currency_formatter.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/presentation/widgets/status_badge.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: _ProductImage(imageUrl: product.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.productName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(isSold: product.isSold),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.carbonGray50,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.colour,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(product.purchasePrice),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.carbonGray50,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        CurrencyFormatter.formatNullable(product.sellingPrice),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.carbonBlue,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        color: AppTheme.carbonGray20,
        child: const Center(
          child: Icon(Icons.image_outlined, size: 48, color: AppTheme.carbonGray50),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: AppTheme.carbonGray20),
      errorWidget: (_, __, ___) => Container(
        color: AppTheme.carbonGray20,
        child: const Icon(Icons.broken_image_outlined, color: AppTheme.carbonGray50),
      ),
    );
  }
}

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker({
    super.key,
    this.imageUrl,
    this.imageFile,
    required this.onPick,
  });

  final String? imageUrl;
  final File? imageFile;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.carbonGray10,
          border: Border.all(color: AppTheme.carbonGray20),
        ),
        child: imageFile != null
            ? Image.file(imageFile!, fit: BoxFit.cover, width: double.infinity)
            : imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          size: 48, color: AppTheme.carbonGray50),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to add product photo',
                        style: TextStyle(color: AppTheme.carbonGray50),
                      ),
                    ],
                  ),
      ),
    );
  }
}
