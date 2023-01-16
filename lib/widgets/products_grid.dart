import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/utils/typography.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../providers/product.dart';
import '../utils/dimens.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid({Key? key, required this.showFavorites}) : super(key: key);

  Widget buildEmptyMessageWidget() {
    return const Center(
      child: Text(
        emptyFavMsg,
        style: emptyMsgTextStyle,
      ),
    );
  }

  Widget buildGridView(
    BuildContext context,
    List<Product> products,
  ) {
    return GridView.builder(
      gridDelegate: productOverviewGridDelegate,
      padding: productOverviewGridPadding,
      itemBuilder: (context, index) {
        // Use ChangeNotifierProvider.value for lists and grids
        return ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return products.isEmpty
        ? buildEmptyMessageWidget()
        : buildGridView(context, products);
  }
}
