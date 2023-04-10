import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/common/controller/common_get_category_controller.dart';
import '../../../core/common/controller/common_get_date_and_time_controller.dart';
import '../../../core/common/repositories/common_firebase_storage_repository.dart';

import '../../../core/constants/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';

import '../../../core/type_defs.dart';
import '../../../models/category_model.dart';
import '../../../models/product.dart';

final productAddRepositoryProvider = Provider(
  (ref) => ProductAddRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  ),
);

class ProductAddRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProductAddRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productCollection);

//save product data in firebase
  FutureEither<bool> saveProductInFirebase({
    required Ref ref,
    required List<File> productImages,
    required List<String> productImageUrls,
    required String productID,
    required String productName,
    required String productDescription,
    required List<CategoryModel> category,
    required String sellerUserId,
    required double productPrice,
    required int quantity,
    required double? kg,
    required int? discount,
    required BuildContext context,
  }) async {
    var returnData;
    print("discount: $discount");
    try {
      late List<String> newProductImageUrls = [];

      if (productImages.isNotEmpty) {
        for (var i = 0; i < productImages.length; i++) {
          String imageUrl = '';
          final res = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storageFileToFirebase(
                  'product/${productID}_$i', productImages[i]);
          res.fold((l) => throw l.toString(), (r) => imageUrl = r);
          newProductImageUrls.add(imageUrl);
        }
      } else {
        newProductImageUrls.addAll(productImageUrls);
      }

      //get the time&date in sri lanka
      String? dateAndTime = await ref
          .read(commonGetDateAndTimeControllerProvider.notifier)
          .getDateAndTime(context);

      //Product to save in firebase
      var product = ProductModel(
        id: productID,
        name: productName,
        description: productDescription,
        category: category,
        sellerUserId: sellerUserId,
        images: newProductImageUrls,
        price: productPrice,
        quantity: quantity,
        kg: kg,
        discount: discount,
        dateTime:
            dateAndTime != null ? DateTime.parse(dateAndTime) : DateTime.now(),
      );

      //Generate search Keywords
      final List<String> searchKeyword = [];
      final splittedMultipleWords = product.name.trim().split(" ");
      for (var element in splittedMultipleWords) {
        final String wordToLowercase = element.toLowerCase();
        for (var i = 1; i < wordToLowercase.length + 1; i++) {
          searchKeyword.add(wordToLowercase.substring(0, i));
        }
      }

      //save a product in firebase function
      await _products.doc(productID).set(ProductModel.toMap(
          productModel: product, searchKeyword: searchKeyword));

      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //get category list
  Future<bool> getCategoryData(
      {required Ref ref, required BuildContext context}) async {
    return await ref
        .read(commonGetCategoryControllerProvider.notifier)
        .getCategoryData(context);
  }

  //delete a Product
  FutureEither<bool> deleteAProduct(String productID) async {
    try {
      final docRef = _products.doc(productID);
      await docRef.delete();
      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
