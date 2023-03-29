import 'dart:io';

import 'package:ecommerce_seller_app/features/auth/screens/login_information_screen.dart';
import 'package:ecommerce_seller_app/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils.dart';

import '../../../home/screens/home_screen.dart';
import '../../../models/category_model.dart';
import '../../../models/seller_user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/product_add_repository.dart';

//authControllerProvider
final productAddControllerProvider =
    StateNotifierProvider<ProductAddController, bool>(
  (ref) => ProductAddController(
    authRepository: ref.watch(productAddRepositoryProvider),
    ref: ref,
  ),
);

final getProductDataProvider = StreamProvider<List<ProductModel>>((ref) {
  final productAddController = ref.watch(productAddControllerProvider.notifier);
  return productAddController.getProductData();
});

class ProductAddController extends StateNotifier<bool> {
  final ProductAddRepository _authRepository;
  final Ref _ref;
  ProductAddController(
      {required ProductAddRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  //get current product data
  Stream<List<ProductModel>> getProductData() {
    return _authRepository.getProductData();
  }

  //save user data in the firebase
  void saveProductDataInFirebase({
    required List<CategoryModel> category,
    required List<File> productImages,
    required List<String> productImageUrls,
    required String productName,
    required String productDescription,
    required double productPrice,
    required int quantity,
    required BuildContext context,
    required String productID,
  }) async {
    state = true;
    final currentUser = _ref.read(userProvider);
    final categories = category.map((e) => e.categoryName).toList();
    const uuid = Uuid();
    String productId = productID.isNotEmpty ? productID : uuid.v1();

    final user = await _authRepository.saveProductInFirebase(
        ref: _ref,
        productImages: productImages,
        productImageUrls: productImageUrls,
        productID: productId,
        productName: productName,
        productDescription: productDescription,
        category: categories,
        sellerUserId: currentUser!.uid,
        productPrice: productPrice,
        quantity: quantity);
    state = false;
    user.fold((l) => showSnackBar(context: context, text: l.message),
        (isComplete) {
      showSnackBar(context: context, text: "Product is saved");
      Navigator.pop(context);
    });
  }
}
