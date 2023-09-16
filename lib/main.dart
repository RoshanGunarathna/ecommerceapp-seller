import 'package:device_preview/device_preview.dart';
import 'package:ecommerce_seller_app/core/palette.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/screens/splash_screen.dart';

import 'features/auth/screens/test.dart';
import 'firebase_options.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ProviderScope(
        // observers: [
        //   LoggerRiverpod(),
        // ],
        child: MyApp(),
      ), // Wrap your app
    ),
    // ProviderScope(
    //   // observers: [
    //   //   LoggerRiverpod(),
    //   // ],
    //   child: MyApp(),
    // ), // Wrap your app
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
          ),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: primaryColor),
      ),
      debugShowCheckedModeBanner: false,
      home: const SafeArea(
        child: SplashScreen(),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
