import 'package:flutter/material.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/utils/constants.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.indigo,
            secondary: Colors.deepOrange,
          ),
          fontFamily: latoFont),
      home: ProductsOverview(),
      debugShowCheckedModeBanner: false,
    );
  }
}
