import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/utils/constants.dart';
import 'package:shop_app/utils/typography.dart';

import '../utils/dimens.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(yourCart),
      ),
      body: Column(
        children: [
          Card(
            margin: cartScreenCardMargin,
            child: Padding(
              padding: cartScreenCardPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    total,
                    style: cardScreenTotalTextStyle,
                  ),
                  const Spacer(),
                  const SizedBox(width: cartScreenSpaceWidth),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(orderNow),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
