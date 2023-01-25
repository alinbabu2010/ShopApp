import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/parsers/product_parser.dart';
import 'package:shop_app/models/product.dart';

import '../models/http_exception.dart';
import '../models/order_item.dart';
import '../models/parsers/order_item_parser.dart';
import '../utils/constants.dart' as constants;

class NetworkManager {
  NetworkManager();

  NetworkManager? networkManager;

  String? _authToken;
  String? _userId;

  NetworkManager.newInstance() {
    networkManager ??= NetworkManager();
  }

  void setCredentials(String? token, String? userId) {
    _authToken = token;
    _userId = userId;
  }

  Future<String> addProduct(Product product) {
    var uri = _createUrl("/products.json");
    return post(uri, body: jsonEncode(product))
        .then((response) => jsonDecode(response.body)['name']);
  }

  Future<List<Product>> fetchProducts() async {
    var uri = _createUrl("/products.json");
    try {
      final productResponse = await get(uri);
      uri = _createUrl("/userFavorites/$_userId.json");
      final favoriteResponse = await get(uri);
      if (productResponse.statusCode >= 400 ||
          favoriteResponse.statusCode >= 400) {
        throw HttpException(constants.somethingWrong);
      } else {
        return ProductParser().parseProduct(productResponse, favoriteResponse);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> setFavoriteProduct(String productId, bool isFavorite) {
    final uri = _createUrl("/userFavorites/$_userId/$productId.json");
    return put(uri, body: jsonEncode(isFavorite));
  }

  Future<Response> updateProduct(String productId, Product product) {
    final uri = _createUrl("/products/$productId.json");
    return patch(uri, body: jsonEncode(product));
  }

  Future<Response> deleteProduct(String productId) async {
    final uri = _createUrl("/products/$productId.json");
    return await delete(uri);
  }

  Future<OrderItem> addOrders(OrderItem orderItem) async {
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

  Future<List<OrderItem>> fetchOrders() async {
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

  Uri _createUrl(String path) {
    return Uri.https(constants.baseUrl, path, {"auth": _authToken});
  }
}
