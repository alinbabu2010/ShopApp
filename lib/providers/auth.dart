import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shop_app/models/auth_success_response.dart';
import 'package:shop_app/models/signup_request.dart';
import 'package:shop_app/network/auth_repository.dart';
import 'package:shop_app/preferences/preference_manager.dart';

class Auth with ChangeNotifier {
  AuthSuccessResponse? userData;
  Timer? _authTimer;

  final authManager = AuthRepository.newInstance();
  final preferenceManager = PreferenceManager();

  bool get isAuth => token != null;

  String? get token {
    if (expiryDate.isAfter(DateTime.now()) == true &&
        userData?.idToken != null) {
      return userData?.idToken;
    }
    return null;
  }

  String? get userId => userData?.localId;

  DateTime get expiryDate => DateTime.now()
      .add(Duration(seconds: int.parse(userData?.expiresIn ?? "0")));

  void _setData(AuthSuccessResponse response) {
    userData = response;
    preferenceManager.saveUserData(response);
    _autoLogout();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await preferenceManager.setupPreference();
    userData = preferenceManager.getUserData(prefs);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    final requestModel = SignupRequest(email, password);
    return authManager
        .signup(requestModel)
        .then((response) => _setData(response));
  }

  Future<void> signIn(String email, String password) async {
    final requestModel = SignupRequest(email, password);
    return authManager
        .signIn(requestModel)
        .then((response) => _setData(response));
  }

  void logout() {
    preferenceManager.clearUserData()?.then((isCleared) {
      if (isCleared) {
        userData = null;
        if (_authTimer != null) {
          _authTimer?.cancel();
          _authTimer = null;
        }
        notifyListeners();
      }
    });
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer?.cancel();
    final expiryTime = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
