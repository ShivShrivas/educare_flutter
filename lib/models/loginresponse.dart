// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

List<LoginResponse> loginResponseFromJson(String str) => List<LoginResponse>.from(json.decode(str).map((x) => LoginResponse.fromJson(x)));

String loginResponseToJson(List<LoginResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginResponse {
  LoginResponse({
    required this.userId,
    required this.userName,
    required this.userTypeId,
    required this.loginAs,
    this.lastLogin,
    required this.activeAcademicYearId,
    required this.activeAcademicYear,
    required this.activeFinancialYearId,
    required this.activeFinancialYear,
    required this.displayCode,
    required this.relationshipId,
    required this.isHo,
    this.isSchool,
    this.isCollege,
    this.isSociety,
    this.branchLogo,
    required this.groupCode,
    required this.societyCode,
    required this.schoolCode,
    required this.branchCode,
    required this.schoolName,
    this.profilePic,
    this.mobileNo,
    this.emailId,
    required this.state,
    required this.response,
    required this.code,
    required this.departmentCode,
    required this.designationCode,
    required this.schoolAddress,
  });

  int userId;
  String userName;
  int userTypeId;
  String loginAs;
  dynamic lastLogin;
  int activeAcademicYearId;
  String activeAcademicYear;
  int activeFinancialYearId;
  String activeFinancialYear;
  String displayCode;
  int relationshipId;
  bool isHo;
  dynamic isSchool;
  dynamic isCollege;
  dynamic isSociety;
  dynamic branchLogo;
  String groupCode;
  String societyCode;
  String schoolCode;
  String branchCode;
  String schoolName;
  String? profilePic;
  String? mobileNo;
  String? emailId;
  int state;
  String response;
  dynamic code;
  String departmentCode;
  String designationCode;
  String schoolAddress;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userId: json["UserId"],
    userName: json["UserName"],
    userTypeId: json["UserTypeId"],
    loginAs: json["loginAs"],
    lastLogin: json["LastLogin"],
    activeAcademicYearId: json["ActiveAcademicYearId"],
    activeAcademicYear: json["ActiveAcademicYear"],
    activeFinancialYearId: json["ActiveFinancialYearId"],
    activeFinancialYear: json["ActiveFinancialYear"],
    displayCode: json["DisplayCode"],
    relationshipId: json["RelationshipId"],
    isHo: json["IsHO"],
    isSchool: json["IsSchool"],
    isCollege: json["IsCollege"],
    isSociety: json["IsSociety"],
    branchLogo: json["BranchLogo"],
    groupCode: json["GroupCode"],
    societyCode: json["SocietyCode"],
    schoolCode: json["SchoolCode"],
    branchCode: json["BranchCode"],
    schoolName: json["SchoolName"],
    profilePic: json["ProfilePic"],
    mobileNo: json["MobileNo"],
    emailId: json["EmailId"],
    state: json["State"],
    response: json["Response"],
    code: json["Code"],
    departmentCode: json["DepartmentCode"],
    designationCode: json["DesignationCode"],
    schoolAddress: json["SchoolAddress"]==''?"":json["SchoolAddress"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "UserName": userName,
    "UserTypeId": userTypeId,
    "loginAs": loginAs,
    "LastLogin": lastLogin,
    "ActiveAcademicYearId": activeAcademicYearId,
    "ActiveAcademicYear": activeAcademicYear,
    "ActiveFinancialYearId": activeFinancialYearId,
    "ActiveFinancialYear": activeFinancialYear,
    "DisplayCode": displayCode,
    "RelationshipId": relationshipId,
    "IsHO": isHo,
    "IsSchool": isSchool,
    "IsCollege": isCollege,
    "IsSociety": isSociety,
    "BranchLogo": branchLogo,
    "GroupCode": groupCode,
    "SocietyCode": societyCode,
    "SchoolCode": schoolCode,
    "BranchCode": branchCode,
    "SchoolName": schoolName,
    "ProfilePic": profilePic,
    "MobileNo": mobileNo,
    "EmailId": emailId,
    "State": state,
    "Response": response,
    "Code": code,
    "DepartmentCode": departmentCode,
    "DesignationCode": designationCode,
    "SchoolAddress": schoolAddress,
  };
}
