import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/constants/category_constants.dart';
import 'package:xtacy_backoffice/core/validators/form_validators.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/presentation/blocs/auth/auth_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/product/product_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/product_form/product_form_state.dart';
import 'package:xtacy_backoffice/presentation/widgets/confirm_dialog.dart';
import 'package:xtacy_backoffice/presentation/widgets/product_card.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colourController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _notesController = TextEditingController();
  final _merchantController =
      TextEditingController(text: AppConstants.defaultMerchantName);

  String? _category;
  String? _size;
  String? _sleeveType;
  DateTime _purchaseDate = DateTime.now();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProductFormBloc>().add(
          const ProductFormInitialized(mode: ProductFormMode.create),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colourController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _notesController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<ProductFormBloc>().add(ProductFormImagePicked(File(image.path)));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;

  final requiresSleeve = _category != null &&
        CategoryConstants.requiresSleeveType(_category!);

    if (requiresSleeve && _sleeveType == null) {
      showAppSnackBar(context, 'Please select sleeve type', isError: true);
      return;
    }

    context.read<ProductFormBloc>().add(
          ProductFormSubmitted(
            userId: user.uid,
            productName: _nameController.text.trim(),
            category: _category!,
            colour: _colourController.text.trim(),
            size: _size!,
            sleeveType: _sleeveType,
            purchaseDate: _purchaseDate,
            purchasePrice: double.parse(_purchasePriceController.text.trim()),
            sellingPrice: _sellingPriceController.text.trim().isNotEmpty
                ? double.parse(_sellingPriceController.text.trim())
                : null,
            notes: _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
            merchantName: _merchantController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state.status == ProductFormStatus.success) {
            context.read<ProductBloc>().add(const ProductsRefreshRequested());
            showAppSnackBar(context, 'Product added successfully');
            context.pop();
          }
          if (state.status == ProductFormStatus.failure &&
              state.errorMessage != null) {
            showAppSnackBar(context, state.errorMessage!, isError: true);
          }
        },
        builder: (context, formState) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProductImagePicker(
                  imageFile: formState.imageFile,
                  onPick: _pickImage,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name *'),
                  validator: FormValidators.productName,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category *'),
                  items: CategoryConstants.allCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _category = v;
                    if (v != null && !CategoryConstants.requiresSleeveType(v)) {
                      _sleeveType = null;
                    }
                  }),
                  validator: (v) =>
                      FormValidators.requiredSelection(v, fieldName: 'category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _colourController,
                  decoration: const InputDecoration(labelText: 'Colour *'),
                  validator: (v) => FormValidators.required(v, fieldName: 'Colour'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _size,
                  decoration: const InputDecoration(labelText: 'Size *'),
                  items: CategoryConstants.sizes
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _size = v),
                  validator: (v) =>
                      FormValidators.requiredSelection(v, fieldName: 'size'),
                ),
                if (_category != null &&
                    CategoryConstants.requiresSleeveType(_category!)) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _sleeveType,
                    decoration: const InputDecoration(labelText: 'Sleeve Type *'),
                    items: CategoryConstants.sleeveTypes
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _sleeveType = v),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _merchantController,
                  decoration: const InputDecoration(labelText: 'Merchant Name *'),
                  validator: FormValidators.merchantName,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Purchase Date *'),
                  subtitle: Text(
                    '${_purchaseDate.day}/${_purchaseDate.month}/${_purchaseDate.year}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _purchaseDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _purchaseDate = date);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _purchasePriceController,
                  decoration: const InputDecoration(labelText: 'Purchase Price *'),
                  keyboardType: TextInputType.number,
                  validator: FormValidators.price,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sellingPriceController,
                  decoration: const InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) => FormValidators.price(v, required: false),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: formState.status == ProductFormStatus.submitting
                      ? null
                      : _submit,
                  child: formState.status == ProductFormStatus.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Add Product'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _colourController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _notesController;

  late String? _category;
  late String? _size;
  late String? _sleeveType;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p.productName);
    _colourController = TextEditingController(text: p.colour);
    _purchasePriceController =
        TextEditingController(text: p.purchasePrice.toString());
    _sellingPriceController = TextEditingController(
      text: p.sellingPrice?.toString() ?? '',
    );
    _notesController = TextEditingController(text: p.notes ?? '');
    _category = p.category;
    _size = p.size;
    _sleeveType = p.sleeveType;

    context.read<ProductFormBloc>().add(
          ProductFormInitialized(
            product: p,
            mode: ProductFormMode.edit,
          ),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colourController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<ProductFormBloc>().add(ProductFormImagePicked(File(image.path)));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;

    final requiresSleeve =
        _category != null && CategoryConstants.requiresSleeveType(_category!);

    if (requiresSleeve && _sleeveType == null) {
      showAppSnackBar(context, 'Please select sleeve type', isError: true);
      return;
    }

    context.read<ProductFormBloc>().add(
          ProductFormSubmitted(
            userId: user.uid,
            productName: _nameController.text.trim(),
            category: _category!,
            colour: _colourController.text.trim(),
            size: _size!,
            sleeveType: _sleeveType,
            purchaseDate: widget.product.purchaseDate,
            purchasePrice: double.parse(_purchasePriceController.text.trim()),
            sellingPrice: _sellingPriceController.text.trim().isNotEmpty
                ? double.parse(_sellingPriceController.text.trim())
                : null,
            notes: _notesController.text.trim().isNotEmpty
                ? _notesController.text.trim()
                : null,
            merchantName: widget.product.merchantName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state.status == ProductFormStatus.success) {
            context.read<ProductBloc>().add(const ProductsRefreshRequested());
            showAppSnackBar(context, 'Product updated successfully');
            context.pop();
          }
          if (state.status == ProductFormStatus.failure &&
              state.errorMessage != null) {
            showAppSnackBar(context, state.errorMessage!, isError: true);
          }
        },
        builder: (context, formState) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProductImagePicker(
                  imageUrl: widget.product.imageUrl,
                  imageFile: formState.imageFile,
                  onPick: _pickImage,
                ),
                const SizedBox(height: 8),
                Text(
                  'Code: ${widget.product.productCode}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name *'),
                  validator: FormValidators.productName,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category *'),
                  items: CategoryConstants.allCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _category = v;
                    if (v != null && !CategoryConstants.requiresSleeveType(v)) {
                      _sleeveType = null;
                    }
                  }),
                  validator: (v) =>
                      FormValidators.requiredSelection(v, fieldName: 'category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _colourController,
                  decoration: const InputDecoration(labelText: 'Colour *'),
                  validator: (v) => FormValidators.required(v, fieldName: 'Colour'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _size,
                  decoration: const InputDecoration(labelText: 'Size *'),
                  items: CategoryConstants.sizes
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _size = v),
                  validator: (v) =>
                      FormValidators.requiredSelection(v, fieldName: 'size'),
                ),
                if (_category != null &&
                    CategoryConstants.requiresSleeveType(_category!)) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _sleeveType,
                    decoration: const InputDecoration(labelText: 'Sleeve Type *'),
                    items: CategoryConstants.sleeveTypes
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _sleeveType = v),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _purchasePriceController,
                  decoration: const InputDecoration(labelText: 'Purchase Price *'),
                  keyboardType: TextInputType.number,
                  validator: FormValidators.price,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sellingPriceController,
                  decoration: const InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) => FormValidators.price(v, required: false),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: formState.status == ProductFormStatus.submitting
                      ? null
                      : _submit,
                  child: formState.status == ProductFormStatus.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
