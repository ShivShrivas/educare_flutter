// To parse this JSON data, do
//
//     final complainData = complainDataFromJson(jsonString);

import 'dart:convert';

List<ComplainData> complainDataFromJson(String str) => List<ComplainData>.from(json.decode(str).map((x) => ComplainData.fromJson(x)));

String complainDataToJson(List<ComplainData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComplainData {
  ComplainData({
    required this.status,
    required this.transId,
    required this.ticket,
    required this.complainTo,
    required this.receivedByName,
    required this.receivedById,
    required this.creaetdById,
    required this.createdByName,
    required this.compalinSubject,
    required this.complainDescription,
    required this.attachmentPath,
    required this.attachmentType,
    required this.date,
    required this.time,
  });

  String status;
  String transId;
  String ticket;
  String complainTo;
  String receivedByName;
  int receivedById;
  int creaetdById;
  String createdByName;
  String compalinSubject;
  String complainDescription;
  String attachmentPath;
  String attachmentType;
  String date;
  String time;

  factory ComplainData.fromJson(Map<String, dynamic> json) => ComplainData(
    status: json["Status"],
    transId: json["TransID"],
    ticket: json["Ticket"],
    complainTo: json["ComplainTo"],
    receivedByName: json["ReceivedByName"],
    receivedById: json["ReceivedByID"],
    creaetdById: json["CreaetdByID"],
    createdByName: json["CreatedByName"],
    compalinSubject: json["CompalinSubject"],
    complainDescription: json["ComplainDescription"],
    attachmentPath: json["AttachmentPath"] == null ? null : json["AttachmentPath"],
    attachmentType: json["AttachmentType"] == null ? null : json["AttachmentType"],
    date: json["Date"],
    time: json["Time"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "TransID": transId,
    "Ticket": ticket,
    "ComplainTo": complainTo,
    "ReceivedByName": receivedByName,
    "ReceivedByID": receivedById,
    "CreaetdByID": creaetdById,
    "CreatedByName": createdByName,
    "CompalinSubject": compalinSubject,
    "ComplainDescription": complainDescription,
    "AttachmentPath": attachmentPath == null ? null : attachmentPath,
    "AttachmentType": attachmentType == null ? null : attachmentType,
    "Date": date,
    "Time": time,
  };
}
