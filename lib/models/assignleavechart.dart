// To parse this JSON data, do
//
//     final assignLeaveChart = assignLeaveChartFromJson(jsonString);

import 'dart:convert';

List<AssignLeaveChart> assignLeaveChartFromJson(String str) => List<AssignLeaveChart>.from(json.decode(str).map((x) => AssignLeaveChart.fromJson(x)));

String assignLeaveChartToJson(List<AssignLeaveChart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssignLeaveChart {
  AssignLeaveChart({
    required this.leaveTypeCode,
    required this.approvedLeave,
  });

  String leaveTypeCode;
  double approvedLeave;

  factory AssignLeaveChart.fromJson(Map<String, dynamic> json) => AssignLeaveChart(
    leaveTypeCode: json["LeaveTypeCode"],
    approvedLeave: json["ApprovedLeave"],
  );

  Map<String, dynamic> toJson() => {
    "LeaveTypeCode": leaveTypeCode,
    "ApprovedLeave": approvedLeave,
  };
}
