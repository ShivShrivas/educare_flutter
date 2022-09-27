// To parse this JSON data, do
//
//     final connectionConnector = connectionConnectorFromJson(jsonString);

import 'dart:convert';

List<ConnectionConnector> connectionConnectorFromJson(String str) => List<ConnectionConnector>.from(json.decode(str).map((x) => ConnectionConnector.fromJson(x)));

String connectionConnectorToJson(List<ConnectionConnector> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConnectionConnector {
  ConnectionConnector({
    required this.groupName,
    required this.societyName,
    required this.schoolName,
    required this.entity,
    required this.groupCode,
    required this.societyCode,
    required this.schoolCode,
    required this.branchCode,
    required this.displayCode,
    this.branchLogo,
  });

  String groupName;
  String societyName;
  String schoolName;
  String entity;
  String groupCode;
  String societyCode;
  String schoolCode;
  String branchCode;
  String displayCode;
  dynamic branchLogo;

  factory ConnectionConnector.fromJson(Map<String, dynamic> json) => ConnectionConnector(
    groupName: json["GroupName"],
    societyName: json["SocietyName"],
    schoolName: json["SchoolName"],
    entity: json["Entity"],
    groupCode: json["GroupCode"],
    societyCode: json["SocietyCode"],
    schoolCode: json["SchoolCode"],
    branchCode: json["BranchCode"],
    displayCode: json["DisplayCode"],
    branchLogo: json["BranchLogo"],
  );

  Map<String, dynamic> toJson() => {
    "GroupName": groupName,
    "SocietyName": societyName,
    "SchoolName": schoolName,
    "Entity": entity,
    "GroupCode": groupCode,
    "SocietyCode": societyCode,
    "SchoolCode": schoolCode,
    "BranchCode": branchCode,
    "DisplayCode": displayCode,
    "BranchLogo": branchLogo,
  };
}
