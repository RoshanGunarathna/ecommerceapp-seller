import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';

import '../../../models/category_model.dart';
import '../repositories/common_get_category_repository.dart';

//get category list
final categoryProvider = StateProvider<List<CategoryModel>?>((ref) => null);

//authControllerProvider
final commonGetCategoryControllerProvider =
    StateNotifierProvider<CommonGetCategoryController, bool>(
  (ref) => CommonGetCategoryController(
    authRepository: ref.watch(commonGetCategoryRepositoryProvider),
    ref: ref,
  ),
);

class CommonGetCategoryController extends StateNotifier<bool> {
  final CommonGetCategoryRepository _commonGetCategoryRepository;
  final Ref _ref;
  CommonGetCategoryController(
      {required CommonGetCategoryRepository authRepository, required Ref ref})
      : _commonGetCategoryRepository = authRepository,
        _ref = ref,
        super(false);

  //get category list
  Future<bool> getCategoryData(BuildContext context) async {
    bool? returnValue;
    state = true;
    final res = await _commonGetCategoryRepository.getCategoryData();
    state = false;
    res.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (categoryList) {
      final isOver =
          _ref.read(categoryProvider.notifier).update((state) => categoryList);
      if (isOver != null) returnValue = true;
    });
    return returnValue ?? false;
  }
}
