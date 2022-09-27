// To parse this JSON data, do
//
//     final leaveList = leaveListFromJson(jsonString);

import 'dart:convert';

List<LeaveListApprove> leaveListFromJson(String str) => List<LeaveListApprove>.from(json.decode(str).map((x) => LeaveListApprove.fromJson(x)));

String leaveListToJson(List<LeaveListApprove> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveListApprove {
  LeaveListApprove({
    required this.resName,
    required this.empName,
    required this.transId,
    required this.employeeCode,
    required this.inAbsenceResponsibleEmployeeId,
    required this.designationCode,
    required this.departmentCode,
    required this.leaveFrom,
    required this.leaveTo,
    required this.leaveReason,
    required this.remarks,
    required this.communicationPrefferedMode,
    required this.onLeaveContactNo,
    required this.onLeaveAddress,
    required this.isLeaveRecieved,
    this.isApproved,
    required this.status,
    required this.transectionId,
    required this.voucherType,
    this.voucherDate,
    this.voucherNo,
    this.noOfDaysApproved,
    required this.leaveFor,
    required this.approvedFrom,
    required this.approvedTo,
    this.approvedBy,
    this.approvedBye,
    this.approvedOn,
    required this.relationshipId,
    required this.fyId,
    required this.sessionId,
    required this.createdOn,
    required this.createdBy,
    this.updatedOn,
    this.updatedBy,
    required this.isDeleted,
    required this.firstApprovalStatus,
    required this.secondApprovalStatus,
    required this.firstLevelEmpName,
    required this.secondLevelEmpName,
    this.empApprovalLevel,
  });

  String resName;
  String empName;
  String transId;
  String employeeCode;
  String inAbsenceResponsibleEmployeeId;
  String designationCode;
  String departmentCode;
  String leaveFrom;
  String leaveTo;
  String leaveReason;
  String remarks;
  String communicationPrefferedMode;
  String onLeaveContactNo;
  String onLeaveAddress;
  bool isLeaveRecieved;
  dynamic isApproved;
  String status;
  String transectionId;
  String voucherType;
  dynamic voucherDate;
  dynamic voucherNo;
  dynamic noOfDaysApproved;
  String leaveFor;
  String approvedFrom;
  String approvedTo;
  dynamic approvedBy;
  dynamic approvedBye;
  dynamic approvedOn;
  int relationshipId;
  int fyId;
  int sessionId;
  DateTime createdOn;
  int createdBy;
  dynamic updatedOn;
  dynamic updatedBy;
  bool isDeleted;
  String firstApprovalStatus;
  String secondApprovalStatus;

  String firstLevelEmpName;
  String secondLevelEmpName;
  dynamic empApprovalLevel;

  factory LeaveListApprove.fromJson(Map<String, dynamic> json) => LeaveListApprove(
    resName: json["ResName"],
    empName: json["EmpName"],
    transId: json["TransId"],
    employeeCode: json["EmployeeCode"],
    inAbsenceResponsibleEmployeeId: json["InAbsenceResponsibleEmployeeId"],
    designationCode: json["DesignationCode"],
    departmentCode: json["DepartmentCode"],
    leaveFrom: json["LeaveFrom"],
    leaveTo: json["LeaveTo"],
    leaveReason: json["LeaveReason"],
    remarks: json["Remarks"],
    communicationPrefferedMode: json["CommunicationPrefferedMode"],
    onLeaveContactNo: json["OnLeaveContactNo"],
    onLeaveAddress: json["OnLeaveAddress"],
    isLeaveRecieved: json["IsLeaveRecieved"],
    isApproved: json["IsApproved"],
    status: json["Status"],
    transectionId: json["TransectionId"],
    voucherType: json["VoucherType"],
    voucherDate: json["VoucherDate"],
    voucherNo: json["VoucherNo"],
    noOfDaysApproved: json["NoOfDaysApproved"],
    leaveFor: json["LeaveFor"],
    approvedFrom: json["ApprovedFrom"],
    approvedTo: json["ApprovedTo"],
    approvedBy: json["ApprovedBy"],
    approvedBye: json["ApprovedBye"],
    approvedOn: json["ApprovedOn"],
    relationshipId: json["RelationshipId"],
    fyId: json["FYId"],
    sessionId: json["SessionId"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    createdBy: json["CreatedBy"],
    updatedOn: json["UpdatedOn"],
    updatedBy: json["UpdatedBy"],
    isDeleted: json["IsDeleted"],
    firstApprovalStatus: json["FirstApprovalStatus"],
    secondApprovalStatus: json["SecondApprovalStatus"],
    firstLevelEmpName: json["FirstLevelEmpName"],
    secondLevelEmpName: json["SecondLevelEmpName"],
    empApprovalLevel: json["EmpApprovalLevel"],
  );

  Map<String, dynamic> toJson() => {
    "ResName": resName,
    "EmpName": empName,
    "TransId": transId,
    "EmployeeCode": employeeCode,
    "InAbsenceResponsibleEmployeeId": inAbsenceResponsibleEmployeeId,
    "DesignationCode": designationCode,
    "DepartmentCode": departmentCode,
    "LeaveFrom": leaveFrom,
    "LeaveTo": leaveTo,
    "LeaveReason": leaveReason,
    "Remarks": remarks,
    "CommunicationPrefferedMode": communicationPrefferedMode,
    "OnLeaveContactNo": onLeaveContactNo,
    "OnLeaveAddress": onLeaveAddress,
    "IsLeaveRecieved": isLeaveRecieved,
    "IsApproved": isApproved,
    "Status": status,
    "TransectionId": transectionId,
    "VoucherType": voucherType,
    "VoucherDate": voucherDate,
    "VoucherNo": voucherNo,
    "NoOfDaysApproved": noOfDaysApproved,
    "LeaveFor": leaveFor,
    "ApprovedFrom": approvedFrom,
    "ApprovedTo": approvedTo,
    "ApprovedBy": approvedBy,
    "ApprovedBye": approvedBye,
    "ApprovedOn": approvedOn,
    "RelationshipId": relationshipId,
    "FYId": fyId,
    "SessionId": sessionId,
    "CreatedOn": createdOn.toIso8601String(),
    "CreatedBy": createdBy,
    "UpdatedOn": updatedOn,
    "UpdatedBy": updatedBy,
    "IsDeleted": isDeleted,
    "FirstApprovalStatus": firstApprovalStatus,
    "SecondApprovalStatus": secondApprovalStatus,
    "FirstLevelEmpName": firstLevelEmpName,
    "SecondLevelEmpName": secondLevelEmpName,
    "EmpApprovalLevel": empApprovalLevel,
  };
}
