import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  static const _baseURL =
      'https://shopappflutter-d0738-default-rtdb.firebaseio.com/';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(String autToken) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final reponse = await http.patch(_baseURL + 'products/$id.json?auth=$autToken',
          body: json.encode({
            'isFavorite': isFavorite,
          }));

      if (reponse.statusCode >= 400) {
        throw HttpException('Could not be posible');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
