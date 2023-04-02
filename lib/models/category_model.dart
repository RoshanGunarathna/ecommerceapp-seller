// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryModel {
  final String name;
  final String id;

  CategoryModel({
    required this.name,
    required this.id,
  });

  static Map<String, dynamic> toMap(CategoryModel categoryModel) {
    return <String, dynamic>{
      'name': categoryModel.name,
      'id': categoryModel.id,
    };
  }

  static CategoryModel fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }
}
