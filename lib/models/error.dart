class Error {
  late int code;
  late String message;

  Error(this.code, this.message);

  Error.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    return map;
  }
}
