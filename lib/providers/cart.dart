import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String?, CartItem> _items = {};

  Map<String?, CartItem> get items {
    return {..._items};
  }

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += (cartItem.price * cartItem.quantity);
    });
    return total;
  }

  void _updateItem(String? productId, bool isAdded) {
    _items.update(
        productId,
        (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: isAdded
                  ? existingCartItem.quantity + 1
                  : existingCartItem.quantity - 1,
              price: existingCartItem.price,
            ));
  }

  void addItem(
    String? productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _updateItem(productId, true);
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeSingleItem(String? productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if ((_items[productId]?.quantity ?? 0) > 1) {
      _updateItem(productId, false);
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String? productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }
}
