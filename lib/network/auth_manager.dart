import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/signup_request.dart';

class AuthManager {
  AuthManager();

  AuthManager? authManager;

  final _authority = "https://identitytoolkit.googleapis.com/v1/accounts";
  final _apiKey = "AIzaSyCiigFkkTqmMudZWf-vGkOT4csqgvZLBh0";

  AuthManager.newInstance() {
    authManager ??= AuthManager();
  }

  Future<void> _authenticate(SignupRequest request, String urlSegment) async {
    final uri = Uri.parse("$_authority:$urlSegment?key=$_apiKey");
    final response = await post(uri, body: jsonEncode(request));
    print(jsonDecode(response.body.toString()));
  }

  Future<void> signup(SignupRequest request) async {
    return _authenticate(request, "signUp");
  }

  Future<void> signIn(SignupRequest request) async {
    return _authenticate(request, "signInWithPassword");
  }
}
