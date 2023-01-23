import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/parsers/product_parser.dart';
import 'package:shop_app/models/product.dart';

import '../models/http_exception.dart';
import '../models/order_item.dart';
import '../models/parsers/order_item_parser.dart';
import '../utils/constants.dart' as constants;

class NetworkManager {
  static Future<String> addProduct(Product product) {
    var uri = _createUrl("/products.json");
    return post(uri, body: jsonEncode(product))
        .then((response) => jsonDecode(response.body)['name']);
  }

  static Future<List<Product>> fetchProducts() async {
    var uri = _createUrl("/products.json");
    try {
      final response = await get(uri);
      if (response.statusCode >= 400) {
        throw HttpException(constants.somethingWrong);
      } else {
        return ProductParser().parseProduct(response);
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<Response> updateProduct(String productId, Product product) {
    final uri = _createUrl("/products/$productId.json");
    return patch(uri, body: jsonEncode(product));
  }

  static Future<Response> deleteProduct(String productId) async {
    final uri = _createUrl("/products/$productId.json");
    return await delete(uri);
  }

  static Future<OrderItem> addOrders(OrderItem orderItem) async {
    final uri = _createUrl("/orders.json");
    try {
      var response = await post(uri, body: jsonEncode(orderItem));
      if (response.statusCode >= 400) {
        throw HttpException(constants.orderErrorMsg);
      } else {
        orderItem.id = jsonDecode(response.body)[constants.nameKey];
      }
      return orderItem;
    } catch (_) {
      throw HttpException(constants.orderErrorMsg);
    }
  }

  static Future<List<OrderItem>> fetchOrders() async {
    final uri = _createUrl("/orders.json");
    try {
      var response = await get(uri);
      if (response.statusCode >= 400) {
        throw HttpException(constants.somethingWrong);
      } else {
        return OrderItemParser.newInstance().parseOrderItem(response);
      }
    } catch (error) {
      rethrow;
    }
  }

  static Uri _createUrl(String path) {
    return Uri.https(constants.baseUrl, path);
  }
}
