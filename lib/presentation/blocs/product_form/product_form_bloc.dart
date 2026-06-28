import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/data/repositories/product_repository.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository(),
        super(const ProductFormState()) {
    on<ProductFormInitialized>(_onInitialized);
    on<ProductFormImagePicked>(_onImagePicked);
    on<ProductFormSubmitted>(_onSubmitted);
  }

  final ProductRepository _productRepository;

  void _onInitialized(
    ProductFormInitialized event,
    Emitter<ProductFormState> emit,
  ) {
    emit(ProductFormState(
      mode: event.mode,
      product: event.product,
    ));
  }

  void _onImagePicked(
    ProductFormImagePicked event,
    Emitter<ProductFormState> emit,
  ) {
    emit(state.copyWith(imageFile: event.imageFile));
  }

  Future<void> _onSubmitted(
    ProductFormSubmitted event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(state.copyWith(
      status: ProductFormStatus.submitting,
      clearError: true,
    ));

    try {
      if (state.mode == ProductFormMode.create) {
        final product = await _productRepository.createProduct(
          productName: event.productName,
          category: event.category,
          colour: event.colour,
          size: event.size,
          sleeveType: event.sleeveType,
          purchaseDate: event.purchaseDate,
          purchasePrice: event.purchasePrice,
          sellingPrice: event.sellingPrice,
          notes: event.notes,
          merchantName: event.merchantName,
          userId: event.userId,
          imageFile: state.imageFile,
        );
        emit(state.copyWith(
          status: ProductFormStatus.success,
          createdProduct: product,
        ));
      } else {
        final existing = state.product!;
        final updated = await _productRepository.updateProduct(
          product: existing,
          userId: event.userId,
          productName: event.productName,
          category: event.category,
          colour: event.colour,
          size: event.size,
          sleeveType: event.sleeveType,
          purchasePrice: event.purchasePrice,
          sellingPrice: event.sellingPrice,
          notes: event.notes,
          imageFile: state.imageFile,
        );
        emit(state.copyWith(
          status: ProductFormStatus.success,
          createdProduct: updated,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductFormStatus.failure,
        errorMessage: e.toString()
            .replaceFirst('ServerFailure: ', '')
            .replaceFirst('StorageFailure: ', ''),
      ));
    }
  }
}
