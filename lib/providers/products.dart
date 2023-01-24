import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/network/network_manager.dart';

import '../models/product.dart';
import '../utils/constants.dart' as constants;

class Products with ChangeNotifier {
  final String? authToken;
  final List<Product> _items;

  Products(this.authToken, this._items) {
    networkManager.setAuthToken(authToken);
  }

  final networkManager = NetworkManager.newInstance();

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

  Future<void> toggleFavorite(String? id) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    _setFavorites(productIndex);
    if (productIndex >= 0) {
      return networkManager.updateProduct(id!, _items[productIndex])
          .then((response) {
        if (response.statusCode >= 400) {
          _setFavorites(productIndex);
        }
      }).catchError((value) {
        _setFavorites(productIndex);
      });
    }
  }

  void _setFavorites(int productIndex) {
    _items[productIndex].isFavorite = !_items[productIndex].isFavorite;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    return await networkManager.fetchProducts().then((products) {
      _items.clear();
      _items.addAll(products);
      notifyListeners();
    });
  }

  Future<void> addProduct(Product product) {
    return networkManager.addProduct(product).then((productId) {
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
      return networkManager.updateProduct(id!, product).then((value) {
        product.isFavorite = _items[productIndex].isFavorite;
        _items[productIndex] = product;
        notifyListeners();
      });
    }
    return Future.value(null);
  }

  Future<void> deleteProduct(String? id) async {
    final existingProductIndex =
    _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await networkManager.deleteProduct(id!);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(constants.deleteErrorMsg);
    }
    existingProduct = null;
  }
}
