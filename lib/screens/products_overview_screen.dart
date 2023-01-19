import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverview extends StatefulWidget {
  static const routeName = "/";

  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  Future<void> _fetchProducts() async {
    Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts();
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchProducts,
                child: ProductsGrid(showFavorites: _showOnlyFavorites),
              ),
        drawer: const AppDrawer());
  }
}
