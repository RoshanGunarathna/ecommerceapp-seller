import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';

import '../../../models/category_model.dart';

import '../repositories/common_get_date_and_time_repository.dart';

//getCategoryControllerProvider
final commonGetDateAndTimeControllerProvider =
    StateNotifierProvider<CommonGetDateAndTimeControllerProvider, bool>(
  (ref) => CommonGetDateAndTimeControllerProvider(
    commonGetDateAndTimeRepositoryProvider:
        ref.watch(commonGetDateAndTimeRepositoryProvider),
    ref: ref,
  ),
);

class CommonGetDateAndTimeControllerProvider extends StateNotifier<bool> {
  final CommonGetDateAndTimeRepository _commonGetDateAndTimeRepositoryProvider;
  final Ref _ref;
  CommonGetDateAndTimeControllerProvider(
      {required CommonGetDateAndTimeRepository
          commonGetDateAndTimeRepositoryProvider,
      required Ref ref})
      : _commonGetDateAndTimeRepositoryProvider =
            commonGetDateAndTimeRepositoryProvider,
        _ref = ref,
        super(false);

  //get date and time
  Future<String?> getDateAndTime(BuildContext context) async {
    state = true;
    final res = await _commonGetDateAndTimeRepositoryProvider.getDateAndTime();
    state = false;
    final returnValue = res.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (dateAndTime) {
      return dateAndTime;
    });
    return returnValue;
  }
}
