import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';
import 'package:xtacy_backoffice/core/utils/currency_formatter.dart';
import 'package:xtacy_backoffice/core/utils/date_utils.dart';
import 'package:xtacy_backoffice/core/validators/form_validators.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/data/repositories/product_repository.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_event.dart';
import 'package:xtacy_backoffice/presentation/widgets/confirm_dialog.dart';
import 'package:xtacy_backoffice/presentation/widgets/status_badge.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductModel? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final product = await ProductRepository().getProduct(widget.productId);
      if (product == null) {
        setState(() {
          _error = 'Product not found';
          _loading = false;
        });
        return;
      }
      setState(() {
        _product = product;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _showMarkSoldDialog() async {
    final product = _product!;
    final customerNameController = TextEditingController();
    final customerPhoneController = TextEditingController();
    final soldPriceController = TextEditingController(
      text: product.sellingPrice?.toString() ?? '',
    );
    final notesController = TextEditingController(text: product.notes ?? '');
    DateTime soldDate = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Mark as Sold'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name *',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: customerPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Phone *',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: soldPriceController,
                      decoration: const InputDecoration(labelText: 'Sold Price *'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Sold Date *'),
                      subtitle: Text(AppDateUtils.formatDisplay(soldDate)),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: soldDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setDialogState(() => soldDate = date);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nameError = FormValidators.required(
                      customerNameController.text,
                      fieldName: 'Customer name',
                    );
                    final phoneError = FormValidators.phone(customerPhoneController.text);
                    final priceError = FormValidators.price(soldPriceController.text);

                    if (nameError != null || phoneError != null || priceError != null) {
                      showAppSnackBar(
                        context,
                        nameError ?? phoneError ?? priceError!,
                        isError: true,
                      );
                      return;
                    }

                    final user = context.read<AuthBloc>().state.user;
                    if (user == null) return;

                    context.read<ProductBloc>().add(
                          ProductMarkSoldRequested(
                            product: product,
                            customerName: customerNameController.text.trim(),
                            customerPhone: customerPhoneController.text.trim(),
                            soldPrice: double.parse(soldPriceController.text.trim()),
                            soldDate: soldDate,
                            notes: notesController.text.trim().isNotEmpty
                                ? notesController.text.trim()
                                : null,
                            userId: user.uid,
                          ),
                        );
                    context.read<DashboardBloc>().add(const DashboardRefreshRequested());
                    Navigator.pop(dialogContext);
                    _loadProduct();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Product',
      message: 'Are you sure you want to delete this product? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      context.read<ProductBloc>().add(ProductDeleteRequested(widget.productId));
      context.read<DashboardBloc>().add(const DashboardRefreshRequested());
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: Center(child: Text(_error ?? 'Product not found')),
      );
    }

    final product = _product!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          if (!product.isSold)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(
                '/products/${product.id}/edit',
                extra: product,
              ),
            ),
        ],
      ),
      body: ListView(
        children: [
          if (product.imageUrl != null)
            CachedNetworkImage(
              imageUrl: product.imageUrl!,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 280,
                color: AppTheme.carbonGray20,
              ),
              errorWidget: (_, __, ___) => Container(
                height: 280,
                color: AppTheme.carbonGray20,
                child: const Icon(Icons.broken_image_outlined, size: 48),
              ),
            )
          else
            Container(
              height: 200,
              color: AppTheme.carbonGray20,
              child: const Center(
                child: Icon(Icons.image_outlined, size: 64, color: AppTheme.carbonGray50),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    StatusBadge(isSold: product.isSold),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.productCode,
                  style: TextStyle(color: AppTheme.carbonGray50),
                ),
                const SizedBox(height: 24),
                _DetailSection(title: 'Inventory', children: [
                  _DetailRow('Category', product.category),
                  _DetailRow('Gender', product.gender),
                  _DetailRow('Colour', product.colour),
                  _DetailRow('Size', product.size),
                  if (product.sleeveType != null)
                    _DetailRow('Sleeve', product.sleeveType!),
                  _DetailRow('Quantity', '${product.quantity}'),
                  _DetailRow('Merchant', product.merchantName),
                  _DetailRow(
                    'Purchase Date',
                    AppDateUtils.formatDisplay(product.purchaseDate),
                  ),
                ]),
                _DetailSection(title: 'Pricing', children: [
                  _DetailRow(
                    'Purchase Price',
                    CurrencyFormatter.format(product.purchasePrice),
                  ),
                  _DetailRow(
                    'Selling Price',
                    CurrencyFormatter.formatNullable(product.sellingPrice),
                  ),
                  if (product.isSold)
                    _DetailRow(
                      'Sold Price',
                      CurrencyFormatter.formatNullable(product.soldPrice),
                    ),
                ]),
                if (product.isSold)
                  _DetailSection(title: 'Sale Details', children: [
                    _DetailRow('Customer', product.customerName ?? '—'),
                    _DetailRow('Phone', product.customerPhone ?? '—'),
                    if (product.soldDate != null)
                      _DetailRow(
                        'Sold Date',
                        AppDateUtils.formatDisplay(product.soldDate!),
                      ),
                  ]),
                if (product.notes != null && product.notes!.isNotEmpty)
                  _DetailSection(title: 'Notes', children: [
                    Text(product.notes!),
                  ]),
                const SizedBox(height: 24),
                if (!product.isSold) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showMarkSoldDialog,
                      icon: const Icon(Icons.sell_outlined),
                      label: const Text('Mark as Sold'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _deleteProduct,
                    icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
                    label: const Text('Delete Product',
                        style: TextStyle(color: AppTheme.errorRed)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.errorRed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: AppTheme.carbonGray50)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
