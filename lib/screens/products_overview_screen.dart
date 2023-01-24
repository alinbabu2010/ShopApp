import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/empty_msg.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverview extends StatefulWidget {
  static const routeName = "/products_overview_screen";

  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;

  late Future _productsFuture;

  Future<void> _obtainProductsFuture() {
    return Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts().catchError((error) => Future.error(error));
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MyShop"),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text(onlyFavorites),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text(showAll),
                ),
              ],
              icon: const Icon(Icons.more_vert),
              onSelected: (selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
            ),
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                value: cart.itemCount.toString(),
                child: child as Widget,
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            )
          ],
        ),
        body: FutureBuilder(
            future: _productsFuture,
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.hasError) {
                  return EmptyMsgWidget(message: dataSnapshot.error.toString());
                } else {
                  return RefreshIndicator(
                    onRefresh: _obtainProductsFuture,
                    child: ProductsGrid(showFavorites: _showOnlyFavorites),
                  );
                }
              }
            }),
        drawer: const AppDrawer());
  }
}
