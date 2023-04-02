// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce_seller_app/models/category_model.dart';

import 'rating.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final List<CategoryModel> category;
  final String sellerUserId;
  final List<String> images;
  final double price;
  final int quantity;
  final List<Rating>? rating;
  final double? kg;
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sellerUserId,
    required this.images,
    required this.price,
    required this.quantity,
    required this.kg,
    this.rating,
  });

  static Map<String, dynamic> toMap(ProductModel productModel) {
    return <String, dynamic>{
      'id': productModel.id,
      'name': productModel.name,
      'description': productModel.description,
      'category': productModel.category.map(
        (category) => CategoryModel.toMap(category),
      ),
      'sellerUserId': productModel.sellerUserId,
      'images': productModel.images,
      'price': productModel.price,
      'quantity': productModel.quantity,
      'rating': productModel.rating != null
          ? productModel.rating!.map((ratingModel) => Rating.toMap(ratingModel))
          : null,
      'kg': productModel.kg,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final productModel = ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: List<CategoryModel>.from(
          map['category']?.map((res) => CategoryModel.fromMap(res))),
      sellerUserId: map['sellerUserId'] as String,
      images: List<String>.from(map['images']),
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      kg: map['kg'] != null ? map['kg'] as double : null,
      rating: map['rating'] != null
          ? List<Rating>.from(map['rating']?.map((res) => Rating.fromMap(res)))
          : null,
    );

    return productModel;
  }
}
