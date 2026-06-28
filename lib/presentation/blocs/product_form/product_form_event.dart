import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';

enum ProductFormMode { create, edit }

enum ProductFormStatus { initial, submitting, success, failure }

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

class ProductFormInitialized extends ProductFormEvent {
  const ProductFormInitialized({this.product, this.mode = ProductFormMode.create});

  final ProductModel? product;
  final ProductFormMode mode;

  @override
  List<Object?> get props => [product, mode];
}

class ProductFormImagePicked extends ProductFormEvent {
  const ProductFormImagePicked(this.imageFile);

  final File imageFile;

  @override
  List<Object?> get props => [imageFile];
}

class ProductFormSubmitted extends ProductFormEvent {
  const ProductFormSubmitted({
    required this.userId,
    required this.productName,
    required this.category,
    required this.colour,
    required this.size,
    this.sleeveType,
    required this.purchaseDate,
    required this.purchasePrice,
    this.sellingPrice,
    this.notes,
    required this.merchantName,
  });

  final String userId;
  final String productName;
  final String category;
  final String colour;
  final String size;
  final String? sleeveType;
  final DateTime purchaseDate;
  final double purchasePrice;
  final double? sellingPrice;
  final String? notes;
  final String merchantName;

  @override
  List<Object?> get props => [
        userId,
        productName,
        category,
        colour,
        size,
        sleeveType,
        purchaseDate,
        purchasePrice,
        sellingPrice,
        notes,
        merchantName,
      ];
}
