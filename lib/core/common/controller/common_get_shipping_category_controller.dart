import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';

import '../../../models/shipping_category_model.dart';
import '../repositories/common_get_shipping_category_repository.dart';

//ShippingCategoryControllerProvider
final commonGetShippingCategoryControllerProvider =
    StateNotifierProvider<CommonShippingCategoryController, bool>(
  (ref) => CommonShippingCategoryController(
    authRepository: ref.watch(commonGetShippingCategoryRepositoryProvider),
    ref: ref,
  ),
);

class CommonShippingCategoryController extends StateNotifier<bool> {
  final CommonGetShippingCategoryRepository _commonShippingCategoryRepository;
  final Ref _ref;
  CommonShippingCategoryController(
      {required CommonGetShippingCategoryRepository authRepository,
      required Ref ref})
      : _commonShippingCategoryRepository = authRepository,
        _ref = ref,
        super(false);

  //get shipping category list
  Future<List<ShippingCategoryModel>?> getShippingCategoryData(
      BuildContext context) async {
    List<ShippingCategoryModel>? returnValue;
    state = true;
    final res =
        await _commonShippingCategoryRepository.getShippingCategoryData();
    state = false;
    res.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (shippingCategoryList) {
      returnValue = shippingCategoryList;
    });
    return returnValue;
  }
}
