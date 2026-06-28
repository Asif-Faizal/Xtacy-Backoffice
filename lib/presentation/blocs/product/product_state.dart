import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage,
    this.actionMessage,
  });

  final ProductStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final String? actionMessage;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    String? actionMessage,
    bool clearError = false,
    bool clearAction = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      actionMessage: clearAction ? null : actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage, actionMessage];
}
