// To parse this JSON data, do
//
//     final studentDataStore = studentDataStoreFromJson(jsonString);

import 'dart:convert';

List<StudentDataStore> studentDataStoreFromJson(String str) => List<StudentDataStore>.from(json.decode(str).map((x) => StudentDataStore.fromJson(x)));

String studentDataStoreToJson(List<StudentDataStore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentDataStore {
  StudentDataStore({
    required this.code,
    required this.name,
  });

  String code;
  String name;

  factory StudentDataStore.fromJson(Map<String, dynamic> json) => StudentDataStore(
    code: json["Code"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Name": name,
  };
}


/*
StudentDataStore.fromJson(Map<String, dynamic> json)
: code = json['Code'],
name = json['Name'];*/
