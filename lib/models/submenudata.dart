// To parse this JSON data, do
//
//     final submenuData = submenuDataFromJson(jsonString);

import 'dart:convert';

List<SubmenuData> submenuDataFromJson(String str) => List<SubmenuData>.from(json.decode(str).map((x) => SubmenuData.fromJson(x)));

String submenuDataToJson(List<SubmenuData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubmenuData {
  SubmenuData({
    required this.subMenuName,
    required this.isAdd,
    required this.isEdit,
    required this.isDelete,
    required this.isPrint,
    required this.displayOrder,
    required this.isActive,
  });

  String subMenuName;
  String isActive;
  bool isAdd;
  bool isEdit;
  bool isDelete;
  bool isPrint;
  int displayOrder;

  factory SubmenuData.fromJson(Map<String, dynamic> json) => SubmenuData(
    subMenuName: json["SubMenuName"],
    isAdd: json["IsAdd"],
    isEdit: json["IsEdit"],
    isDelete: json["IsDelete"],
    isPrint: json["IsPrint"],
    displayOrder: json["DisplayOrder"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "SubMenuName": subMenuName,
    "IsAdd": isAdd,
    "IsEdit": isEdit,
    "IsDelete": isDelete,
    "IsPrint": isPrint,
    "DisplayOrder": displayOrder,
    "IsActive": isActive,
  };
}
