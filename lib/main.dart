import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/utils/constants.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, prevProducts) =>
              Products(auth.token, prevProducts?.items ?? []),
          create: (context) {
            final authProvider = Provider.of<Auth>(context, listen: false);
            return Products(authProvider.token, []);
          },
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, prevOrders) =>
              Orders(auth.token, prevOrders?.orders ?? []),
          create: (context) {
            final authProvider = Provider.of<Auth>(context, listen: false);
            return Orders(authProvider.token, []);
          },
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: appName,
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.indigo,
                secondary: Colors.deepOrange,
              ),
              fontFamily: latoFont),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth ? const ProductsOverview() : const AuthScreen(),
          routes: {
            ProductsOverview.routeName: (context) => const ProductsOverview(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
          },
        ),
      ),
    );
  }
}
