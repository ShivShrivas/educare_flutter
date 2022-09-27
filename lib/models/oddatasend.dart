// To parse this JSON data, do
//
//     final odDataSend = odDataSendFromJson(jsonString);

import 'dart:convert';

OdDataSend odDataSendFromJson(String str) => OdDataSend.fromJson(json.decode(str));

String odDataSendToJson(OdDataSend data) => json.encode(data.toJson());

class OdDataSend {
  OdDataSend({
    this.approvalAuthorityRemarks,
    this.transId,
    this.attendanceTransId,
  });

  String? approvalAuthorityRemarks;
  String? transId;
  String? attendanceTransId;

  factory OdDataSend.fromJson(Map<String, dynamic> json) => OdDataSend(
    approvalAuthorityRemarks: json["ApprovalAuthorityRemarks"],
    transId: json["TransId"],
    attendanceTransId: json["AttendanceTransId"],
  );

  Map<String, dynamic> toJson() => {
    "ApprovalAuthorityRemarks": approvalAuthorityRemarks,
    "TransId": transId,
    "AttendanceTransId": attendanceTransId,
  };
}
