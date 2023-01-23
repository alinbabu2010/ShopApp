import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/order_item.dart';

class OrderItemParser {
  OrderItemParser? orderItemParser;

  OrderItemParser();

  OrderItemParser.newInstance() {
    orderItemParser ??= OrderItemParser();
  }

  List<OrderItem> parseOrderItem(Response response) {
    try {
      final extractedData =
          jsonDecode(response.body.toString()) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, data) {
        final orderItem = OrderItem.fromJson(data as Map<String, dynamic>);
        orderItem.id = orderId;
        loadedOrders.add(orderItem);
      });
      return loadedOrders;
    } catch (error) {
      return List.empty();
    }
  }
}
