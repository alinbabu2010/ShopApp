class AuthSuccessResponse {
  String? idToken;
  String? email;
  String? refreshToken;
  String? expiresIn;
  String? localId;

  AuthSuccessResponse(
    this.idToken,
    this.email,
    this.refreshToken,
    this.expiresIn,
    this.localId,
  );

  AuthSuccessResponse.fromJson(dynamic json) {
    idToken = json['idToken'];
    email = json['email'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
    localId = json['localId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idToken'] = idToken;
    map['email'] = email;
    map['refreshToken'] = refreshToken;
    map['expiresIn'] = expiresIn;
    map['localId'] = localId;
    return map;
  }
}
