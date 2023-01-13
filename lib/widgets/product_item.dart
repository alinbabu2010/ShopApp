import 'package:flutter/material.dart';

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
    return GridTile(
      footer: GridTileBar(
        leading: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {},
          color: Theme.of(context).colorScheme.secondary,
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
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
