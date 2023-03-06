import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({Key? key}) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void _showSnackBar(ScaffoldMessengerState scaffold, String message) {
    _setLoader(false);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _setLoader(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _saveOrder(Cart cart, ScaffoldMessengerState scaffold) async {
    if (cart.itemCount > 0) {
      try {
        _setLoader(true);
        var message = await Provider.of<Orders>(
          context,
          listen: false,
        ).addOrder(
          cart.items.values.toList(),
          cart.totalAmount,
        );
        cart.clearItems();
        _showSnackBar(scaffold, message);
      } catch (error) {
        _showSnackBar(scaffold, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final scaffold = ScaffoldMessenger.of(context);
    final appLocalization = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: cart.itemCount == 0 ? null : () => _saveOrder(cart, scaffold),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 1),
            )
          : Text(appLocalization.orderNow),
    );
  }
}
