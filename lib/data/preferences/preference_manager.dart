import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_success_response.dart';

class PreferenceManager {
  SharedPreferences? prefs;

  static const prefKey = "authCredentials";
  static const prefExpireKey = "expirykey";

  Future<SharedPreferences> setupPreference() {
    return SharedPreferences.getInstance();
  }

  void saveUserData(AuthSuccessResponse response) {
    final authCredentials = jsonEncode(response);
    prefs?.setString(prefKey, authCredentials);
  }

  void saveExpiryDate(String? expiresIn) {
    DateTime dateTime = DateTime.now().add(Duration(
      seconds: int.parse(expiresIn ?? "0"),
    ));
    prefs?.setString(prefExpireKey, dateTime.toIso8601String());
  }

  DateTime? getExpiryTime() {
    if (prefs?.containsKey(prefExpireKey) == false) return null;
    try {
      final prefData = prefs?.getString(prefExpireKey);
      return DateTime.parse(prefData ?? "");
    } catch (error) {
      return null;
    }
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
