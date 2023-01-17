import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/utils/dimens.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: cartItemDismissContainerPadding,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: cartItemDismissIconSize,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: cartItemCardMargin,
        child: Padding(
          padding: cartItemCardChildPadding,
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: cartItemCircleTextPadding,
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              "Total : \$${(price * quantity).toStringAsFixed(2)}",
            ),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
