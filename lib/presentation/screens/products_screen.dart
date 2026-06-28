import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/core/constants/category_constants.dart';
import 'package:xtacy_backoffice/data/models/inventory_filter.dart';
import 'package:xtacy_backoffice/data/repositories/product_repository.dart';
import 'package:xtacy_backoffice/presentation/blocs/inventory_filter/inventory_filter_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/inventory_filter/inventory_filter_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/inventory_filter/inventory_filter_state.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_state.dart';
import 'package:xtacy_backoffice/presentation/widgets/confirm_dialog.dart';
import 'package:xtacy_backoffice/presentation/widgets/empty_state_widget.dart';
import 'package:xtacy_backoffice/presentation/widgets/product_card.dart';
import 'package:xtacy_backoffice/presentation/widgets/shimmer_loading.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_onTabChanged);
    context.read<ProductBloc>().add(const ProductsLoadRequested());
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _applyTabFilter(_tabController.index);
    }
  }

  void _applyTabFilter(int index) {
    final filterBloc = context.read<InventoryFilterBloc>();
    switch (index) {
      case 0:
        filterBloc.add(const InventoryFilterWearGroupChanged(null));
        filterBloc.add(const InventoryFilterSoldChanged(SoldFilter.all));
      case 1:
        filterBloc.add(const InventoryFilterWearGroupChanged(null));
        filterBloc.add(const InventoryFilterSoldChanged(SoldFilter.unsold));
      case 2:
        filterBloc.add(const InventoryFilterWearGroupChanged(null));
        filterBloc.add(const InventoryFilterSoldChanged(SoldFilter.sold));
      case 3:
        filterBloc.add(InventoryFilterWearGroupChanged(CategoryConstants.upperWearGroup));
        filterBloc.add(const InventoryFilterSoldChanged(SoldFilter.all));
      case 4:
        filterBloc.add(InventoryFilterWearGroupChanged(CategoryConstants.lowerWearGroup));
        filterBloc.add(const InventoryFilterSoldChanged(SoldFilter.all));
      case 5:
        filterBloc.add(InventoryFilterWearGroupChanged(CategoryConstants.accessoriesGroup));
        filterBloc.add(const InventoryFilterSoldChanged(SoldFilter.all));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unsold'),
            Tab(text: 'Sold'),
            Tab(text: 'Upper Wear'),
            Tab(text: 'Lower Wear'),
            Tab(text: 'Accessories'),
          ],
        ),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.actionMessage != null) {
            showAppSnackBar(context, state.actionMessage!);
          }
          if (state.errorMessage != null) {
            showAppSnackBar(context, state.errorMessage!, isError: true);
          }
        },
        builder: (context, productState) {
          if (productState.status == ProductStatus.loading) {
            return const ShimmerLoading();
          }

          if (productState.status == ProductStatus.failure) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Failed to load products',
              subtitle: productState.errorMessage,
              action: ElevatedButton(
                onPressed: () =>
                    context.read<ProductBloc>().add(const ProductsLoadRequested()),
                child: const Text('Retry'),
              ),
            );
          }

          return BlocBuilder<InventoryFilterBloc, InventoryFilterState>(
            builder: (context, filterState) {
              final repository = ProductRepository();
              final filtered = repository.applyFilter(
                productState.products,
                filterState.filter,
              );

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name, code, or colour...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<InventoryFilterBloc>().add(
                                        const InventoryFilterSearchChanged(''),
                                      );
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        context.read<InventoryFilterBloc>().add(
                              InventoryFilterSearchChanged(value),
                            );
                      },
                    ),
                  ),
                  if (filterState.filter.hasActiveFilters)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_alt, size: 16, color: AppTheme.carbonBlue),
                          const SizedBox(width: 4),
                          Text(
                            'Filters active',
                            style: TextStyle(color: AppTheme.carbonBlue, fontSize: 12),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              context.read<InventoryFilterBloc>().add(
                                    const InventoryFilterReset(),
                                  );
                              _applyTabFilter(_tabController.index);
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: filtered.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.inventory_2_outlined,
                            title: 'No products found',
                            subtitle: 'Try adjusting your search or filters',
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              context.read<ProductBloc>().add(
                                    const ProductsRefreshRequested(),
                                  );
                              await Future<void>.delayed(
                                const Duration(milliseconds: 500),
                              );
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount =
                                    constraints.maxWidth > 900 ? 4
                                    : constraints.maxWidth > 600 ? 3
                                    : 2;

                                return GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 0.72,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final product = filtered[index];
                                    return ProductCard(
                                      product: product,
                                      onTap: () => context.push(
                                        '/products/${product.id}',
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final filterBloc = context.read<InventoryFilterBloc>();
    final currentFilter = filterBloc.state.filter;

    String? selectedCategory = currentFilter.category;
    SoldFilter soldFilter = currentFilter.soldFilter;
    SortOrder sortOrder = currentFilter.sortOrder;
    DateTime? dateFrom = currentFilter.purchaseDateFrom;
    DateTime? dateTo = currentFilter.purchaseDateTo;
    final minPriceController = TextEditingController(
      text: currentFilter.minPrice?.toString() ?? '',
    );
    final maxPriceController = TextEditingController(
      text: currentFilter.maxPrice?.toString() ?? '',
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Categories')),
                        ...CategoryConstants.allCategories.map(
                          (c) => DropdownMenuItem(value: c, child: Text(c)),
                        ),
                      ],
                      onChanged: (v) => setSheetState(() => selectedCategory = v),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<SoldFilter>(
                      value: soldFilter,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(value: SoldFilter.all, child: Text('All')),
                        DropdownMenuItem(value: SoldFilter.sold, child: Text('Sold')),
                        DropdownMenuItem(value: SoldFilter.unsold, child: Text('Unsold')),
                      ],
                      onChanged: (v) {
                        if (v != null) setSheetState(() => soldFilter = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<SortOrder>(
                      value: sortOrder,
                      decoration: const InputDecoration(labelText: 'Sort By'),
                      items: const [
                        DropdownMenuItem(value: SortOrder.newest, child: Text('Newest')),
                        DropdownMenuItem(value: SortOrder.oldest, child: Text('Oldest')),
                      ],
                      onChanged: (v) {
                        if (v != null) setSheetState(() => sortOrder = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: dateFrom ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setSheetState(() => dateFrom = date);
                              }
                            },
                            child: Text(
                              dateFrom != null
                                  ? 'From: ${dateFrom!.day}/${dateFrom!.month}/${dateFrom!.year}'
                                  : 'Purchase From',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: dateTo ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setSheetState(() => dateTo = date);
                              }
                            },
                            child: Text(
                              dateTo != null
                                  ? 'To: ${dateTo!.day}/${dateTo!.month}/${dateTo!.year}'
                                  : 'Purchase To',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minPriceController,
                            decoration: const InputDecoration(labelText: 'Min Price'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: maxPriceController,
                            decoration: const InputDecoration(labelText: 'Max Price'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        filterBloc.add(InventoryFilterCategoryChanged(selectedCategory));
                        filterBloc.add(InventoryFilterSoldChanged(soldFilter));
                        filterBloc.add(InventoryFilterSortChanged(sortOrder));
                        filterBloc.add(InventoryFilterDateRangeChanged(
                          from: dateFrom,
                          to: dateTo,
                        ));
                        filterBloc.add(InventoryFilterPriceRangeChanged(
                          minPrice: double.tryParse(minPriceController.text),
                          maxPrice: double.tryParse(maxPriceController.text),
                        ));
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
