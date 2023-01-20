import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/utils/extension.dart';

import '../product.dart';

class ProductParser {
  ProductParser? productParser;

  ProductParser();

  List<Product> parseProduct(Response response) {
    try {
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, data) {
        var product = Product.fromJson(data);
        product.isFavorite = data["isFavorite"].toString().parseBool();
        loadedProducts.add(product);
      });
      return loadedProducts;
    } catch (error) {
      return List.empty();
    }
  }
}
