import 'package:flutter/material.dart';
import 'package:shop_app/network/network_manager.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  /// Returns [Product] that matches the given [id]
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    return await NetworkManager.fetchProducts().then((products) {
      _items.clear();
      _items.addAll(products);
      notifyListeners();
    });
  }

  Future<void> addProduct(Product product) {
    return NetworkManager.addProduct(product).then((productId) {
      final newProduct = Product(
        id: productId,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String? id, Product product) {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      return NetworkManager.updateProduct(id!, product).then((value) {
        product.isFavorite = _items[productIndex].isFavorite;
        _items[productIndex] = product;
        notifyListeners();
      });
    }
    return Future.value(null);
  }

  void deleteProduct(String? id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
