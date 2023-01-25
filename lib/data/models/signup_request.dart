import 'package:json_annotation/json_annotation.dart';
import 'package:shop_app/utils/extension.dart';

part 'serializers/signup_request.g.dart';

@JsonSerializable()
class SignupRequest {
  String email;
  String password;
  bool returnSecureToken;

  SignupRequest(this.email, this.password, {this.returnSecureToken = true});

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}
