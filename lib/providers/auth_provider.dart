import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/security/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static final baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';

  String _token;
  DateTime _expDate;
  String _userId;
  Timer _authTimer;

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

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String methodName) async {
    try {
      final response =
          await http.post(baseUrl + methodName + '?key=$FIRE_BASE_APY_KEY',
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
      _autoLogout();
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expDate': _expDate.toIso8601String()
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
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

  Future<void> logout() async {
    _token = null;
    _expDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  Future<bool> tryAutologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userDataString =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;

    final expDate = DateTime.parse(userDataString['expDate']);

    if (!expDate.isAfter(DateTime.now())) {
      return false;
    }
    _token = userDataString['token'];
    _userId = userDataString['userId'];
    _expDate = expDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
