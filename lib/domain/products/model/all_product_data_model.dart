// all_products_data_model.dart

class AllProductsDataModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final ProductRating? rating;
  final bool? isCartItem;

  AllProductsDataModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
    this.isCartItem = false,
  });

  factory AllProductsDataModel.fromJson(Map<String, dynamic> json) {
    return AllProductsDataModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      image: json['image'] as String?,
      rating: json['rating'] != null
          ? ProductRating.fromJson(json['rating'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,

      'category': category,
      'image': image,
    };
  }

  AllProductsDataModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    ProductRating? rating,
    bool? isCartItem,
  }) {
    return AllProductsDataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isCartItem: isCartItem ?? this.isCartItem,
    );
  }

  /// Helper for parsing list response
  static List<AllProductsDataModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => AllProductsDataModel.fromJson(e)).toList();
  }
}

class ProductRating {
  final double? rate;
  final int? count;

  ProductRating({this.rate, this.count});

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      rate: (json['rate'] as num?)?.toDouble(),
      count: json['count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
