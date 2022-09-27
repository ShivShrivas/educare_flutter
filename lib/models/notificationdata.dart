// To parse this JSON data, do
//
//     final notificationdata = notificationdataFromJson(jsonString);

import 'dart:convert';

List<Notificationdata> notificationdataFromJson(String str) => List<Notificationdata>.from(json.decode(str).map((x) => Notificationdata.fromJson(x)));

String notificationdataToJson(List<Notificationdata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notificationdata {
  Notificationdata({
    this.transId,
    this.userId,
    this.title,
    this.notificationBody,
    this.notificationDate,
  });

  String? transId;
  String? userId;
  String? title;
  String? notificationBody;
  String? notificationDate;

  factory Notificationdata.fromJson(Map<String, dynamic> json) => Notificationdata(
    transId: json["TransId"],
    userId: json["UserID"],
    title: json["Title"],
    notificationBody: json["NotificationBody"]==null ? "":json["NotificationBody"],
    notificationDate: json["NotificationDate"]==null ? "":json["NotificationDate"],
  );

  Map<String, dynamic> toJson() => {
    "TransId": transId,
    "UserID": userId,
    "Title": title,
    "NotificationBody": notificationBody,
    "NotificationDate": notificationDate,
  };
}
