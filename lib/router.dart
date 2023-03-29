import 'package:ecommerce_seller_app/features/product_add/screens/product_add_edit_screen.dart';
import 'package:ecommerce_seller_app/models/product.dart';
import 'package:flutter/material.dart';

import 'core/common/error_text.dart';
import 'home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomeScreen(),
      );
    case ProductAddEditScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => ProductAddEditScreen(
            product: (routeSettings.arguments as ProductModel?)),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorText(
            error: 'This page doesn\'t exit',
          ),
        ),
      );
  }
}
