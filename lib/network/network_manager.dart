import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/parsers/product_parser.dart';
import 'package:shop_app/models/product.dart';

import '../models/order_item.dart';
import '../utils/constants.dart';
import '../utils/extension.dart';

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
      return ProductParser().parseProduct(response);
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

  static Future<Response> addOrders(OrderItem orderItem) async {
    final uri = _createUrl("/orders.json");
    return await post(uri, body: jsonEncode(orderItem));
  }

  static Uri _createUrl(String path) {
    return Uri.https(baseUrl, path);
  }
}
