import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  static const _baseURL =
      'https://shopappflutter-d0738-default-rtdb.firebaseio.com/';

  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorteItems {
    return [..._items.where((element) => element.isFavorite).toList()];
  }

  Future<void> addProduct(Product product) async {
    try {
      final response =
          await http.post(_baseURL + 'products.json?auth=$authToken',
              body: json.encode(
                {
                  'title': product.title,
                  'description': product.description,
                  'imageUrl': product.imageUrl,
                  'price': product.price,
                  'creatorId': userId,
                },
              ));

      final storedProduct = json.decode(response.body);
      final newProduct = Product(
          id: storedProduct['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      await http.patch(_baseURL + 'products/$id.json?auth=$authToken',
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
            },
          ));

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final existinProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existinProduct = _items[existinProductIndex];
    _items.removeAt(existinProductIndex);
    notifyListeners();
    final response =
        await http.delete(_baseURL + 'products/$id.json?auth=$authToken');
    if (response.statusCode >= 400) {
      //Handling the error, the rolback process is activated
      // Creating in memory rollback mechanism
      _items.insert(existinProductIndex, existinProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }

    existinProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterQuery =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      final response =
          await http.get(_baseURL + 'products.json?auth=$authToken&$filterQuery');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final favoriteReponse = await http
          .get(_baseURL + 'userFavorites/$userId.json?auth=$authToken');
      final favoriteData = json.decode(favoriteReponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.insert(
            0,
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              isFavorite: favoriteData == null
                  ? false
                  : (favoriteData[prodId] ?? false),
              imageUrl: prodData['imageUrl'],
            ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
