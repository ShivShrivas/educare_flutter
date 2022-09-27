// To parse this JSON data, do
//
//     final noticeSaveResponse = noticeSaveResponseFromJson(jsonString);

import 'dart:convert';

List<NoticeSaveResponse> noticeSaveResponseFromJson(String str) => List<NoticeSaveResponse>.from(json.decode(str).map((x) => NoticeSaveResponse.fromJson(x)));

String noticeSaveResponseToJson(List<NoticeSaveResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoticeSaveResponse {
  NoticeSaveResponse({
    required this.status,
    required this.id,
  });

  String status;
  String id;

  factory NoticeSaveResponse.fromJson(Map<String, dynamic> json) => NoticeSaveResponse(
    status: json["Status"],
    id: json["ID"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "ID": id,
  };
}
