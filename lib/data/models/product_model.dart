import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Product entity representing a clothing inventory item.
class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.productCode,
    required this.productName,
    required this.category,
    required this.gender,
    required this.purchaseDate,
    required this.merchantName,
    required this.purchasePrice,
    this.sellingPrice,
    this.soldPrice,
    required this.isSold,
    this.soldDate,
    this.customerName,
    this.customerPhone,
    this.imageUrl,
    this.sleeveType,
    required this.colour,
    required this.size,
    required this.quantity,
    this.notes,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final String productCode;
  final String productName;
  final String category;
  final String gender;
  final DateTime purchaseDate;
  final String merchantName;
  final double purchasePrice;
  final double? sellingPrice;
  final double? soldPrice;
  final bool isSold;
  final DateTime? soldDate;
  final String? customerName;
  final String? customerPhone;
  final String? imageUrl;
  final String? sleeveType;
  final String colour;
  final String size;
  final int quantity;
  final String? notes;

  ProductModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? productCode,
    String? productName,
    String? category,
    String? gender,
    DateTime? purchaseDate,
    String? merchantName,
    double? purchasePrice,
    double? sellingPrice,
    double? soldPrice,
    bool? isSold,
    DateTime? soldDate,
    String? customerName,
    String? customerPhone,
    String? imageUrl,
    String? sleeveType,
    String? colour,
    String? size,
    int? quantity,
    String? notes,
    bool clearSellingPrice = false,
    bool clearSoldPrice = false,
    bool clearSoldDate = false,
    bool clearCustomerName = false,
    bool clearCustomerPhone = false,
    bool clearImageUrl = false,
    bool clearSleeveType = false,
    bool clearNotes = false,
  }) {
    return ProductModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      merchantName: merchantName ?? this.merchantName,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: clearSellingPrice ? null : sellingPrice ?? this.sellingPrice,
      soldPrice: clearSoldPrice ? null : soldPrice ?? this.soldPrice,
      isSold: isSold ?? this.isSold,
      soldDate: clearSoldDate ? null : soldDate ?? this.soldDate,
      customerName: clearCustomerName ? null : customerName ?? this.customerName,
      customerPhone: clearCustomerPhone ? null : customerPhone ?? this.customerPhone,
      imageUrl: clearImageUrl ? null : imageUrl ?? this.imageUrl,
      sleeveType: clearSleeveType ? null : sleeveType ?? this.sleeveType,
      colour: colour ?? this.colour,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      notes: clearNotes ? null : notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'productCode': productCode,
      'productName': productName,
      'category': category,
      'gender': gender,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'merchantName': merchantName,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'soldPrice': soldPrice,
      'isSold': isSold,
      'soldDate': soldDate != null ? Timestamp.fromDate(soldDate!) : null,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'imageUrl': imageUrl,
      'sleeveType': sleeveType,
      'colour': colour,
      'size': size,
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      createdBy: json['createdBy'] as String,
      updatedBy: json['updatedBy'] as String,
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String,
      gender: json['gender'] as String? ?? 'Men',
      purchaseDate: _parseDate(json['purchaseDate']),
      merchantName: json['merchantName'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: json['sellingPrice'] != null
          ? (json['sellingPrice'] as num).toDouble()
          : null,
      soldPrice: json['soldPrice'] != null
          ? (json['soldPrice'] as num).toDouble()
          : null,
      isSold: json['isSold'] as bool? ?? false,
      soldDate: json['soldDate'] != null ? _parseDate(json['soldDate']) : null,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      imageUrl: json['imageUrl'] as String?,
      sleeveType: json['sleeveType'] as String?,
      colour: json['colour'] as String,
      size: json['size'] as String,
      quantity: json['quantity'] as int? ?? 1,
      notes: json['notes'] as String?,
    );
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson({...data, 'id': doc.id});
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    throw FormatException('Invalid date value: $value');
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
        productCode,
        productName,
        category,
        gender,
        purchaseDate,
        merchantName,
        purchasePrice,
        sellingPrice,
        soldPrice,
        isSold,
        soldDate,
        customerName,
        customerPhone,
        imageUrl,
        sleeveType,
        colour,
        size,
        quantity,
        notes,
      ];
}
