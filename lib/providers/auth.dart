import 'package:flutter/widgets.dart';
import 'package:shop_app/models/auth_success_response.dart';
import 'package:shop_app/models/signup_request.dart';
import 'package:shop_app/network/auth_manager.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  final authManager = AuthManager.newInstance();

  bool get isAuth => token != null;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate?.isAfter(DateTime.now()) == true &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;

  void _setData(AuthSuccessResponse response) {
    _token = response.idToken;
    _expiryDate = DateTime.now().add(
      Duration(seconds: int.parse(response.expiresIn.toString())),
    );
    _userId = response.localId;
    notifyListeners();
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
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }
}
