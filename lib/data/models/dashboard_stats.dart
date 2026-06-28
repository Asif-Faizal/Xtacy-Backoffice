import 'package:equatable/equatable.dart';

/// Aggregated dashboard statistics computed from product inventory.
class DashboardStats extends Equatable {
  const DashboardStats({
    required this.totalInvestment,
    required this.inventoryValue,
    required this.totalSales,
    required this.totalProfit,
    required this.productsPurchased,
    required this.productsSold,
    required this.productsRemaining,
    required this.categorySummaries,
    required this.productsByCategory,
    required this.soldCount,
    required this.unsoldCount,
    required this.monthlyPurchases,
    required this.monthlySales,
    required this.purchasedToday,
    required this.soldToday,
    required this.todayRevenue,
    required this.todayProfit,
  });

  final double totalInvestment;
  final double inventoryValue;
  final double totalSales;
  final double totalProfit;
  final int productsPurchased;
  final int productsSold;
  final int productsRemaining;
  final List<CategorySummary> categorySummaries;
  final Map<String, int> productsByCategory;
  final int soldCount;
  final int unsoldCount;
  final Map<String, double> monthlyPurchases;
  final Map<String, double> monthlySales;
  final int purchasedToday;
  final int soldToday;
  final double todayRevenue;
  final double todayProfit;

  static const empty = DashboardStats(
    totalInvestment: 0,
    inventoryValue: 0,
    totalSales: 0,
    totalProfit: 0,
    productsPurchased: 0,
    productsSold: 0,
    productsRemaining: 0,
    categorySummaries: [],
    productsByCategory: {},
    soldCount: 0,
    unsoldCount: 0,
    monthlyPurchases: {},
    monthlySales: {},
    purchasedToday: 0,
    soldToday: 0,
    todayRevenue: 0,
    todayProfit: 0,
  );

  @override
  List<Object?> get props => [
        totalInvestment,
        inventoryValue,
        totalSales,
        totalProfit,
        productsPurchased,
        productsSold,
        productsRemaining,
        categorySummaries,
        productsByCategory,
        soldCount,
        unsoldCount,
        monthlyPurchases,
        monthlySales,
        purchasedToday,
        soldToday,
        todayRevenue,
        todayProfit,
      ];
}

/// Per-category breakdown for dashboard summary cards.
class CategorySummary extends Equatable {
  const CategorySummary({
    required this.category,
    required this.purchased,
    required this.sold,
    required this.remaining,
    required this.investment,
    required this.revenue,
    required this.profit,
  });

  final String category;
  final int purchased;
  final int sold;
  final int remaining;
  final double investment;
  final double revenue;
  final double profit;

  @override
  List<Object?> get props =>
      [category, purchased, sold, remaining, investment, revenue, profit];
}
