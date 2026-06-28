import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_event.dart';

class ProductFormState extends Equatable {
  const ProductFormState({
    this.mode = ProductFormMode.create,
    this.status = ProductFormStatus.initial,
    this.product,
    this.imageFile,
    this.errorMessage,
    this.createdProduct,
  });

  final ProductFormMode mode;
  final ProductFormStatus status;
  final ProductModel? product;
  final File? imageFile;
  final String? errorMessage;
  final ProductModel? createdProduct;

  ProductFormState copyWith({
    ProductFormMode? mode,
    ProductFormStatus? status,
    ProductModel? product,
    File? imageFile,
    String? errorMessage,
    ProductModel? createdProduct,
    bool clearError = false,
    bool clearImage = false,
    bool clearCreated = false,
  }) {
    return ProductFormState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      product: product ?? this.product,
      imageFile: clearImage ? null : imageFile ?? this.imageFile,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      createdProduct: clearCreated ? null : createdProduct ?? this.createdProduct,
    );
  }

  @override
  List<Object?> get props =>
      [mode, status, product, imageFile, errorMessage, createdProduct];
}
