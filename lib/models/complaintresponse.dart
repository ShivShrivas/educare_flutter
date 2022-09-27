// To parse this JSON data, do
//
//     final complainResponse = complainResponseFromJson(jsonString);

import 'dart:convert';

List<ComplainResponse> complainResponseFromJson(String str) => List<ComplainResponse>.from(json.decode(str).map((x) => ComplainResponse.fromJson(x)));

String complainResponseToJson(List<ComplainResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComplainResponse {
  ComplainResponse({
    required this.status,
    required this.id,
    required this.ticket,
  });

  String status;
  String id;
  String ticket;

  factory ComplainResponse.fromJson(Map<String, dynamic> json) => ComplainResponse(
    status: json["Status"],
    id: json["ID"],
    ticket: json["Ticket"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "ID": id,
    "Ticket": ticket,
  };
}
