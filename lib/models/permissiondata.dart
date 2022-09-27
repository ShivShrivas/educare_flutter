// To parse this JSON data, do
//
//     final permissionData = permissionDataFromJson(jsonString);

import 'dart:convert';

List<PermissionData> permissionDataFromJson(String str) => List<PermissionData>.from(json.decode(str).map((x) => PermissionData.fromJson(x)));

String permissionDataToJson(List<PermissionData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PermissionData {
  PermissionData({
    required this.menu,
    required this.subMenu,
    required this.displayOrder,
    required this.isActive,
  });

  String menu;
  String subMenu;
  int displayOrder;
  bool isActive;

  factory PermissionData.fromJson(Map<String, dynamic> json) => PermissionData(
    menu: json["Menu"],
    subMenu: json["SubMenu"],
    displayOrder: json["DisplayOrder"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "Menu": menu,
    "SubMenu": subMenu,
    "DisplayOrder": displayOrder,
    "IsActive": isActive,
  };
}
