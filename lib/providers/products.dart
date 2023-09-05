import 'dart:io';

import 'package:flutter/material.dart';

import '../data/models/product.dart';
import '../data/repository/shop_repository.dart';
import '../utils/constants.dart' as constants;

class Products with ChangeNotifier {
  final String? authToken;
  final List<Product> _items;
  final String? userId;

  Products(this.authToken, this.userId, this._items) {
    shopRepository.setCredentials(authToken, userId);
  }

  final shopRepository = ShopRepository.instance();

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
      try {
        final response = await shopRepository.setFavoriteProduct(
            id!, _items[productIndex].isFavorite);
        if (response.statusCode >= HttpStatus.badRequest) {
          _setFavorites(productIndex);
        }
      } catch (_) {
        _setFavorites(productIndex);
      }
    }
  }

  void _setFavorites(int productIndex) {
    _items[productIndex].isFavorite = !_items[productIndex].isFavorite;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    return await shopRepository.fetchProducts().then((products) {
      _items.clear();
      _items.addAll(products);
      notifyListeners();
    });
  }

  Future<void> addProduct(Product product) {
    return shopRepository.addProduct(product).then((productId) {
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
      return shopRepository.updateProduct(id!, product).then((value) {
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
    final response = await shopRepository.deleteProduct(id!);
    if (response.statusCode >= HttpStatus.badRequest) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException(constants.deleteErrorMsg);
    }
    existingProduct = null;
  }
}
