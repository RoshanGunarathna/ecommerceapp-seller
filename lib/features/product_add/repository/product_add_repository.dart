import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/common/repositories/common_firebase_storage_repository.dart';

import '../../../core/constants/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';

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

//get product data
  Stream<List<ProductModel>> getProductData() {
    return _products.snapshots().map((snap) => snap.docs.map((product) {
          return ProductModel.fromMap(product.data() as Map<String, dynamic>);
        }).toList());
  }

//save product data in firebase
  FutureEither<bool> saveProductInFirebase({
    required Ref ref,
    required List<File> productImages,
    required List<String> productImageUrls,
    required String productID,
    required String productName,
    required String productDescription,
    required List<String> category,
    required String sellerUserId,
    required double productPrice,
    required int quantity,
  }) async {
    var returnData;
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

      var product = ProductModel(
        id: productID,
        name: productName,
        description: productDescription,
        category: category,
        sellerUserId: sellerUserId,
        images: newProductImageUrls,
        price: productPrice,
        quantity: quantity,
      );

      await _products.doc(productID).set(ProductModel.toMap(product));

      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
