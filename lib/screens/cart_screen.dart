import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/utils/typography.dart';
import 'package:shop_app/widgets/order_button.dart';

import '../utils/dimens.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalization.yourCart),
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
                  Text(
                    appLocalization.total,
                    style: cardScreenTotalTextStyle,
                  ),
                  const Spacer(),
                  const SizedBox(width: cartScreenSpaceWidth),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const OrderButton()
                ],
              ),
            ),
          ),
          const SizedBox(height: cartScreenSpaceHeight),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                var cartItem = cart.items.values.toList()[index];
                var productId = cart.items.keys.toList()[index];
                return CartItem(
                  cartItem.id,
                  productId,
                  cartItem.price,
                  cartItem.quantity,
                  cartItem.title,
                );
              },
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
