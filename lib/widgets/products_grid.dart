import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../data/models/product.dart';
import '../utils/dimens.dart';
import 'empty_msg.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid({Key? key, required this.showFavorites}) : super(key: key);

  Widget buildGridView(
    BuildContext context,
    List<Product> products,
  ) {
    return GridView.builder(
      gridDelegate: productOverviewGridDelegate,
      padding: productOverviewGridPadding,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(product);
      },
      itemCount: products.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return products.isEmpty
        ? EmptyMsgWidget(
            message: showFavorites
                ? appLocalizations.emptyFavMsg
                : appLocalizations.emptyProductMsg)
        : buildGridView(context, products);
  }
}
