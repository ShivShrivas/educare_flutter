// To parse this JSON data, do
//
//     final circularData = circularDataFromJson(jsonString);

import 'dart:convert';

List<CircularData> circularDataFromJson(String str) => List<CircularData>.from(json.decode(str).map((x) => CircularData.fromJson(x)));

String circularDataToJson(List<CircularData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CircularData {
  CircularData({
    required this.transId,
    required this.circularBy,
    this.createCircularFor,
    this.circularFor,
    this.circularHeadline,
    required this.description,
    this.attachmentPath,
    this.attachmentType,
    required this.showDate,
    required this.endDate,
    required  this.date,
    required this.time,
    required this.baseUrl,
  });

  String transId;
  String circularBy;
  dynamic createCircularFor;
  dynamic circularFor;
  dynamic circularHeadline;
  String description;
  dynamic attachmentPath;
  dynamic attachmentType;
  DateTime showDate;
  DateTime endDate;
  String date;
  String time;
  String baseUrl;

  factory CircularData.fromJson(Map<String, dynamic> json) => CircularData(
    transId: json["TransID"],
    circularBy: json["CircularBy"],
    createCircularFor: json["CreateCircularFor"],
    circularFor: json["CircularFor"],
    circularHeadline: json["CircularHeadline"],
    description: json["Description"],
    attachmentPath: json["AttachmentPath"],
    attachmentType: json["AttachmentType"],
    showDate: DateTime.parse(json["ShowDate"]),
    endDate: DateTime.parse(json["EndDate"]),
    date: json["Date"],
    time: json["Time"],
    baseUrl: json["BaseUrl"],
  );

  Map<String, dynamic> toJson() => {
    "TransID": transId,
    "CircularBy": circularBy,
    "CreateCircularFor": createCircularFor,
    "CircularFor": circularFor,
    "CircularHeadline": circularHeadline,
    "Description": description,
    "AttachmentPath": attachmentPath,
    "AttachmentType": attachmentType,
    "ShowDate": showDate.toIso8601String(),
    "EndDate": endDate.toIso8601String(),
    "Date": date,
    "Time": time,
    "BaseUrl": baseUrl,
  };
}
