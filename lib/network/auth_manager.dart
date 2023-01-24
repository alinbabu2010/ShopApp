import 'dart:convert';

import 'package:http/http.dart';
import 'package:shop_app/models/auth_error_response.dart';
import 'package:shop_app/models/auth_success_response.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/signup_request.dart';

import '../env/env.dart';
import '../utils/constants.dart' as constants;

class AuthManager {
  AuthManager();

  AuthManager? authManager;

  final _authority = "https://identitytoolkit.googleapis.com/v1/accounts";

  AuthManager.newInstance() {
    authManager ??= AuthManager();
  }

  Future<AuthSuccessResponse> _authenticate(
    SignupRequest request,
    String urlSegment,
  ) async {
    final uri = Uri.parse("$_authority:$urlSegment?key=${Env.authApiKey}");
    try {
      final response = await post(uri, body: jsonEncode(request));
      if (response.statusCode >= 400) {
        final errorResponse = AuthErrorResponse.fromJson(
          jsonDecode(response.body),
        );
        final error = errorResponse.error;
        if (error != null) {
          var errorMessage = constants.authFailed;
          if (error.message.contains(constants.emailExists)) {
            errorMessage = constants.emailAlreadyInUseError;
          } else if (error.message.contains(constants.emailNotFound)) {
            errorMessage = constants.emailNotFoundErrorMsg;
          } else if (error.message.contains(constants.invalidPassword)) {
            errorMessage = constants.invalidPasswordErrorMsg;
          }
          throw HttpException(errorMessage);
        }
      }
      final successResponse = AuthSuccessResponse.fromJson(
        jsonDecode(response.body),
      );
      return successResponse;
    } catch (error) {
      rethrow;
    }
  }

  Future<AuthSuccessResponse> signup(SignupRequest request) async {
    return _authenticate(request, "signUp");
  }

  Future<AuthSuccessResponse> signIn(SignupRequest request) async {
    return _authenticate(request, "signInWithPassword");
  }
}
