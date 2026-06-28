/// Product category definitions and sleeve type options.
class CategoryConstants {
  CategoryConstants._();

  static const String upperWearGroup = 'Upper Wear';
  static const String lowerWearGroup = 'Lower Wear';
  static const String accessoriesGroup = 'Accessories';

  static const List<String> upperWearCategories = [
    'Oversized Tee',
    'Regular Tee',
    'Shirt',
    'Hoodie',
    'Sweatshirt',
    'Tank Top',
  ];

  static const List<String> lowerWearCategories = [
    'Jeans',
    'Cargo',
    'Jogger',
    'Shorts',
    'Trouser',
  ];

  static const List<String> accessoriesCategories = [
    'Cap',
    'Belt',
    'Bag',
    'Socks',
    'Other',
  ];

  static const List<String> allCategories = [
    ...upperWearCategories,
    ...lowerWearCategories,
    ...accessoriesCategories,
  ];

  static const List<String> sleeveTypes = [
    'Full Sleeve',
    'Half Sleeve',
    'Sleeveless',
    'Oversized',
  ];

  static const List<String> sizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL',
  ];

  static const List<String> genders = ['Men', 'Women', 'Unisex'];

  /// Returns true if the category requires sleeve type selection.
  static bool requiresSleeveType(String category) {
    return upperWearCategories.contains(category);
  }

  /// Returns the wear group for a category.
  static String getWearGroup(String category) {
    if (upperWearCategories.contains(category)) return upperWearGroup;
    if (lowerWearCategories.contains(category)) return lowerWearGroup;
    return accessoriesGroup;
  }
}
