import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/providers/product.dart';

import '../utils/constants.dart';

class NetworkManager {
  static Future<String> addProduct(Product product) {
    var uri = _createUrl("/products.json");
    return post(uri, body: jsonEncode(product))
        .then((response) => jsonDecode(response.body)['name']);
  }

  static Uri _createUrl(String path) {
    return Uri.https(baseUrl, path);
  }
}
