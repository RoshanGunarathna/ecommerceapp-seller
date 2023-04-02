import 'package:ecommerce_seller_app/core/palette.dart';
import 'package:ecommerce_seller_app/models/category_model.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

void showMaterialDialog({
  required BuildContext context,
  required List<CategoryModel> categoryList,
  required List<CategoryModel> selectedCategory,
  required OnApplyButtonClick<CategoryModel> onApplyButtonClick,
  required LabelDelegate<CategoryModel> choiceChipLabel,
  required ValidateSelectedItem<CategoryModel> validateSelectedItem,
  required SearchPredict<CategoryModel> onItemSearch,
}) {
  EdgeInsets? insetPadding =
      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0);
  final height = MediaQuery.of(context).size.height * .5;
  final width = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: insetPadding,
        child: Container(
          height: height,
          width: width,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: FilterListWidget<CategoryModel>(
              listData: categoryList,
              selectedListData: selectedCategory,
              onApplyButtonClick: onApplyButtonClick,
              choiceChipLabel: choiceChipLabel,
              validateSelectedItem: validateSelectedItem,
              onItemSearch: onItemSearch,
              themeData: FilterListThemeData(
                context,
                choiceChipTheme: const ChoiceChipThemeData(
                    selectedBackgroundColor: primaryColor),
                controlButtonBarTheme: ControlButtonBarThemeData(
                  context,
                  controlButtonTheme: const ControlButtonThemeData(
                      primaryButtonTextStyle:
                          TextStyle(fontSize: 16, color: whiteColor),
                      textStyle: TextStyle(fontSize: 16, color: primaryColor),
                      primaryButtonBackgroundColor: primaryColor),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
