import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductsLoadRequested extends ProductEvent {
  const ProductsLoadRequested();
}

class ProductsRefreshRequested extends ProductEvent {
  const ProductsRefreshRequested();
}

class ProductDeleteRequested extends ProductEvent {
  const ProductDeleteRequested(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}

class ProductMarkSoldRequested extends ProductEvent {
  const ProductMarkSoldRequested({
    required this.product,
    required this.customerName,
    required this.customerPhone,
    required this.soldPrice,
    required this.soldDate,
    this.notes,
    required this.userId,
  });

  final ProductModel product;
  final String customerName;
  final String customerPhone;
  final double soldPrice;
  final DateTime soldDate;
  final String? notes;
  final String userId;

  @override
  List<Object?> get props =>
      [product, customerName, customerPhone, soldPrice, soldDate, notes, userId];
}
