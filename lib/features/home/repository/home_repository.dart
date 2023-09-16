import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/core/common/controller/common_get_category_controller.dart';
import 'package:ecommerce_seller_app/core/common/controller/common_get_shipping_category_controller.dart';
import 'package:ecommerce_seller_app/features/auth/controller/auth_controller.dart';
import 'package:ecommerce_seller_app/models/shipping_category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/firebase_constants.dart';

import '../../../../core/providers/firebase_providers.dart';

import '../../../core/common/controller/common_get_date_and_time_controller.dart';
import '../../../models/category_model.dart';
import '../../../models/product.dart';
import '../../../models/seller_user_model.dart';
import '../../../models/user.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(
    firestore: ref.read(firestoreProvider),
  ),
);

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productCollection);

  //get product data
  Stream<List<ProductModel>> getProductData() {
    return _products
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((product) {
              return ProductModel.fromMap(
                  product.data() as Map<String, dynamic>);
            }).toList());
  }

  //dev codes ....................................................
  //get all the products
  Future<List<ProductModel>> getProductDataFuture() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection("products").get();

    return querySnapshot.docs.map((productData) {
      final product = productData.data();
      return ProductModel.fromMap(product as Map<String, dynamic>);
    }).toList();
  }

  //dev codes ....................................................
  //change and save
  Future<void> saveProductData(
      List<ProductModel> productList, Ref ref, BuildContext context) async {
    //get the time&date in sri lanka
    // String? dateAndTime = await ref
    //     .read(commonGetDateAndTimeControllerProvider.notifier)
    //     .getDateAndTime(context);

    for (ProductModel element in productList) {
      final List<String> searchKeyword = [];
      final splittedMultipleWords = element.name.trim().split(" ");
      for (var element in splittedMultipleWords) {
        final String wordToLowercase = element.toLowerCase();
        for (var i = 1; i < wordToLowercase.length + 1; i++) {
          searchKeyword.add(wordToLowercase.substring(0, i));
        }
      }
      // ignore: use_build_context_synchronously
      // final getShippingCategory = await ref
      //     .read(commonGetShippingCategoryControllerProvider.notifier)
      //     .getShippingCategoryData(context);

      // final List<CategoryModel> newCategoryList = [];
      // final List<CategoryModel> categoryList = ref.read(categoryProvider)!;

      // for (var category in element.category) {
      //   newCategoryList
      //       .add(categoryList.firstWhere((cat) => cat.name == category.name));
      // }

      // element = element.copyWith(
      //   shippingCategory: getShippingCategory![2],
      //   category: newCategoryList,
      // );
      print(element.name);

      await _firestore
          .collection("product_backup")
          .doc(ref.read(userProvider)!.uid)
          .collection(element.id)
          .add(
            ProductModel.toMap(
                productModel: element, searchKeyword: searchKeyword),
          );
    }
  }

  //dev codes ....................................................
  //trigger upper methods
  Future<void> getAndSaveProductData(Ref ref, BuildContext context) async {
    List<ProductModel> products = await getProductDataFuture();
    await saveProductData(products, ref, context);
  }
}
