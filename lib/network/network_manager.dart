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

  static Future<List<Product>> fetchProducts() async {
    var uri = _createUrl("/products.json");
    try {
      final response = await get(uri);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, data) {
        loadedProducts.add(Product(
          id: productId,
          title: data["title"],
          description: data["description"],
          price: double.parse(data["price"]),
          imageUrl: data["imageUrl"],
          isFavorite: data["isFavorite"].parseBool(),
        ));
      });
      return loadedProducts;
    } catch (error) {
      rethrow;
    }
  }

  static Uri _createUrl(String path) {
    return Uri.https(baseUrl, path);
  }
}
