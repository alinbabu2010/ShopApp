import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../utils/dimens.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              icon: const Icon(Icons.favorite),
              onPressed: () {},
              color: theme.colorScheme.secondary,
            ),
            backgroundColor: Colors.black87,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: id),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
