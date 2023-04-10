// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String name;

  final String address;
  final String email;
  final String photoUrl;
  final List<dynamic> cart;
  final DateTime? dateTime;
  UserModel({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.photoUrl,
    required this.cart,
    this.dateTime,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? address,
    String? email,
    String? photoUrl,
    List<dynamic>? cart,
    DateTime? dateTime,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      cart: cart ?? this.cart,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  static Map<String, dynamic> toMap({
    required UserModel userModel,
    required List<String> searchKeyword,
  }) {
    return <String, dynamic>{
      'email': userModel.email,
      'name': userModel.name,
      'id': userModel.id,
      'photoUrl': userModel.photoUrl,
      'address': userModel.address,
      'cart': userModel.cart,
      'searchKeyword': searchKeyword,
      'dateTime': userModel.dateTime.toString(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        id: map['id'] ?? '',
        photoUrl: map['photoUrl'] ?? '',
        address: map['address'] ?? '',
        cart: map['cart'] ?? [],
        dateTime:
            map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null);
  }

  // @override
  // String toString() {
  //   return 'emailUser(email: $email, displayName: $displayName, phoneNumber: $phoneNumber, photoUrl: $photoUrl, uid: $uid)';
  // }

  // @override
  // bool operator ==(covariant UserModel other) {
  //   if (identical(this, other)) return true;

  //   return other.email == email &&
  //       other.displayName == displayName &&
  //       other.phoneNumber == phoneNumber &&
  //       other.photoUrl == photoUrl &&
  //       other.uid == uid;
  // }

  // @override
  // int get hashCode {
  //   return email.hashCode ^
  //       displayName.hashCode ^
  //       phoneNumber.hashCode ^
  //       photoUrl.hashCode ^
  //       uid.hashCode;
  // }
}





    // print(userCredential.user!.email);
    //   print(userCredential.user!.displayName);
    //   print(userCredential.user!.phoneNumber);
    //   print(userCredential.user!.photoURL);
    //   print(userCredential.user!.uid);