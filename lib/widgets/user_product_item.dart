import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utils/dimens.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String title;
  final String imageUrl;

  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: trailingSizedBoxWidth,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              ),
              icon: const Icon(Icons.edit),
              color: theme.colorScheme.secondary,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
            )
          ],
        ),
      ),
    );
  }
}
