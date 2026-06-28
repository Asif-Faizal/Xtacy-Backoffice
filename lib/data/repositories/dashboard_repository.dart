import 'package:xtacy_backoffice/core/constants/category_constants.dart';
import 'package:xtacy_backoffice/core/utils/date_utils.dart';
import 'package:xtacy_backoffice/data/models/dashboard_stats.dart';
import 'package:xtacy_backoffice/data/models/product_model.dart';
import 'package:xtacy_backoffice/data/repositories/product_repository.dart';

/// Repository for dashboard analytics computed from product data.
class DashboardRepository {
  DashboardRepository({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository();

  final ProductRepository _productRepository;

  Future<DashboardStats> getDashboardStats() async {
    final products = await _productRepository.getAllProducts();
    return _computeStats(products);
  }

  DashboardStats computeStatsFromProducts(List<ProductModel> products) {
    return _computeStats(products);
  }

  DashboardStats _computeStats(List<ProductModel> products) {
    final unsold = products.where((p) => !p.isSold).toList();
    final sold = products.where((p) => p.isSold).toList();
    final today = DateTime.now();

    final totalInvestment = unsold.fold<double>(
      0,
      (sum, p) => sum + p.purchasePrice,
    );

    final inventoryValue = unsold.fold<double>(
      0,
      (sum, p) => sum + (p.sellingPrice ?? p.purchasePrice),
    );

    final totalSales = sold.fold<double>(
      0,
      (sum, p) => sum + (p.soldPrice ?? 0),
    );

    final totalProfit = sold.fold<double>(
      0,
      (sum, p) => sum + ((p.soldPrice ?? 0) - p.purchasePrice),
    );

    final productsByCategory = <String, int>{};
    for (final product in products) {
      productsByCategory[product.category] =
          (productsByCategory[product.category] ?? 0) + 1;
    }

    final categorySummaries = <CategorySummary>[];
    for (final category in CategoryConstants.allCategories) {
      final catProducts = products.where((p) => p.category == category).toList();
      if (catProducts.isEmpty) continue;

      final catSold = catProducts.where((p) => p.isSold).toList();
      final catUnsold = catProducts.where((p) => !p.isSold).toList();

      categorySummaries.add(CategorySummary(
        category: category,
        purchased: catProducts.length,
        sold: catSold.length,
        remaining: catUnsold.length,
        investment: catUnsold.fold<double>(0, (s, p) => s + p.purchasePrice),
        revenue: catSold.fold<double>(0, (s, p) => s + (p.soldPrice ?? 0)),
        profit: catSold.fold<double>(
          0,
          (s, p) => s + ((p.soldPrice ?? 0) - p.purchasePrice),
        ),
      ));
    }

    final monthlyPurchases = <String, double>{};
    final monthlySales = <String, double>{};

    for (final product in products) {
      final purchaseKey = AppDateUtils.formatMonth(product.purchaseDate);
      monthlyPurchases[purchaseKey] =
          (monthlyPurchases[purchaseKey] ?? 0) + product.purchasePrice;

      if (product.isSold && product.soldDate != null) {
        final salesKey = AppDateUtils.formatMonth(product.soldDate!);
        monthlySales[salesKey] =
            (monthlySales[salesKey] ?? 0) + (product.soldPrice ?? 0);
      }
    }

    final purchasedToday = products.where((p) {
      return AppDateUtils.isSameDay(p.purchaseDate, today);
    }).length;

    final soldTodayList = sold.where((p) {
      return p.soldDate != null && AppDateUtils.isSameDay(p.soldDate!, today);
    }).toList();

    final todayRevenue =
        soldTodayList.fold<double>(0, (s, p) => s + (p.soldPrice ?? 0));

    final todayProfit = soldTodayList.fold<double>(
      0,
      (s, p) => s + ((p.soldPrice ?? 0) - p.purchasePrice),
    );

    return DashboardStats(
      totalInvestment: totalInvestment,
      inventoryValue: inventoryValue,
      totalSales: totalSales,
      totalProfit: totalProfit,
      productsPurchased: products.length,
      productsSold: sold.length,
      productsRemaining: unsold.length,
      categorySummaries: categorySummaries,
      productsByCategory: productsByCategory,
      soldCount: sold.length,
      unsoldCount: unsold.length,
      monthlyPurchases: monthlyPurchases,
      monthlySales: monthlySales,
      purchasedToday: purchasedToday,
      soldToday: soldTodayList.length,
      todayRevenue: todayRevenue,
      todayProfit: todayProfit,
    );
  }
}
