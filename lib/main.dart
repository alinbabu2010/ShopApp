import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/navigation/nav_manager.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navManager = NavManager.getInstance();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, prevProducts) =>
              Products(auth.token, auth.userId, prevProducts?.items ?? []),
          create: (context) {
            final authProvider = Provider.of<Auth>(context, listen: false);
            return Products(authProvider.token, authProvider.userId, []);
          },
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, prevOrders) =>
              Orders(auth.token, auth.userId, prevOrders?.orders ?? []),
          create: (context) {
            final authProvider = Provider.of<Auth>(context, listen: false);
            return Orders(authProvider.token, authProvider.userId, []);
          },
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.indigo,
              secondary: Colors.deepOrange,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Colors.white,
              shape: LinearBorder.none,
            ),
            fontFamily: latoFont,
            pageTransitionsTheme: navManager.getPageTransitionsTheme(),
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: navManager.getHomeRoute(auth),
          routes: navManager.getRoutes(),
        ),
      ),
    );
  }
}
