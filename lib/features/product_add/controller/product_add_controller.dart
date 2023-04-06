import 'dart:io';

import 'package:ecommerce_seller_app/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uuid/uuid.dart';

import '../../../core/utils.dart';

import '../../../models/category_model.dart';

import '../../auth/controller/auth_controller.dart';
import '../repository/product_add_repository.dart';

//authControllerProvider
final productAddControllerProvider =
    StateNotifierProvider<ProductAddController, bool>(
  (ref) => ProductAddController(
    productAddRepository: ref.watch(productAddRepositoryProvider),
    ref: ref,
  ),
);

class ProductAddController extends StateNotifier<bool> {
  final ProductAddRepository _productAddRepository;
  final Ref _ref;
  ProductAddController(
      {required ProductAddRepository productAddRepository, required Ref ref})
      : _productAddRepository = productAddRepository,
        _ref = ref,
        super(false);

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
    required int? discount,
    required double? kg,
  }) async {
    state = true;
    final currentUser = _ref.read(userProvider);

    const uuid = Uuid();
    String productId = productID.isNotEmpty ? productID : uuid.v1();

    final user = await _productAddRepository.saveProductInFirebase(
      ref: _ref,
      productImages: productImages,
      productImageUrls: productImageUrls,
      productID: productId,
      productName: productName,
      productDescription: productDescription,
      category: category,
      sellerUserId: currentUser!.uid,
      productPrice: productPrice,
      quantity: quantity,
      kg: kg,
      discount: discount,
    );
    state = false;
    user.fold((l) => showSnackBar(context: context, text: l.message),
        (isComplete) {
      showSnackBar(context: context, text: "Product is saved");
      Navigator.pop(context);
    });
  }

  //get category list
  Future<bool> getCategoryData(BuildContext context) async {
    return await _productAddRepository.getCategoryData(
        ref: _ref, context: context);
  }

  //Delete a product
  Future<void> deleteAProduct(
      {required BuildContext context, required String productID}) async {
    state = true;
    final res = await _productAddRepository.deleteAProduct(productID);
    state = false;
    res.fold((l) => showSnackBar(context: context, text: l.message), (r) {
      showSnackBar(context: context, text: "Product is deleted");
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    });
  }
}
