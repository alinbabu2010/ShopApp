import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/utils/constants.dart';

import '../providers/auth.dart';
import 'drawer_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            AppBar(
              title: const Text(drawerTitle),
              automaticallyImplyLeading: false,
            ),
            const DrawerItem(
              Icons.shop,
              shop,
              ProductsOverview.routeName,
            ),
            const DrawerItem(
              Icons.payment,
              orders,
              OrdersScreen.routeName,
            ),
            const DrawerItem(
              Icons.edit,
              yourProducts,
              UserProductsScreen.routeName,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(logout),
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
