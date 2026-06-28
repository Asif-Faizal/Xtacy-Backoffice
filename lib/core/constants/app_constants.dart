/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Xtacy Backoffice';
  static const String defaultGender = 'Men';
  static const String defaultMerchantName = 'Xtacy Store';
  static const int defaultQuantity = 1;
  static const String productCodePrefix = 'XT';
  static const int productPageSize = 20;
  static const String productsCollection = 'products';
  static const String usersCollection = 'users';
  static const String metadataCollection = 'metadata';
  static const String productCounterDoc = 'product_counter';
  static const String hiveBoxName = 'xtacy_cache';
  static const String hiveProductsKey = 'cached_products';
}
