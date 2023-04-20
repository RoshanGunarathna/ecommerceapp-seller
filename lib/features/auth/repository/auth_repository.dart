import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/common/controller/common_get_category_controller.dart';
import '../../../core/common/controller/common_get_date_and_time_controller.dart';
import '../../../core/common/repositories/common_firebase_storage_repository.dart';
import '../../../core/common/repositories/common_get_category_repository.dart';
import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';

import '../../../models/category_model.dart';
import '../../../models/seller_user_model.dart';
import '../controller/auth_controller.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    ref: ref,
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Ref _ref;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required Ref ref,
  })  : _auth = auth,
        _firestore = firestore,
        _ref = ref;

  CollectionReference get _sellerUsers =>
      _firestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

//Phone sign-in
  FutureEither<String?> signInWithPhone(String phoneNumber) async {
    var returnData;
    bool authFunctionIsFinished = false;

    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 50),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        await _auth.signInWithCredential(phoneAuthCredential);
        returnData = "verificationCompleted";
        authFunctionIsFinished = true;
      },
      verificationFailed: (error) => returnData = error,
      codeSent: ((verificationId, forceResendingToken) {
        returnData = verificationId;

        authFunctionIsFinished = true;
      }),
      codeAutoRetrievalTimeout: (verificationId) {},
    );

    while (!authFunctionIsFinished) {
      await Future.delayed(const Duration(seconds: 2));
    }

    if (returnData.runtimeType == String) {
      return right(returnData);
    } else {
      return left(Failure(returnData.toString()));
    }
  }

//verifyOTP
  FutureEither<SellerUserModel?> verifyOTP({
    required String verificationId,
    required String userOTP,
    required BuildContext context,
  }) async {
    var returnData;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);

      var userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        //get user id
        final uid = userCredential.user!.uid;

        //get the time&date in sri lanka
        // ignore: use_build_context_synchronously
        String? dateAndTime = await _ref
            .read(commonGetDateAndTimeControllerProvider.notifier)
            .getDateAndTime(context);

        if (userCredential.additionalUserInfo!.isNewUser) {
          SellerUserModel userModel = SellerUserModel(
            name: "",
            uid: uid,
            profilePic: Constants.avatarDefault,
            phoneNumber: userCredential.user!.phoneNumber ?? "",
            dateTime: dateAndTime != null
                ? DateTime.parse(dateAndTime)
                : DateTime.now(),
          );

          final IsUserExisting =
              await checkUserIsExisting(userCredential.user!.phoneNumber!);

          if (IsUserExisting != null) {
            userModel = IsUserExisting;
          }

          await _sellerUsers.doc(uid).set(SellerUserModel.toMap(
              sellerUserModel: userModel, searchKeyword: []));

          //get current user data and return userData to controller
          SellerUserModel? user;
          final userData = await getUserData(uid);

          userData.fold(
            (l) => throw l.message,
            (userModel) => user = userModel,
          );
          return right(user);
        } else {
          //get current user data and return userData to controller
          SellerUserModel? user;
          final userData = await getUserData(uid);

          userData.fold(
            (l) => throw l.message,
            (userModel) => user = userModel,
          );
          return right(user);
        }
      }
      throw "Phone sign-in fail";
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //check user Phone Number is already registered and if it's true then return that user info
  Future<SellerUserModel?> checkUserIsExisting(String phoneNumber) async {
    try {
      SellerUserModel? sellerUserModel;
      final querySnapshot = await _sellerUsers
          .where('phoneNumber', isEqualTo: [phoneNumber]).get();

      if (querySnapshot.docs.isNotEmpty) {
        sellerUserModel = querySnapshot.docs
            .map((sellerUser) => SellerUserModel.fromMap(
                sellerUser.data() as Map<String, dynamic>))
            .toList()[0];
        final docRef = _sellerUsers.doc(sellerUserModel.uid);
        await docRef.delete();
      }

      return sellerUserModel;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      Future.error(e.toString());
    }
  }

  //save user data in firebase
  FutureEither<SellerUserModel?> saveSellerUserDataInToFirebase({
    required String name,
    required File? profilePic,
    required Ref ref,
    required BuildContext context,
  }) async {
    var returnData;
    try {
      final uid = _auth.currentUser!.uid;
      final phoneNumber = _auth.currentUser!.phoneNumber;
      String photoUrl = ref.read(userProvider)!.profilePic;
      DateTime? dateTime = ref.read(userProvider)!.dateTime;
      if (profilePic != null) {
        final res = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storageFileToFirebase('sellerProfilePic/$uid', profilePic);
        res.fold((l) => throw l.toString(), (r) => photoUrl = r);
      }
      //get the time&date in sri lanka
      // ignore: use_build_context_synchronously
      String? dateAndTime;
      if (dateTime == null) {
        dateAndTime = await _ref
            .read(commonGetDateAndTimeControllerProvider.notifier)
            .getDateAndTime(context);
      }

      SellerUserModel userModel = SellerUserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        phoneNumber: phoneNumber ?? "",
        dateTime: dateTime ??
            (dateAndTime != null
                ? DateTime.parse(dateAndTime)
                : DateTime.now()),
      );

      //Generate search Keywords
      final List<String> searchKeyword = [];
      final splittedMultipleWords = userModel.name.trim().split(" ");
      for (var element in splittedMultipleWords) {
        final String wordToLowercase = element.toLowerCase();
        for (var i = 1; i < wordToLowercase.length + 1; i++) {
          searchKeyword.add(wordToLowercase.substring(0, i));
        }
      }

      await _sellerUsers.doc(uid).set(SellerUserModel.toMap(
          sellerUserModel: userModel, searchKeyword: searchKeyword));

      //get current user data and return userData to controller
      SellerUserModel? user;
      final userData = await getUserData(uid);

      userData.fold(
        (l) => throw l.message,
        (userModel) => user = userModel,
      );
      return right(user);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //get user data
  FutureEither<SellerUserModel> getUserData(String uid) async {
    try {
      SellerUserModel userData = await _sellerUsers.doc(uid).get().then(
          (value) =>
              SellerUserModel.fromMap(value.data() as Map<String, dynamic>));

      return right(userData);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //sign-Out
  FutureEither<bool> signOut() async {
    try {
      await _auth.signOut();
      return right(true);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //get category list
  Future<bool?> getCategoryData(
      {required Ref ref, required BuildContext context}) async {
    return await ref
        .read(commonGetCategoryControllerProvider.notifier)
        .getCategoryData(context);
  }
}
