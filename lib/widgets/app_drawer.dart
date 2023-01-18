import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget buildDrawerItems(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(route);
          },
        ),
      ],
    );
  }

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
            buildDrawerItems(
              context,
              Icons.shop,
              shop,
              ProductsOverview.routeName,
            ),
            buildDrawerItems(
              context,
              Icons.payment,
              orders,
              OrdersScreen.routeName,
            ),
            buildDrawerItems(
              context,
              Icons.edit,
              yourProducts,
              UserProductsScreen.routeName,
            )
          ],
        ),
      ),
    );
  }
}
