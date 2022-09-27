// To parse this JSON data, do
//
//     final leaveChartData = leaveChartDataFromJson(jsonString);

import 'dart:convert';

List<LeaveChartData> leaveChartDataFromJson(String str) => List<LeaveChartData>.from(json.decode(str).map((x) => LeaveChartData.fromJson(x)));

String leaveChartDataToJson(List<LeaveChartData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveChartData {
  LeaveChartData({
    required this.employeeCode,
    required this.departmentCode,
    required this.designationCode,
    required this.leaveTypeCode,
    required this.leaveType,
    required this.totalLeaves,
    required  this.allotedLeaves,
    required this.leaveTaken,
    required this.balance,
    required this.totalApprovedLeave,
    required this.totalAllotedLeave,
    required this.abbrTypeId,
    required this.el,
    required this.elbalance,
  });

  String employeeCode;
  String departmentCode;
  String designationCode;
  String leaveTypeCode;
  String leaveType;
  double totalLeaves;
  double allotedLeaves;
  double leaveTaken;
  double balance;
  double totalApprovedLeave;
  double el;
  double elbalance;
  int totalAllotedLeave;
  int abbrTypeId;

  factory LeaveChartData.fromJson(Map<String, dynamic> json) => LeaveChartData(
    employeeCode: json["EmployeeCode"],
    departmentCode: json["DepartmentCode"],
    designationCode: json["DesignationCode"],
    leaveTypeCode: json["LeaveTypeCode"],
    leaveType: json["LeaveType"],
    totalLeaves: json["TotalLeaves"]==null ? 0.0:json["TotalLeaves"],
    allotedLeaves: json["AllotedLeaves"]==null ? 0.0:json["AllotedLeaves"],
    leaveTaken: json["LeaveTaken"]==null ? 0.0:json["LeaveTaken"],
    balance: json["Balance"]==null ? 0.0:json["Balance"],
    totalApprovedLeave: json["TotalApprovedLeave"]==null ? 0.0:json["TotalApprovedLeave"],
    totalAllotedLeave: json["TotalAllotedLeave"]==null ? 0 :json["TotalAllotedLeave"],
    el: json["EL"]==null ? 0.0 :json["EL"],
    elbalance: json["ElBalance"]==null ? 0.0 :json["ElBalance"],
    abbrTypeId: json["AbbrTypeId"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeCode": employeeCode,
    "DepartmentCode": departmentCode,
    "DesignationCode": designationCode,
    "LeaveTypeCode": leaveTypeCode,
    "LeaveType": leaveType,
    "TotalLeaves": totalLeaves,
    "AllotedLeaves": allotedLeaves,
    "LeaveTaken": leaveTaken,
    "Balance": balance,
    "TotalApprovedLeave": totalApprovedLeave,
    "TotalAllotedLeave": totalAllotedLeave,
    "EL": el,
    "ElBalance": elbalance,
    "AbbrTypeId": abbrTypeId,

  };
}
