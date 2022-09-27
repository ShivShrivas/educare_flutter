// To parse this JSON data, do
//
//     final attendanceData = attendanceDataFromJson(jsonString);

import 'dart:convert';

List<AttendanceData> attendanceDataFromJson(String str) => List<AttendanceData>.from(json.decode(str).map((x) => AttendanceData.fromJson(x)));

String attendanceDataToJson(List<AttendanceData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceData {
  AttendanceData({
    required this.date,
    required this.abbreviation,
    required this.day,
  });

  DateTime date;
  String abbreviation;
  int day;

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
    date: DateTime.parse(json["Date"]),
    abbreviation: json["Abbr"],
    day: json["DAY"],
  );

  Map<String, dynamic> toJson() => {
    "Date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "Abbr": abbreviation,
    "DAY": day,
  };
}
