import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';

import '../../../models/category_model.dart';

final commonGetCategoryRepositoryProvider = Provider(
  (ref) => CommonGetCategoryRepository(
    firestore: ref.read(firestoreProvider),
  ),
);

class CommonGetCategoryRepository {
  final FirebaseFirestore _firestore;

  CommonGetCategoryRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _category =>
      _firestore.collection(FirebaseConstants.categoryCollection);

//get category data
  FutureEither<List<CategoryModel>> getCategoryData() async {
    try {
      final QuerySnapshot querySnapshot = await _category.get();
      final List<CategoryModel> categoryList = querySnapshot.docs
          .map((DocumentSnapshot documentSnapshot) => CategoryModel.fromMap(
              documentSnapshot.data() as Map<String, dynamic>))
          .toList();
      return right(categoryList);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
