// To parse this JSON data, do
//
//     final leaveFor = leaveForFromJson(jsonString);

import 'dart:convert';

List<LeaveFor> leaveForFromJson(String str) => List<LeaveFor>.from(json.decode(str).map((x) => LeaveFor.fromJson(x)));

String leaveForToJson(List<LeaveFor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveFor {
  LeaveFor({
    required this.name,
    required this.fullName,
  });

  String name;
  String fullName;

  factory LeaveFor.fromJson(Map<String, dynamic> json) => LeaveFor(
    name: json["Name"],
    fullName: json["FullName"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "FullName": fullName,
  };
}
