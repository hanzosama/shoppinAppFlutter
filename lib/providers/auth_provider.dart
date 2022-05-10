import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  static final API_KEY = 'AIzaSyCnTlTIxOxTmqEcSoj-5MBAcOYYYAoE64Y';

  static final baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';

  String _token;
  DateTime _expDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expDate != null &&
        _expDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String methodName) async {
    try {
      final response = await http.post(baseUrl + methodName + '?key=$API_KEY',
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
