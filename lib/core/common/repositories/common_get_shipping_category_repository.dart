import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/models/shipping_category_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';

final commonGetShippingCategoryRepositoryProvider = Provider(
  (ref) => CommonGetShippingCategoryRepository(
    firestore: ref.read(firestoreProvider),
  ),
);

class CommonGetShippingCategoryRepository {
  final FirebaseFirestore _firestore;

  CommonGetShippingCategoryRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _shippingCategory =>
      _firestore.collection(FirebaseConstants.shippingCategoryCollection);

//get shipping category data
  FutureEither<List<ShippingCategoryModel>> getShippingCategoryData() async {
    try {
      final QuerySnapshot querySnapshot = await _shippingCategory.get();
      final List<ShippingCategoryModel> shippingCategoryList = querySnapshot
          .docs
          .map((DocumentSnapshot documentSnapshot) =>
              ShippingCategoryModel.fromMap(
                  documentSnapshot.data() as Map<String, dynamic>))
          .toList();
      return right(shippingCategoryList);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
