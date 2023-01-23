import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/auth_error_response.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/signup_request.dart';

import '../utils/constants.dart' as constants;

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
    try {
      final response = await post(uri, body: jsonEncode(request));
      if (response.statusCode >= 400) {
        final errorResponse = AuthErrorResponse.fromJson(
          jsonDecode(response.body),
        );
        final error = errorResponse.error;
        if (error != null) {
          var errorMessage = constants.authFailed;
          if (error.toString().contains(constants.emailExists)) {
            errorMessage = constants.emailAlreadyInUseError;
          } else if (error.toString().contains(constants.emailNotFound)) {
            errorMessage = constants.emailNotFoundErrorMsg;
          } else if (error.toString().contains(constants.invalidPassword)) {
            errorMessage = constants.invalidPasswordErrorMsg;
          }
          throw HttpException(errorMessage);
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(SignupRequest request) async {
    return _authenticate(request, "signUp");
  }

  Future<void> signIn(SignupRequest request) async {
    return _authenticate(request, "signInWithPassword");
  }
}
