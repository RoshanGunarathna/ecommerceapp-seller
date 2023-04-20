// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryModel {
  final String name;
  final String id;
  final DateTime? dateTime;

  CategoryModel({
    required this.name,
    required this.id,
    this.dateTime,
  });

  static Map<String, dynamic> toMap({
    required CategoryModel categoryModel,
    required List<String> searchKeyword,
  }) {
    return <String, dynamic>{
      'name': categoryModel.name,
      'id': categoryModel.id,
      'dateTime': categoryModel.dateTime.toString(),
      'searchKeyword': searchKeyword,
    };
  }

  static CategoryModel fromMap(Map<String, dynamic> map) {
    final red = map['dateTime'];
    print("dateTime IN category Model From Map: ${red}");
    return CategoryModel(
        name: map['name'] as String,
        id: map['id'] as String,
        dateTime:
            map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null);
  }

  CategoryModel copyWith({
    String? name,
    String? id,
    DateTime? dateTime,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
