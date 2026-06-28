import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/inventory_filter.dart';

abstract class InventoryFilterEvent extends Equatable {
  const InventoryFilterEvent();

  @override
  List<Object?> get props => [];
}

class InventoryFilterSearchChanged extends InventoryFilterEvent {
  const InventoryFilterSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class InventoryFilterCategoryChanged extends InventoryFilterEvent {
  const InventoryFilterCategoryChanged(this.category);

  final String? category;

  @override
  List<Object?> get props => [category];
}

class InventoryFilterSoldChanged extends InventoryFilterEvent {
  const InventoryFilterSoldChanged(this.filter);

  final SoldFilter filter;

  @override
  List<Object?> get props => [filter];
}

class InventoryFilterWearGroupChanged extends InventoryFilterEvent {
  const InventoryFilterWearGroupChanged(this.wearGroup);

  final String? wearGroup;

  @override
  List<Object?> get props => [wearGroup];
}

class InventoryFilterDateRangeChanged extends InventoryFilterEvent {
  const InventoryFilterDateRangeChanged({
    this.from,
    this.to,
  });

  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [from, to];
}

class InventoryFilterPriceRangeChanged extends InventoryFilterEvent {
  const InventoryFilterPriceRangeChanged({
    this.minPrice,
    this.maxPrice,
  });

  final double? minPrice;
  final double? maxPrice;

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

class InventoryFilterSortChanged extends InventoryFilterEvent {
  const InventoryFilterSortChanged(this.sortOrder);

  final SortOrder sortOrder;

  @override
  List<Object?> get props => [sortOrder];
}

class InventoryFilterReset extends InventoryFilterEvent {
  const InventoryFilterReset();
}
