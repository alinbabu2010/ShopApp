import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/auth_success_response.dart';

class PreferenceManager {
  SharedPreferences? prefs;

  static const prefKey = "authCredentials";

  Future<SharedPreferences> setupPreference() {
    return SharedPreferences.getInstance();
  }

  void saveUserData(AuthSuccessResponse response) {
    final authCredentials = jsonEncode(response);
    prefs?.setString(prefKey, authCredentials);
  }

  AuthSuccessResponse? getUserData(SharedPreferences prefs) {
    this.prefs = prefs;
    if (prefs.containsKey(prefKey) == false) return null;
    try {
      final prefData = jsonDecode(prefs.getString(prefKey).toString());
      return AuthSuccessResponse.fromJson(prefData);
    } catch (error) {
      return null;
    }
  }

  Future<bool>? clearUserData() {
    return prefs?.clear();
  }
}
