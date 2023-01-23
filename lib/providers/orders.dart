import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';
import 'package:shop_app/network/network_manager.dart';

import '../utils/constants.dart' as constants;

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  final networkManager = NetworkManager.newInstance();

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    return networkManager.fetchOrders().then((orders) {
      _orders.clear();
      _orders.addAll(orders);
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
    var savedOrder = await networkManager.addOrders(orderItem);
    _orders.insert(0, savedOrder);
    notifyListeners();
    return constants.orderSuccessMsg;
  }
}
