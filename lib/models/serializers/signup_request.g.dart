part of '../signup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    SignupRequest(
      json['email'] as String,
      json['password'] as String,
      returnSecureToken: json['returnSecureToken'].toString().parseBool(),
    );

Map<String, dynamic> _$SignupRequestToJson(SignupRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'returnSecureToken': instance.returnSecureToken,
    };
