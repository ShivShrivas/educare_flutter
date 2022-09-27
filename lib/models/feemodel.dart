// To parse this JSON data, do
//
//     final feeModel = feeModelFromJson(jsonString);

import 'dart:convert';

List<FeeModel> feeModelFromJson(String str) => List<FeeModel>.from(json.decode(str).map((x) => FeeModel.fromJson(x)));

String feeModelToJson(List<FeeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeeModel {
  FeeModel({
    required this.istallmentId,
    required this.amount,
    required this.status,
    required this.addStatus,
  });

  int istallmentId;
  double amount;
  String status;
  int addStatus;

  factory FeeModel.fromJson(Map<String, dynamic> json) => FeeModel(
    istallmentId: json["istallment_Id"],
    amount: json["amount"],
    status: json["status"],
    addStatus: json["addStatus"],
  );

  Map<String, dynamic> toJson() => {
    "istallment_Id": istallmentId,
    "amount": amount,
    "status": status,
    "addStatus": addStatus,
  };
}
