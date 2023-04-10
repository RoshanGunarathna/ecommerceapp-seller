import 'package:cloud_firestore/cloud_firestore.dart';
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
    return _products.snapshots().map((snap) => snap.docs.map((product) {
          return ProductModel.fromMap(product.data() as Map<String, dynamic>);
        }).toList());
  }

  //dev codes
  //get all the products
  Future<List<CategoryModel>> getProductDataFuture() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection("category").get();

    return querySnapshot.docs.map((productData) {
      final product = productData.data();
      return CategoryModel.fromMap(product as Map<String, dynamic>);
    }).toList();
  }

  //change and save
  Future<void> saveProductData(
      List<CategoryModel> sellerUserList, Ref ref, BuildContext context) async {
    //get the time&date in sri lanka
    String? dateAndTime = await ref
        .read(commonGetDateAndTimeControllerProvider.notifier)
        .getDateAndTime(context);

    for (CategoryModel sellerUser in sellerUserList) {
      final List<String> searchKeyword = [];
      final splittedMultipleWords = sellerUser.name.trim().split(" ");
      for (var element in splittedMultipleWords) {
        final String wordToLowercase = element.toLowerCase();
        for (var i = 1; i < wordToLowercase.length + 1; i++) {
          searchKeyword.add(wordToLowercase.substring(0, i));
        }
      }

      sellerUser = sellerUser.copyWith(
        dateTime:
            dateAndTime != null ? DateTime.parse(dateAndTime) : DateTime.now(),
      );

      await _firestore.collection("category").doc(sellerUser.id).set(
          CategoryModel.toMap(
              categoryModel: sellerUser, searchKeyword: searchKeyword));
    }
  }

  //trigger upper methods
  Future<void> getAndSaveProductData(Ref ref, BuildContext context) async {
    List<CategoryModel> products = await getProductDataFuture();
    await saveProductData(products, ref, context);
  }
}
