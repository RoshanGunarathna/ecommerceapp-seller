// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'rating.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final List<String> category;
  final String sellerUserId;
  final List<String> images;
  final double price;
  final int quantity;
  final List<Rating>? rating;
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sellerUserId,
    required this.images,
    required this.price,
    required this.quantity,
    this.rating,
  });

  static Map<String, dynamic> toMap(ProductModel productModel) {
    return <String, dynamic>{
      'id': productModel.id,
      'name': productModel.name,
      'description': productModel.description,
      'category': productModel.category,
      'sellerUserId': productModel.sellerUserId,
      'images': productModel.images,
      'price': productModel.price,
      'quantity': productModel.quantity,
      'rating': productModel.rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    print(map['id'].runtimeType);
    print(map['name'].runtimeType);
    print(map['description'].runtimeType);
    print(map['category'].runtimeType);
    print(map['sellerUserId'].runtimeType);
    print(map['images'].runtimeType);
    print(map['price'].runtimeType);
    print(map['quantity'].runtimeType);
    print(map['rating'].runtimeType);

    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: List<String>.from(map['category']),
      sellerUserId: map['sellerUserId'] as String,
      images: List<String>.from(map['images']),
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      rating: null,
    );
  }
}
