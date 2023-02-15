import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';
import 'custom_page_transition_builder.dart';

class NavManager {
  NavManager? _navManager;

  NavManager();

  NavManager.getInstance() {
    _navManager ??= NavManager();
  }

  Map<String, Widget Function(BuildContext)> getRoutes() => {
        ProductsOverview.routeName: (context) => const ProductsOverview(),
        CartScreen.routeName: (context) => const CartScreen(),
        OrdersScreen.routeName: (context) => const OrdersScreen(),
        EditProductScreen.routeName: (context) => const EditProductScreen(),
        ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
        UserProductsScreen.routeName: (context) => const UserProductsScreen(),
      };

  Widget getHomeRoute(Auth auth) {
    if (auth.isAuth) {
      FlutterNativeSplash.remove();
      return const ProductsOverview();
    } else {
      return FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              FlutterNativeSplash.remove();
              return const AuthScreen();
            }
            return const SizedBox();
          });
    }
  }

  PageTransitionsTheme getPageTransitionsTheme() {
    return PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    );
  }
}
