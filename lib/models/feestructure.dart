// To parse this JSON data, do
//
//     final feeInstallmentData = feeInstallmentDataFromJson(jsonString);

import 'dart:convert';

FeeInstallmentData feeInstallmentDataFromJson(String str) => FeeInstallmentData.fromJson(json.decode(str));

String feeInstallmentDataToJson(FeeInstallmentData data) => json.encode(data.toJson());

class FeeInstallmentData {
  FeeInstallmentData({
    required this.feeInstallment,
    required this.feeStructure,
    required this.feeDues,
    required this.feeDepositHistory,
  });

  List<FeeInstallment> feeInstallment;
  List<FeeStructure> feeStructure;
  List<FeeDue> feeDues;
  List<FeeDepositHistory> feeDepositHistory;

  factory FeeInstallmentData.fromJson(Map<String, dynamic> json) => FeeInstallmentData(
    feeInstallment: List<FeeInstallment>.from(json["FeeInstallment"].map((x) => FeeInstallment.fromJson(x))),
    feeStructure: List<FeeStructure>.from(json["FeeStructure"].map((x) => FeeStructure.fromJson(x))),
    feeDues: List<FeeDue>.from(json["FeeDues"].map((x) => FeeDue.fromJson(x))),
    feeDepositHistory: List<FeeDepositHistory>.from(json["FeeDepositHistory"].map((x) => FeeDepositHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "FeeInstallment": List<dynamic>.from(feeInstallment.map((x) => x.toJson())),
    "FeeStructure": List<dynamic>.from(feeStructure.map((x) => x.toJson())),
    "FeeDues": List<dynamic>.from(feeDues.map((x) => x.toJson())),
    "FeeDepositHistory": List<dynamic>.from(feeDepositHistory.map((x) => x.toJson())),
  };
}

class FeeDepositHistory {
  FeeDepositHistory({
    this.rno,
    this.studentCode,
    this.installmentCode,
    this.installmentName,
    this.paidStatus,
    this.dueStatus,
    this.dueDate,
    this.feeDepositDate,
    this.recptNo,
    this.amount,
    this.concessionAmt,
    this.payableAmt,
    this.paid,
  });

  int? rno;
  String? studentCode;
  String? installmentCode;
  String? installmentName;
  String? paidStatus;
  String? dueStatus;
  String? dueDate;
  String? feeDepositDate;
  String? recptNo;
  double? amount;
  double? concessionAmt;
  double? payableAmt;
  double? paid;

  factory FeeDepositHistory.fromJson(Map<String, dynamic> json) => FeeDepositHistory(
    rno: json["rno"],
    studentCode: json["StudentCode"],
    installmentCode: json["InstallmentCode"],
    installmentName: json["InstallmentName"],
    paidStatus: json["PaidStatus"],
    dueStatus: json["DueStatus"],
    dueDate: json["DueDate"],
    feeDepositDate: json["FeeDepositDate"],
    recptNo: json["RecptNo"],
    amount: json["Amount"],
    concessionAmt: json["ConcessionAmt"],
    payableAmt: json["PayableAmt"],
    paid: json["Paid"],
  );

  Map<String, dynamic> toJson() => {
    "rno": rno,
    "StudentCode": studentCode,
    "InstallmentCode": installmentCode,
    "InstallmentName": installmentName,
    "PaidStatus": paidStatus,
    "DueStatus": dueStatus,
    "DueDate": dueDate,
    "FeeDepositDate": feeDepositDate,
    "RecptNo": recptNo,
    "Amount": amount,
    "ConcessionAmt": concessionAmt,
    "PayableAmt": payableAmt,
    "Paid": paid,
  };
}

class FeeDue {
  FeeDue({
    this.dueAmount,
    this.dueDate,
  });

  double? dueAmount;
  String? dueDate;

  factory FeeDue.fromJson(Map<String, dynamic> json) => FeeDue(
    dueAmount: json["DueAmount"],
    dueDate: json["DueDate"],
  );

  Map<String, dynamic> toJson() => {
    "DueAmount": dueAmount,
    "DueDate": dueDate,
  };
}

class FeeInstallment {
  FeeInstallment({
    required this.chk,
    this.srNo,
    this.studentCode,
    this.installmentCode,
    this.installmentName,
    this.dueStatus,
    this.dueDate,
    this.netPayable,
    required this.feeHeadDetails,
  });

  bool chk;
  String? srNo;
  String? studentCode;
  String? installmentCode;
  String? installmentName;
  String? dueStatus;
  String? dueDate;
  String? netPayable;
  List<FeeHeadDetail> feeHeadDetails;

  factory FeeInstallment.fromJson(Map<String, dynamic> json) => FeeInstallment(
    chk: json["Chk"],
    srNo: json["SrNo"],
    studentCode: json["StudentCode"],
    installmentCode: json["InstallmentCode"],
    installmentName: json["InstallmentName"],
    dueStatus: json["DueStatus"],
    dueDate: json["DueDate"],
    netPayable: json["NetPayable"],
    feeHeadDetails: List<FeeHeadDetail>.from(json["FeeHeadDetails"].map((x) => FeeHeadDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Chk": chk,
    "SrNo": srNo,
    "StudentCode": studentCode,
    "InstallmentCode": installmentCode,
    "InstallmentName": installmentName,
    "DueStatus": dueStatus,
    "DueDate": dueDate,
    "NetPayable": netPayable,
    "FeeHeadDetails": List<dynamic>.from(feeHeadDetails.map((x) => x.toJson())),
  };
}

class FeeHeadDetail {
  FeeHeadDetail({
    this.feeHeadCode,
    this.feeHeadName,
    this.headType,
    this.month,
    this.frequency,
    this.amount,
    this.concessionAmt,
    this.payableAmt,
    this.paid,
    this.paidStatus,
    this.netPayable,
  });

  String? feeHeadCode;
  String? feeHeadName;
  String? headType;
  String? month;
  String? frequency;
  String? amount;
  String? concessionAmt;
  String? payableAmt;
  String? paid;
  String? paidStatus;
  String? netPayable;

  factory FeeHeadDetail.fromJson(Map<String, dynamic> json) => FeeHeadDetail(
    feeHeadCode: json["FeeHeadCode"],
    feeHeadName: json["FeeHeadName"],
    headType: json["HeadType"],
    month: json["Month"],
    frequency: json["Frequency"],
    amount: json["Amount"],
    concessionAmt: json["ConcessionAmt"],
    payableAmt: json["PayableAmt"],
    paid: json["Paid"],
    paidStatus: json["PaidStatus"],
    netPayable: json["NetPayable"],
  );

  Map<String, dynamic> toJson() => {
    "FeeHeadCode": feeHeadCode,
    "FeeHeadName": feeHeadName,
    "HeadType": headType,
    "Month": month,
    "Frequency": frequency,
    "Amount": amount,
    "ConcessionAmt": concessionAmt,
    "PayableAmt": payableAmt,
    "Paid": paid,
    "PaidStatus": paidStatus,
    "NetPayable": netPayable,
  };
}

class FeeStructure {
  FeeStructure({
    required this.rno,
    this.studentCode,
    this.installmentCode,
    this.installmentName,
    this.feeHeadCode,
    this.feeHeadName,
    this.headType,
    this.month,
    this.frequency,
    this.amount,
    this.concessionAmt,
    this.payableAmt,
    this.paid,
    this.netPayable,
    this.dueStatus,
    this.paidStatus,
    this.dueDate,
    required this.chk,
  });

  int rno;
  String? studentCode;
  String? installmentCode;
  String? installmentName;
  String? feeHeadCode;
  String? feeHeadName;
  String? headType;
  String? month;
  String? frequency;
  double? amount;
  double? concessionAmt;
  double? payableAmt;
  double? paid;
  double? netPayable;
  String? dueStatus;
  String? paidStatus;
  String? dueDate;
  bool chk;

  factory FeeStructure.fromJson(Map<String, dynamic> json) => FeeStructure(
    rno: json["rno"],
    studentCode: json["StudentCode"],
    installmentCode: json["InstallmentCode"],
    installmentName: json["InstallmentName"],
    feeHeadCode: json["FeeHeadCode"],
    feeHeadName: json["FeeHeadName"],
    headType: json["HeadType"],
    month: json["Month"],
    frequency: json["Frequency"],
    amount: json["Amount"],
    concessionAmt: json["ConcessionAmt"],
    payableAmt: json["PayableAmt"],
    paid: json["Paid"],
    netPayable: json["NetPayable"],
    dueStatus: json["DueStatus"],
    paidStatus: json["PaidStatus"],
    dueDate: json["DueDate"],
    chk: json["Chk"],
  );

  Map<String, dynamic> toJson() => {
    "rno": rno,
    "StudentCode": studentCode,
    "InstallmentCode": installmentCode,
    "InstallmentName": installmentName,
    "FeeHeadCode": feeHeadCode,
    "FeeHeadName": feeHeadName,
    "HeadType": headType,
    "Month": month,
    "Frequency": frequency,
    "Amount": amount,
    "ConcessionAmt": concessionAmt,
    "PayableAmt": payableAmt,
    "Paid": paid,
    "NetPayable": netPayable,
    "DueStatus": dueStatus,
    "PaidStatus": paidStatus,
    "DueDate": dueDate,
    "Chk": chk,
  };
}
