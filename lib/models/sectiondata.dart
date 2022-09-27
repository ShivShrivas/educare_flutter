// To parse this JSON data, do
//
//     final sectionDataList = sectionDataListFromJson(jsonString);

import 'dart:convert';

List<SectionDataList> sectionDataListFromJson(String str) => List<SectionDataList>.from(json.decode(str).map((x) => SectionDataList.fromJson(x)));

String sectionDataListToJson(List<SectionDataList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SectionDataList {
  SectionDataList({
    required this.sectionName,
    required this.code,
  });

  String sectionName;
  String code;

  factory SectionDataList.fromJson(Map<String, dynamic> json) => SectionDataList(
    sectionName: json["SectionName"],
    code: json["Code"],
  );

  Map<String, dynamic> toJson() => {
    "SectionName": sectionName,
    "Code": code,
  };
}
