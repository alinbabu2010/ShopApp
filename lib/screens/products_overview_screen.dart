import 'package:flutter/material.dart';
import 'package:shop_app/utils/constants.dart';

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
          )
        ],
      ),
      body: ProductsGrid(showFavorites: _showOnlyFavorites),
    );
  }
}
