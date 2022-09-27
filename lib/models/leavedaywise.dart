// To parse this JSON data, do
//
//     final dayWiseStatus = dayWiseStatusFromJson(jsonString);

import 'dart:convert';

List<DayWiseStatus> dayWiseStatusFromJson(String str) => List<DayWiseStatus>.from(json.decode(str).map((x) => DayWiseStatus.fromJson(x)));

String dayWiseStatusToJson(List<DayWiseStatus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DayWiseStatus {
  DayWiseStatus({
    required this.dateData,
    required this.dateDataUser,
    this.abbrTypeIdEmployee,
    this.typeName,
  });

  String dateData;
  String dateDataUser;
  dynamic abbrTypeIdEmployee;
  dynamic typeName;

  factory DayWiseStatus.fromJson(Map<String, dynamic> json) => DayWiseStatus(
    dateData: json["DateData"],
    dateDataUser: json["DateDataUser"],
    abbrTypeIdEmployee: json["AbbrTypeIdEmployee"],
    typeName: json["TypeName"],
  );

  Map<String, dynamic> toJson() => {
    "DateData": dateData,
    "DateDataUser": dateDataUser,
    "AbbrTypeIdEmployee": abbrTypeIdEmployee,
    "TypeName": typeName,
  };
}
