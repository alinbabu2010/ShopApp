import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/signup_request.dart';

class AuthManager {
  AuthManager();

  AuthManager? authManager;

  final authority = "https://identitytoolkit.googleapis.com/v1/accounts";
  final apiKey = "AIzaSyCiigFkkTqmMudZWf-vGkOT4csqgvZLBh0";

  AuthManager.newInstance() {
    authManager ??= AuthManager();
  }

  Future<void> signup(SignupRequest request) async {
    final uri = _createUri("signUp");
    final response = await post(uri, body: jsonEncode(request));
    print(jsonDecode(response.body.toString()));
  }

  Uri _createUri(String action) {
    return Uri.parse("$authority:$action?key=$apiKey");
  }
}
