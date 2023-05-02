import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shop_app/utils/constants.dart' as constants;

import '../interceptors/logging_interceptor.dart';
import '../models/http_exception.dart';
import '../models/order_item.dart';
import '../models/parsers/order_item_parser.dart';
import '../models/parsers/product_parser.dart';
import '../models/product.dart';

class ShopRepository {
  ShopRepository();

  ShopRepository? shopRepository;

  String? _authToken;
  String? _userId;

  ShopRepository.newInstance() {
    shopRepository ??= ShopRepository();
  }

  final _client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);

  void setCredentials(String? token, String? userId) {
    _authToken = token;
    _userId = userId;
  }

  Future<String> addProduct(Product product) {
    var uri = _createUrl("/products/$_userId.json");
    final requestBody = product.toJson();
    requestBody.remove("isFavorite");
    return _client
        .post(uri, body: jsonEncode(requestBody))
        .then((response) => jsonDecode(response.body)['name']);
  }

  Future<List<Product>> fetchProducts() async {
    var uri = _createUrl("/products/$_userId.json");
    try {
      final productResponse = await _client.get(uri);
      uri = _createUrl("/userFavorites/$_userId.json");
      final favoriteResponse = await _client.get(uri);
      if (productResponse.statusCode >= HttpStatus.badRequest) {
        _throwError(productResponse.body.toString());
      } else if (favoriteResponse.statusCode >= HttpStatus.badRequest) {
        _throwError(productResponse.body.toString());
      } else {
        return ProductParser().parseProduct(productResponse, favoriteResponse);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> setFavoriteProduct(String productId, bool isFavorite) {
    final uri = _createUrl("/userFavorites/$_userId/$productId.json");
    return _client.put(uri, body: jsonEncode(isFavorite));
  }

  Future<Response> updateProduct(String productId, Product product) {
    final uri = _createUrl("/products/$_userId/$productId.json");
    return _client.patch(uri, body: jsonEncode(product));
  }

  Future<Response> deleteProduct(String productId) async {
    final uri = _createUrl("/products/$_userId/$productId.json");
    return await _client.delete(uri);
  }

  Future<OrderItem> addOrders(OrderItem orderItem) async {
    final uri = _createUrl("/orders/$_userId.json");
    try {
      var response = await _client.post(uri, body: jsonEncode(orderItem));
      if (response.statusCode >= HttpStatus.badRequest) {
        _throwOrdersError(response.body.toString());
      } else {
        orderItem.id = jsonDecode(response.body)[constants.nameKey];
      }
      return orderItem;
    } catch (error) {
      _throwOrdersError(error.toString());
    }
  }

  Future<List<OrderItem>> fetchOrders() async {
    final uri = _createUrl("/orders/$_userId.json");
    try {
      var response = await _client.get(uri);
      if (response.statusCode >= HttpStatus.badRequest) {
        _throwError(response.body.toString());
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

  Never _throwError(String message) {
    return throw HttpException(kDebugMode ? message : constants.somethingWrong);
  }

  Never _throwOrdersError(String message) {
    return throw HttpException(kDebugMode ? message : constants.orderErrorMsg);
  }
}
