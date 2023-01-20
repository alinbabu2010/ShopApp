import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';
import 'package:shop_app/network/network_manager.dart';

import '../models/http_exception.dart';

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    return NetworkManager.fetchOrders().then((orders) {
      _orders.clear();
      _orders.addAll(orders);
      notifyListeners();
    });
  }

  Future<String> addOrder(List<CartItem> cartProducts, double total) async {
    var orderItem = OrderItem(
      null,
      total,
      cartProducts,
      DateTime.now(),
    );
    var response = await NetworkManager.addOrders(orderItem);
    if (response.statusCode >= 400) {
      throw HttpException("Could not place your order. Try again!");
    } else {
      orderItem.id = jsonDecode(response.body)['name'];
      _orders.insert(0, orderItem);
      notifyListeners();
      return "Your order successfully placed";
    }
  }
}
