import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/utils/constants.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.indigo,
              secondary: Colors.deepOrange,
            ),
            fontFamily: latoFont),
        debugShowCheckedModeBanner: false,
        routes: {
          ProductsOverview.routeName: (context) => ProductsOverview(),
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
        },
      ),
    );
  }
}
