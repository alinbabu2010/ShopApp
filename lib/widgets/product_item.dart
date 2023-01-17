import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/utils/constants.dart';

import '../providers/cart.dart';
import '../utils/dimens.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  void setupSnackBar(BuildContext context, Cart cart, Product product) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(cartAddedMsg),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: undo,
          onPressed: () => cart.removeSingleItem(product.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
        ),
        borderRadius: productItemContainerRadius,
      ),
      child: ClipRRect(
        borderRadius: productItemClipRadius,
        clipBehavior: Clip.hardEdge,
        child: Consumer<Product>(
          builder: (context, product, child) => GridTile(
            footer: GridTileBar(
              leading: IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () => product.toggleFavorite(),
                color: theme.colorScheme.secondary,
              ),
              backgroundColor: Colors.black87,
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(
                    product.id,
                    product.price,
                    product.title,
                  );
                  setupSnackBar(context, cart, product);
                },
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id),
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
