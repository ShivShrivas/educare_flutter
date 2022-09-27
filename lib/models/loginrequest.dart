// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    required this.obj,
  });

  Obj obj;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    obj: Obj.fromJson(json["obj"]),
  );

  Map<String, dynamic> toJson() => {
    "obj": obj.toJson(),
  };
}

class Obj {
  Obj({
    required this.action,
    required this.mobileno,
    required this.passCode,
    required this.gsmid,
  });

  String action;
  String mobileno;
  String passCode;
  String gsmid;

  factory Obj.fromJson(Map<String, dynamic> json) => Obj(
    action: json["Action"],
    mobileno: json["mobileno"],
    passCode: json["PassCode"],
    gsmid: json["GSMID"],
  );

  Map<String, dynamic> toJson() => {
    "Action": action,
    "mobileno": mobileno,
    "PassCode": passCode,
    "GSMID": gsmid,
  };
}
