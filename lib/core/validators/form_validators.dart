/// Form field validators for product and auth forms.
class FormValidators {
  FormValidators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? requiredSelection(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return 'Please select $fieldName';
    }
    return null;
  }

  static String? price(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Price is required' : null;
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid price';
    }
    if (parsed < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }

  static String? phone(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Phone number is required' : null;
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^\+?[\d]{7,15}$').hasMatch(cleaned)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? productName(String? value) {
    final result = required(value, fieldName: 'Product name');
    if (result != null) return result;
    if (value!.trim().length < 2) {
      return 'Product name must be at least 2 characters';
    }
    return null;
  }

  static String? merchantName(String? value) {
    return required(value, fieldName: 'Merchant name');
  }
}
