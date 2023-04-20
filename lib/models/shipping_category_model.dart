// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShippingCategoryModel {
  final String name;
  final String id;
  final double price;
  final DateTime? dateTime;

  ShippingCategoryModel({
    required this.name,
    required this.id,
    this.dateTime,
    required this.price,
  });

  static Map<String, dynamic> toMap({
    required ShippingCategoryModel shippingCategoryModel,
  }) {
    return <String, dynamic>{
      'name': shippingCategoryModel.name,
      'id': shippingCategoryModel.id,
      'dateTime': shippingCategoryModel.dateTime.toString(),
      'price': shippingCategoryModel.price.toString(),
    };
  }

  static ShippingCategoryModel fromMap(Map<String, dynamic> map) {
    return ShippingCategoryModel(
        price: double.parse(map['price']),
        name: map['name'] as String,
        id: map['id'] as String,
        dateTime:
            map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null);
  }
}
