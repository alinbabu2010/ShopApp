import 'dart:convert';

import 'package:http/http.dart';

import '../product.dart';

class ProductParser {
  ProductParser? productParser;

  ProductParser();

  List<Product> parseProduct(
      Response productResponse, Response favoriteResponse) {
    try {
      final extractedData =
          jsonDecode(productResponse.body) as Map<String, dynamic>;
      final favoritesData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, data) {
        var product = Product.fromJson(data);
        product.id = productId;
        product.isFavorite =
            favoritesData == null ? false : favoritesData[productId] ?? false;
        loadedProducts.add(product);
      });
      return loadedProducts;
    } catch (error) {
      rethrow;
    }
  }
}
