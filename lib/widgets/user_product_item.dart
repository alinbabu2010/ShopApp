import 'package:flutter/material.dart';
import 'package:shop_app/utils/dimens.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem(
    this.title,
    this.imageUrl, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              icon: const Icon(Icons.edit),
              color: theme.colorScheme.secondary,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: theme.errorColor,
            )
          ],
        ),
      ),
    );
  }
}
