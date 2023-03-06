import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import '../providers/auth.dart';
import 'drawer_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Drawer(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            AppBar(
              title: Text(appLocalization.drawerTitle),
              automaticallyImplyLeading: false,
            ),
            DrawerItem(
              Icons.shop,
              appLocalization.shop,
              ProductsOverview.routeName,
            ),
            DrawerItem(
              Icons.payment,
              appLocalization.orders,
              OrdersScreen.routeName,
            ),
            DrawerItem(
              Icons.edit,
              appLocalization.yourProducts,
              UserProductsScreen.routeName,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(appLocalization.logout),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacementNamed("/");
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
