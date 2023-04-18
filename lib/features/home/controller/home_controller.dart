import 'dart:io';

import 'package:ecommerce_seller_app/models/category_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/seller_user_model.dart';
import '../../../models/product.dart';
import '../repository/home_repository.dart';

//get user
final userProvider = StateProvider<SellerUserModel?>((ref) => null);

//homeControllerProvider
final homeControllerProvider = StateNotifierProvider<HomeController, bool>(
  (ref) => HomeController(
    homeRepository: ref.watch(homeRepositoryProvider),
    ref: ref,
  ),
);

class HomeController extends StateNotifier<bool> {
  final HomeRepository _homeRepository;
  final Ref _ref;
  HomeController({required HomeRepository homeRepository, required Ref ref})
      : _homeRepository = homeRepository,
        _ref = ref,
        super(false);

//check UserStateChanges
  Stream<List<ProductModel>> get getProductData =>
      _homeRepository.getProductData();

  //dev codes ....................................................
  Future<void> getAndSaveProductData(BuildContext context) async {
    await _homeRepository.getAndSaveProductData(_ref, context);
  }
}
