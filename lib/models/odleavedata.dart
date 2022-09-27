// To parse this JSON data, do
//
//     final odLeaveData = odLeaveDataFromJson(jsonString);

import 'dart:convert';

List<OdLeaveData> odLeaveDataFromJson(String str) => List<OdLeaveData>.from(json.decode(str).map((x) => OdLeaveData.fromJson(x)));

String odLeaveDataToJson(List<OdLeaveData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OdLeaveData {
  OdLeaveData({
    this.logIn,
    this.logOut,
    this.empName,
    this.attendanceDate,
    this.employeeRemarks,
    this.transId,
    this.attendanceTransId,
  });

  String? logIn;
  String? logOut;
  String? empName;
  String? attendanceDate;
  String? employeeRemarks;
  String? transId;
  String? attendanceTransId;

  factory OdLeaveData.fromJson(Map<String, dynamic> json) => OdLeaveData(
    logIn: json["LogIn"],
    logOut: json["LogOut"],
    empName: json["EmpName"],
    attendanceDate: json["AttendanceDate"],
    employeeRemarks: json["EmployeeRemarks"],
    transId: json["TransId"],
    attendanceTransId: json["AttendanceTransId"],
  );

  Map<String, dynamic> toJson() => {
    "LogIn": logIn,
    "LogOut": logOut,
    "EmpName": empName,
    "AttendanceDate": attendanceDate,
    "EmployeeRemarks": employeeRemarks,
    "TransId": transId,
    "AttendanceTransId": attendanceTransId,
  };
}
