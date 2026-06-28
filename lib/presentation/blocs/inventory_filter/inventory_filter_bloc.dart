import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/inventory_filter/inventory_filter_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/inventory_filter/inventory_filter_state.dart';

class InventoryFilterBloc
    extends Bloc<InventoryFilterEvent, InventoryFilterState> {
  InventoryFilterBloc() : super(const InventoryFilterState()) {
    on<InventoryFilterSearchChanged>(_onSearchChanged);
    on<InventoryFilterCategoryChanged>(_onCategoryChanged);
    on<InventoryFilterSoldChanged>(_onSoldChanged);
    on<InventoryFilterWearGroupChanged>(_onWearGroupChanged);
    on<InventoryFilterDateRangeChanged>(_onDateRangeChanged);
    on<InventoryFilterPriceRangeChanged>(_onPriceRangeChanged);
    on<InventoryFilterSortChanged>(_onSortChanged);
    on<InventoryFilterReset>(_onReset);
  }

  void _onSearchChanged(
    InventoryFilterSearchChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(searchQuery: event.query),
    ));
  }

  void _onCategoryChanged(
    InventoryFilterCategoryChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(
        category: event.category,
        clearCategory: event.category == null,
      ),
    ));
  }

  void _onSoldChanged(
    InventoryFilterSoldChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(soldFilter: event.filter),
    ));
  }

  void _onWearGroupChanged(
    InventoryFilterWearGroupChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(
        wearGroup: event.wearGroup,
        clearWearGroup: event.wearGroup == null,
      ),
    ));
  }

  void _onDateRangeChanged(
    InventoryFilterDateRangeChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(
        purchaseDateFrom: event.from,
        purchaseDateTo: event.to,
        clearPurchaseDateFrom: event.from == null,
        clearPurchaseDateTo: event.to == null,
      ),
    ));
  }

  void _onPriceRangeChanged(
    InventoryFilterPriceRangeChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        clearMinPrice: event.minPrice == null,
        clearMaxPrice: event.maxPrice == null,
      ),
    ));
  }

  void _onSortChanged(
    InventoryFilterSortChanged event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(sortOrder: event.sortOrder),
    ));
  }

  void _onReset(
    InventoryFilterReset event,
    Emitter<InventoryFilterState> emit,
  ) {
    emit(const InventoryFilterState());
  }
}
