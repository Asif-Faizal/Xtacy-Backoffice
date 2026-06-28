import 'package:equatable/equatable.dart';
import 'package:xtacy_backoffice/data/models/inventory_filter.dart';

class InventoryFilterState extends Equatable {
  const InventoryFilterState({this.filter = const InventoryFilter()});

  final InventoryFilter filter;

  InventoryFilterState copyWith({InventoryFilter? filter}) {
    return InventoryFilterState(filter: filter ?? this.filter);
  }

  @override
  List<Object?> get props => [filter];
}
