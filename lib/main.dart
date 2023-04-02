import 'package:ecommerce_seller_app/core/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/screens/splash_screen.dart';

import 'firebase_options.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
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
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: primaryColor)),
      debugShowCheckedModeBanner: false,
      home: const SafeArea(
        child: SplashScreen(),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
