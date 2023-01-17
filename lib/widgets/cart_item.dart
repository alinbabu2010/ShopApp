import 'package:flutter/material.dart';
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
    return Card(
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
          subtitle: Text("Total : \$${price * quantity}"),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
