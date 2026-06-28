import 'package:equatable/equatable.dart';

/// Filter and sort options for the inventory product listing.
class InventoryFilter extends Equatable {
  const InventoryFilter({
    this.searchQuery = '',
    this.category,
    this.soldFilter = SoldFilter.all,
    this.purchaseDateFrom,
    this.purchaseDateTo,
    this.minPrice,
    this.maxPrice,
    this.sortOrder = SortOrder.newest,
    this.wearGroup,
  });

  final String searchQuery;
  final String? category;
  final SoldFilter soldFilter;
  final DateTime? purchaseDateFrom;
  final DateTime? purchaseDateTo;
  final double? minPrice;
  final double? maxPrice;
  final SortOrder sortOrder;
  final String? wearGroup;

  InventoryFilter copyWith({
    String? searchQuery,
    String? category,
    SoldFilter? soldFilter,
    DateTime? purchaseDateFrom,
    DateTime? purchaseDateTo,
    double? minPrice,
    double? maxPrice,
    SortOrder? sortOrder,
    String? wearGroup,
    bool clearCategory = false,
    bool clearPurchaseDateFrom = false,
    bool clearPurchaseDateTo = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearWearGroup = false,
  }) {
    return InventoryFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : category ?? this.category,
      soldFilter: soldFilter ?? this.soldFilter,
      purchaseDateFrom: clearPurchaseDateFrom
          ? null
          : purchaseDateFrom ?? this.purchaseDateFrom,
      purchaseDateTo: clearPurchaseDateTo
          ? null
          : purchaseDateTo ?? this.purchaseDateTo,
      minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      sortOrder: sortOrder ?? this.sortOrder,
      wearGroup: clearWearGroup ? null : wearGroup ?? this.wearGroup,
    );
  }

  bool get hasActiveFilters =>
      category != null ||
      soldFilter != SoldFilter.all ||
      purchaseDateFrom != null ||
      purchaseDateTo != null ||
      minPrice != null ||
      maxPrice != null ||
      wearGroup != null;

  @override
  List<Object?> get props => [
        searchQuery,
        category,
        soldFilter,
        purchaseDateFrom,
        purchaseDateTo,
        minPrice,
        maxPrice,
        sortOrder,
        wearGroup,
      ];
}

enum SoldFilter { all, sold, unsold }

enum SortOrder { newest, oldest }
