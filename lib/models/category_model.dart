import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryModel {
  final String categoryName;
  final bool isCategoryMarked;
  final int categoryId;
  CategoryModel({
    required this.categoryName,
    required this.isCategoryMarked,
    required this.categoryId,
  });

  static Map<String, dynamic> toMap(CategoryModel categoryModel) {
    return <String, dynamic>{
      'categoryName': categoryModel.categoryName,
      'categoryId': categoryModel.categoryId,
      'isCategoryMarked': categoryModel.isCategoryMarked,
    };
  }

  static CategoryModel fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'] as String,
      categoryId: map['categoryId'] as int,
      isCategoryMarked: map['isCategoryMarked'] as bool,
    );
  }

  static List<Map<String, dynamic>> toMapList(
      List<CategoryModel> categoryList) {
    List<Map<String, dynamic>> categoryListMap =
        categoryList.map((e) => CategoryModel.toMap(e)).toList();

    return categoryListMap;
  }
}
