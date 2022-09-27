// To parse this JSON data, do
//
//     final chapterStatusData = chapterStatusDataFromJson(jsonString);

import 'dart:convert';

List<ChapterStatusData> chapterStatusDataFromJson(String str) => List<ChapterStatusData>.from(json.decode(str).map((x) => ChapterStatusData.fromJson(x)));

String chapterStatusDataToJson(List<ChapterStatusData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChapterStatusData {
  ChapterStatusData({
    required this.id,
    required this.processName,
    required this.processType,
  });

  int id;
  String processName;
  String processType;

  factory ChapterStatusData.fromJson(Map<String, dynamic> json) => ChapterStatusData(
    id: json["ID"],
    processName: json["ProcessName"],
    processType: json["ProcessType"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "ProcessName": processName,
    "ProcessType": processType,
  };
}
