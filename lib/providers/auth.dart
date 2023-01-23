import 'package:flutter/widgets.dart';
import 'package:shop_app/models/signup_request.dart';
import 'package:shop_app/network/auth_manager.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  final authManager = AuthManager.newInstance();

  Future<void> signup(String email, String password) async {
    final requestModel = SignupRequest(email, password);
    return authManager.signup(requestModel);
  }

  Future<void> signIn(String email, String password) async {
    final requestModel = SignupRequest(email, password);
    return authManager.signIn(requestModel);
  }
}
