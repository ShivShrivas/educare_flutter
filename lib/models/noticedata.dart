// To parse this JSON data, do
//
//     final noticeData = noticeDataFromJson(jsonString);

import 'dart:convert';

List<NoticeData> noticeDataFromJson(String str) => List<NoticeData>.from(json.decode(str).map((x) => NoticeData.fromJson(x)));

String noticeDataToJson(List<NoticeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoticeData {
  NoticeData({
    required this.transId,
    required this.noticeBy,
    required this.createNoticeFor,
    required this.noticeFor,
    required this.noticeHeadline,
    required this.description,
    required this.attachmentPath,
    required this.attachmentType,
    required this.showDate,
    required this.endDate,
   // this.relationshipId,
    required this.date,
    required this.time,
  });

  String transId;
  String noticeBy;
  String createNoticeFor;
  String noticeFor;
  String noticeHeadline;
  String description;
  String? attachmentPath;
  String? attachmentType;
  DateTime showDate;
  DateTime endDate;
  //int relationshipId;
  String date;
  String time;

  factory NoticeData.fromJson(Map<String, dynamic> json) => NoticeData(
    transId: json["TransID"],
    noticeBy: json["NoticeBy"],
    createNoticeFor: json["CreateNoticeFor"],
    noticeFor: json["NoticeFor"],
    noticeHeadline: json["NoticeHeadline"],
    description: json["Description"],
    attachmentPath: json["AttachmentPath"],
    attachmentType: json["AttachmentType"],
    showDate: DateTime.parse(json["ShowDate"]),
    endDate: DateTime.parse(json["EndDate"]),
    //relationshipId: json["RelationshipId"],
    date: json["Date"],
    time: json["Time"],
  );

  Map<String, dynamic> toJson() => {
    "TransID": transId,
    "NoticeBy": noticeBy,
    "CreateNoticeFor": createNoticeFor,
    "NoticeFor": noticeFor,
    "NoticeHeadline": noticeHeadline,
    "Description": description,
    "AttachmentPath": attachmentPath,
    "AttachmentType": attachmentType,
    "ShowDate": showDate.toIso8601String(),
    "EndDate": endDate.toIso8601String(),
    //"RelationshipId": relationshipId,
    "Date": date,
    "Time": time,
  };
}
