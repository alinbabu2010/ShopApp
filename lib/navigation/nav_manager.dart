import 'package:flutter/material.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/splash_screen.dart';
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
    return auth.isAuth
        ? const ProductsOverview()
        : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const AuthScreen(),
          );
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
