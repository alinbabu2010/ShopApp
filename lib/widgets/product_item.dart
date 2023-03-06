import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/data/models/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../utils/dimens.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {Key? key}) : super(key: key);

  void setupSnackBar(BuildContext context, Cart cart, Product product) {
    final appLocalizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appLocalizations.cartAddedMsg),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: appLocalizations.undo,
          onPressed: () => cart.removeSingleItem(product.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final productData = Provider.of<Products>(context);
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
        child: GridTile(
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                productData.toggleFavorite(product.id);
              },
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
            child: Hero(
              tag: product.id as Object,
              child: FadeInImage(
                  placeholder:
                      const AssetImage("assets/images/product-placeholder.png"),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
