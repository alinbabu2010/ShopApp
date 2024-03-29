import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:shop_app/data/interceptors/logging_interceptor.dart';
import 'package:shop_app/env/env.dart';
import 'package:shop_app/utils/constants.dart' as constants;

import '../models/auth_error_response.dart';
import '../models/auth_success_response.dart';
import '../models/http_exception.dart';
import '../models/signup_request.dart';

class AuthRepository {
  AuthRepository();

  AuthRepository? authRepository;

  final _authority = "https://identitytoolkit.googleapis.com/v1/accounts";

  AuthRepository.instance() {
    authRepository ??= AuthRepository();
  }

  Future<AuthSuccessResponse> _authenticate(
    SignupRequest request,
    String urlSegment,
  ) async {
    final uri = Uri.parse("$_authority:$urlSegment?key=${Env.authApiKey}");
    try {
      final http = InterceptedHttp.build(interceptors: [
        LoggingInterceptor(),
      ]);
      final response = await http.post(uri, body: jsonEncode(request));
      if (response.statusCode >= HttpStatus.badRequest) {
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
