import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/utils/dimens.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/empty_msg.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverview extends StatefulWidget {
  static const routeName = "/products_overview_screen";

  const ProductsOverview({super.key});

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var _isRefresh = false;

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

  Future<void> _refreshProducts() async {
    final refreshFuture =
        _obtainProductsFuture().whenComplete(() => _isRefresh = false);
    _isRefresh = true;
    setState(() {
      _productsFuture = refreshFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(appLocalization.appName),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text(appLocalization.onlyFavorites),
                ),
                PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text(appLocalization.showAll),
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
              builder: (_, cart, child) => Container(
                margin: badgeTopMargin,
                child: Badge.count(
                  count: cart.itemCount,
                  alignment: AlignmentDirectional.topStart,
                  child: child as Widget,
                ),
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
              if (dataSnapshot.connectionState == ConnectionState.waiting &&
                  !_isRefresh) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: dataSnapshot.hasError
                      ? EmptyMsgWidget(message: dataSnapshot.error.toString())
                      : ProductsGrid(showFavorites: _showOnlyFavorites),
                );
              }
            }),
        drawer: const AppDrawer());
  }
}
