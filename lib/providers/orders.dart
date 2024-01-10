import 'package:flutter/cupertino.dart';
import 'package:shop_app/data/models/cart_item.dart';
import 'package:shop_app/data/models/order_item.dart';

import '../data/repository/shop_repository.dart';
import '../utils/constants.dart' as constants;

class Orders with ChangeNotifier {
  final String? authToken;
  final String? userId;
  final List<OrderItem> _orders;

  Orders(this.authToken, this.userId, this._orders) {
    shopRepository.setCredentials(authToken, userId);
  }

  final shopRepository = ShopRepository.instance();

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    return shopRepository.fetchOrders().then((orders) {
      _orders.clear();
      _orders.addAll(orders.reversed);
      notifyListeners();
    });
  }

  Future<String> addOrder(List<CartItem> cartProducts, double total) async {
    final orderItem = OrderItem(
      null,
      total,
      cartProducts,
      DateTime.now(),
    );
    var savedOrder = await shopRepository.addOrders(orderItem);
    _orders.insert(0, savedOrder);
    notifyListeners();
    return constants.orderSuccessMsg;
  }
}
