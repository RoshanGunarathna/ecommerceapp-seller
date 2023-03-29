// ignore_for_file: public_member_api_docs, sort_constructors_first
class SellerUserModel {
  final String name;
  final String uid;
  final String profilePic;
  final String phoneNumber;

  SellerUserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.phoneNumber,
  });

  static Map<String, dynamic> toMap(
      {required SellerUserModel sellerUserModel}) {
    return <String, dynamic>{
      'name': sellerUserModel.name,
      'uid': sellerUserModel.uid,
      'profilePic': sellerUserModel.profilePic,
      'phoneNumber': sellerUserModel.phoneNumber,
    };
  }

  static SellerUserModel fromMap(Map<String, dynamic> map) {
    return SellerUserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }
}
