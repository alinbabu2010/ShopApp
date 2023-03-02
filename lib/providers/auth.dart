import 'dart:async';

import 'package:flutter/widgets.dart';

import '../data/models/auth_success_response.dart';
import '../data/models/signup_request.dart';
import '../data/preferences/preference_manager.dart';
import '../data/repository/auth_repository.dart';

class Auth with ChangeNotifier {
  AuthSuccessResponse? userData;
  Timer? _authTimer;

  final authManager = AuthRepository.newInstance();
  final preferenceManager = PreferenceManager();

  /// Flag to check a user is logged out by clicking logout button
  bool isLoggedOut = false;

  bool get isAuth => token != null;

  String? get token {
    if (expiryDate?.isAfter(DateTime.now()) == true &&
        userData?.idToken != null) {
      return userData?.idToken;
    }
    return null;
  }

  String? get userId => userData?.localId;

  DateTime? get expiryDate => preferenceManager.getExpiryTime();

  void _setData(AuthSuccessResponse response) {
    userData = response;
    preferenceManager
      ..saveExpiryDate(userData?.expiresIn)
      ..saveUserData(response);
    _autoLogout();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await preferenceManager.setupPreference();
    userData = preferenceManager.getUserData(prefs);
    if (expiryDate?.isBefore(DateTime.now()) == true) {
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
        isLoggedOut = true;
        notifyListeners();
      }
    });
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer?.cancel();
    final expiryTime = expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
