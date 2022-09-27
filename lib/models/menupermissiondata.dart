// To parse this JSON data, do
//
//     final menuPermissionData = menuPermissionDataFromJson(jsonString);

import 'dart:convert';

List<MenuPermissionData> menuPermissionDataFromJson(String str) => List<MenuPermissionData>.from(json.decode(str).map((x) => MenuPermissionData.fromJson(x)));

String menuPermissionDataToJson(List<MenuPermissionData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuPermissionData {
  MenuPermissionData({
    required this.menu,
    required this.subMenu,
    required this.displayOrder,
    required this.isActive,
  });

  String menu;
  List<SubMenu> subMenu;
  int displayOrder;
  bool isActive;

  factory MenuPermissionData.fromJson(Map<String, dynamic> json) => MenuPermissionData(
    menu: json["Menu"],
    subMenu: List<SubMenu>.from(json["SubMenu"].map((x) => SubMenu.fromJson(x))),
    displayOrder: json["DisplayOrder"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "Menu": menu,
    "SubMenu": List<dynamic>.from(subMenu.map((x) => x.toJson())),
    "DisplayOrder": displayOrder,
    "IsActive": isActive,
  };
}

class SubMenu {
  SubMenu({
    required this.subMenuName,
    required this.isAdd,
    required this.isEdit,
    required this.isDelete,
    required this.isPrint,
    required this.isActive,
    required this.displayOrder,
  });

  String subMenuName;
  bool isAdd;
  bool isEdit;
  bool isDelete;
  bool isPrint;
  bool isActive;
  int displayOrder;

  factory SubMenu.fromJson(Map<String, dynamic> json) => SubMenu(
    subMenuName: json["SubMenuName"],
    isAdd: json["IsAdd"],
    isEdit: json["IsEdit"],
    isDelete: json["IsDelete"],
    isPrint: json["IsPrint"],
    isActive: json["IsActive"],
    displayOrder: json["DisplayOrder"],
  );

  Map<String, dynamic> toJson() => {
    "SubMenuName": subMenuName,
    "IsAdd": isAdd,
    "IsEdit": isEdit,
    "IsDelete": isDelete,
    "IsPrint": isPrint,
    "IsActive": isActive,
    "DisplayOrder": displayOrder,
  };
}
