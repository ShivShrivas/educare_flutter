// To parse this JSON data, do
//
//     final attendanceData = attendanceDataFromJson(jsonString);

import 'dart:convert';

List<AttendanceDataOd> attendanceDataFromJson(String str) => List<AttendanceDataOd>.from(json.decode(str).map((x) => AttendanceDataOd.fromJson(x)));

String attendanceDataToJson(List<AttendanceDataOd> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceDataOd {
  AttendanceDataOd({
    required this.day,
    required this.date,
    required this.abbr,
    required this.logIn,
    required this.logOut,
    required this.isOd,
    required this.attendanceTransId,
  });

  int day;
  DateTime date;
  String abbr;
  String logIn;
  String logOut;
  int isOd;
  String attendanceTransId;

  factory AttendanceDataOd.fromJson(Map<String, dynamic> json) => AttendanceDataOd(
    day: json["DAY"],
    date: DateTime.parse(json["Date"]),
    abbr: json["Abbr"],
    logIn: json["LogIn"] == null ? '' : json["LogIn"],
    logOut: json["LogOut"] == null ? '' : json["LogOut"],
    isOd: json["IsOd"] == null ? '' : json["IsOd"],
    attendanceTransId: json["AttendanceTransId"]== null ? '' : json["AttendanceTransId"],
  );

  Map<String, dynamic> toJson() => {
    "DAY": day,
    "Date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "Abbr": abbr,
    "LogIn": logIn == null ? null : logIn,
    "LogOut": logOut == null ? null : logOut,
    "IsOd": isOd,
    "AttendanceTransId": attendanceTransId,
  };
}

