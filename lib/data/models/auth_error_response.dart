import 'error.dart';

class AuthErrorResponse {
  Error? error;

  AuthErrorResponse({required this.error});

  AuthErrorResponse.fromJson(dynamic json) {
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error?.toJson();
    return map;
  }
}
