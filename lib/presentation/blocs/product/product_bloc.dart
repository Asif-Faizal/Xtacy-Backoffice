import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/data/repositories/product_repository.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository(),
        super(const ProductState()) {
    on<ProductsLoadRequested>(_onLoad);
    on<ProductsRefreshRequested>(_onRefresh);
    on<ProductDeleteRequested>(_onDelete);
    on<ProductMarkSoldRequested>(_onMarkSold);
  }

  final ProductRepository _productRepository;

  Future<void> _onLoad(
    ProductsLoadRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading, clearError: true));
    try {
      final products = await _productRepository.getAllProducts();
      emit(state.copyWith(
        status: ProductStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: e.toString().replaceFirst('ServerFailure: ', ''),
      ));
    }
  }

  Future<void> _onRefresh(
    ProductsRefreshRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products = await _productRepository.getAllProducts();
      emit(state.copyWith(
        status: ProductStatus.success,
        products: products,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('ServerFailure: ', ''),
      ));
    }
  }

  Future<void> _onDelete(
    ProductDeleteRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _productRepository.deleteProduct(event.productId);
      final updated =
          state.products.where((p) => p.id != event.productId).toList();
      emit(state.copyWith(
        products: updated,
        actionMessage: 'Product deleted successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('ServerFailure: ', ''),
      ));
    }
  }

  Future<void> _onMarkSold(
    ProductMarkSoldRequested event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final updated = await _productRepository.markAsSold(
        product: event.product,
        userId: event.userId,
        customerName: event.customerName,
        customerPhone: event.customerPhone,
        soldPrice: event.soldPrice,
        soldDate: event.soldDate,
        notes: event.notes,
      );
      final products = state.products.map((p) {
        return p.id == updated.id ? updated : p;
      }).toList();
      emit(state.copyWith(
        products: products,
        actionMessage: 'Product marked as sold',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('ServerFailure: ', ''),
      ));
    }
  }
}
