// To parse this JSON data, do
//
//     final employeData = employeDataFromJson(jsonString);

import 'dart:convert';

EmployeData employeDataFromJson(String str) => EmployeData.fromJson(json.decode(str));

String employeDataToJson(EmployeData data) => json.encode(data.toJson());

class EmployeData {
  EmployeData({
    this.table,
  });

  List<EmpData>? table;

  factory EmployeData.fromJson(Map<String, dynamic> json) => EmployeData(
    table: List<EmpData>.from(json["Table"].map((x) => EmpData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(table!.map((x) => x.toJson())),
  };
}

class EmpData {
  EmpData({
    this.id,
    this.employeeCode,
    this.employeeId,
    this.registrationId,
    this.joiningDate,
    this.departmentCode,
    this.department,
    this.designationCode,
    this.designation,
    this.gradeCode,
    this.grade,
    this.machineId,
    this.employeeCode1,
    this.firstName,
    this.middelName,
    this.lastName,
    this.displayName,
    this.dateofBirth,
    this.gender,
    this.fatherName,
    this.meritalStatus,
    this.emergenceyContactNo,
    this.email,
    this.contactNo,
    this.aadhaarNo,
    this.employeePhotoPath,
    this.fullName,
    this.empAllocation,
    this.employeeType,
  });

  String? id;
  String? employeeCode;
  String? employeeId;
  int? registrationId;
  String? joiningDate;
  String? departmentCode;
  String? department;
  String? designationCode;
  String? designation;
  String? gradeCode;
  String? grade;
  String? machineId;
  String? employeeCode1;
  String? firstName;
  String? middelName;
  String? lastName;
  String? displayName;
  String? dateofBirth;
  String? gender;
  String? fatherName;
  String? meritalStatus;
  dynamic emergenceyContactNo;
  String? email;
  String? contactNo;
  String? aadhaarNo;
  dynamic employeePhotoPath;
  String? fullName;
  String? empAllocation;
  String? employeeType;

  factory EmpData.fromJson(Map<String, dynamic> json) => EmpData(
    id: json["Id"],
    employeeCode: json["EmployeeCode"],
    employeeId: json["EmployeeId"],
    registrationId: json["RegistrationId"],
    joiningDate: json["JoiningDate"],
    departmentCode: json["DepartmentCode"],
    department: json["Department"],
    designationCode: json["DesignationCode"],
    designation: json["Designation"],
    gradeCode: json["GradeCode"],
    grade: json["Grade"],
    machineId: json["MachineId"],
    employeeCode1: json["EmployeeCode1"],
    firstName: json["FirstName"],
    middelName: json["MiddelName"],
    lastName: json["LastName"],
    displayName: json["DisplayName"],
    dateofBirth: json["DateofBirth"],
    gender: json["Gender"],
    fatherName: json["FatherName"],
    meritalStatus: json["MeritalStatus"],
    emergenceyContactNo: json["EmergenceyContactNo"],
    email: json["Email"],
    contactNo: json["ContactNo"],
    aadhaarNo: json["AadhaarNo"],
    employeePhotoPath: json["EmployeePhotoPath"],
    fullName: json["FullName"],
    empAllocation: json["EmpAllocation"],
    employeeType: json["EmployeeType"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "EmployeeCode": employeeCode,
    "EmployeeId": employeeId,
    "RegistrationId": registrationId,
    "JoiningDate": joiningDate,
    "DepartmentCode": departmentCode,
    "Department": department,
    "DesignationCode": designationCode,
    "Designation": designation,
    "GradeCode": gradeCode,
    "Grade": grade,
    "MachineId": machineId,
    "EmployeeCode1": employeeCode1,
    "FirstName": firstName,
    "MiddelName": middelName,
    "LastName": lastName,
    "DisplayName": displayName,
    "DateofBirth": dateofBirth,
    "Gender": gender,
    "FatherName": fatherName,
    "MeritalStatus": meritalStatus,
    "EmergenceyContactNo": emergenceyContactNo,
    "Email": email,
    "ContactNo": contactNo,
    "AadhaarNo": aadhaarNo,
    "EmployeePhotoPath": employeePhotoPath,
    "FullName": fullName,
    "EmpAllocation": empAllocation,
    "EmployeeType": employeeType,
  };
}
