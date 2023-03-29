import 'dart:io';

import 'package:ecommerce_seller_app/features/auth/screens/login_information_screen.dart';
import 'package:ecommerce_seller_app/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';

import '../../../home/screens/home_screen.dart';
import '../../../models/seller_user_model.dart';
import '../repository/auth_repository.dart';
import '../screens/otp_screen.dart';

//loading notifier
final userProvider = StateProvider<SellerUserModel?>((ref) => null);

//authControllerProvider
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider(
  ((ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
  }),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

//check UserStateChanges
  Stream<User?> get authStateChange => _authRepository.authStateChange;

//Phone sign-in
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    state = true;
    final user = await _authRepository.signInWithPhone(phoneNumber);
    state = false;
    user.fold((l) => showSnackBar(context: context, text: l.message),
        (response) {
      print("response: $response");
      if (response == "verificationCompleted") {
        showSnackBar(context: context, text: 'Verification Completed');
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OTPScreen(verificationId: response!)));
      }
    });
  }

//verifyOTP
  void verifyOTP(
      BuildContext context, String verificationId, String userOTP) async {
    state = true;
    final user = await _authRepository.verifyOTP(
        verificationId: verificationId, userOTP: userOTP);
    state = false;
    user.fold((l) => showSnackBar(context: context, text: l.message),
        (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginInformationScreen()),
          (route) => false);
    });
  }

//save user data in the firebase
  void saveSellerUserDataToFirebase({
    required String name,
    required File? profilePic,
    required BuildContext context,
  }) async {
    state = true;
    final user = await _authRepository.saveSellerUserDataInToFirebase(
        name: name, profilePic: profilePic, ref: _ref);
    state = false;
    user.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    });
  }

//get current user data
  Future<SellerUserModel?> getUserData(String uid, BuildContext context) async {
    SellerUserModel? user;
    final userData = await _authRepository.getUserData(uid);
    userData.fold(
      (l) => showSnackBar(context: context, text: l.message),
      (userModel) {
        user = userModel;
      },
    );
    return user;
  }

  //sign-Out
  Future<void> signOut(BuildContext context) async {
    state = true;
    final user = await _authRepository.signOut();
    state = false;
    user.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (isSignOut) {
      _ref.read(userProvider.notifier).update((state) => null);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    });
  }
}
