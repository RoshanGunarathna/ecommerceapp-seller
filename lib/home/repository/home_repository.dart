import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_constants.dart';

import '../../../core/providers/firebase_providers.dart';

import '../../models/product.dart';

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

  //make a future function to get all the product collection from the firebase and make return them as a List<ProductModel>
  Future<List<ProductModel>> getProductDataFuture() async {
    final QuerySnapshot querySnapshot = await _products.get();

    for (var doc in querySnapshot.docs) {
      // ProductModel? productModel;
      // final querySnapshott =
      //     await _products.where('id', isNotEqualTo: [doc.id]).get();
      // print("querySnapshot: ${querySnapshot}");

      // for (var element in querySnapshott.docs) {
      //   final docRef = _products.doc(element.id);
      //   await docRef.delete();
      // }
    }

    return querySnapshot.docs.map((productData) {
      final product = productData.data();
      return ProductModel.fromMap(product as Map<String, dynamic>);
    }).toList();
  }

  //make a future function to save List<ProductModel> in the same collection of firebase
  Future<void> saveProductData(List<ProductModel> products) async {
    for (ProductModel product in products) {
      await _products.doc(product.id).set(ProductModel.toMap(product));
    }
  }

  //make a function to trigger first function and after its return data to pass back to the firebase collection
  Future<void> getAndSaveProductData() async {
    List<ProductModel> products = await getProductDataFuture();
    await saveProductData(products);
  }
}
