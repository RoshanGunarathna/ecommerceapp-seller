import 'package:ecommerce_seller_app/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/constants/assets_path.dart';
import '../../home/screens/home_screen.dart';
import '../../../models/seller_user_model.dart';
import '../controller/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenConsumerState();
}

class _SplashScreenConsumerState extends ConsumerState<SplashScreen> {
  //SellerUserModel? userModel;

  Stream<SellerUserModel?> getData(WidgetRef ref, User data) async* {
    // await Future.delayed(
    //   Duration(seconds: 3),
    // );
    final user = ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid, context);

    yield* user.asStream();
  }

  // void getData(WidgetRef ref, User data) async {
  //   userModel =
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              return StreamBuilder(
                stream: getData(ref, data),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(logoPath),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(logoPath),
                        ),
                      ),
                    );
                  } else if (snapshot.data != null) {
                    return const HomeScreen();
                  } else {
                    return const LoginScreen();
                  }
                },
              );
            }
            return const LoginScreen();
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(logoPath),
                ),
              ),
            );
          },
        );
  }
}
