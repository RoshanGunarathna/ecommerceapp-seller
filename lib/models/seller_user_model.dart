// ignore_for_file: public_member_api_docs, sort_constructors_first
class SellerUserModel {
  final String name;
  final String uid;
  final String profilePic;
  final String phoneNumber;
  final DateTime? dateTime;

  SellerUserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.phoneNumber,
    this.dateTime,
  });

  static Map<String, dynamic> toMap(
      {required SellerUserModel sellerUserModel,
      required List<String> searchKeyword}) {
    return <String, dynamic>{
      'name': sellerUserModel.name,
      'uid': sellerUserModel.uid,
      'profilePic': sellerUserModel.profilePic,
      'phoneNumber': sellerUserModel.phoneNumber,
      'dateTime': sellerUserModel.dateTime.toString(),
      'searchKeyword': searchKeyword,
    };
  }

  static SellerUserModel fromMap(Map<String, dynamic> map) {
    return SellerUserModel(
        name: map['name'] as String,
        uid: map['uid'] as String,
        profilePic: map['profilePic'] as String,
        phoneNumber: map['phoneNumber'] as String,
        dateTime:
            map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null);
  }

  SellerUserModel copyWith({
    String? name,
    String? uid,
    String? profilePic,
    String? phoneNumber,
    DateTime? dateTime,
  }) {
    return SellerUserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
