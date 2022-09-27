// To parse this JSON data, do
//
//     final sessionMinMax = sessionMinMaxFromJson(jsonString);

import 'dart:convert';

List<SessionMinMax> sessionMinMaxFromJson(String str) => List<SessionMinMax>.from(json.decode(str).map((x) => SessionMinMax.fromJson(x)));

String sessionMinMaxToJson(List<SessionMinMax> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SessionMinMax {
  SessionMinMax({
    required this.fromDate,
    required this.toDate,
  });

  String fromDate;
  String toDate;

  factory SessionMinMax.fromJson(Map<String, dynamic> json) => SessionMinMax(
    fromDate: json["FromDate"],
    toDate: json["ToDate"],
  );

  Map<String, dynamic> toJson() => {
    "FromDate": fromDate,
    "ToDate": toDate,
  };
}
