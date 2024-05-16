// To parse this JSON data, do
//
//     final viewDailySavingsModel = viewDailySavingsModelFromJson(jsonString);

import 'dart:convert';

ViewDailySavingsModel viewDailySavingsModelFromJson(String str) => ViewDailySavingsModel.fromJson(json.decode(str));

String viewDailySavingsModelToJson(ViewDailySavingsModel data) => json.encode(data.toJson());

class ViewDailySavingsModel {
  String memberId;
  String fullname;
  String amount;
  String contributionType;
  String transactionType;

  ViewDailySavingsModel({
    required this.memberId,
    required this.fullname,
    required this.amount,
    required this.contributionType,
    required this.transactionType,
  });

  factory ViewDailySavingsModel.fromJson(Map<String, dynamic>? json) {
    return ViewDailySavingsModel(
      memberId: json?["MemberID"] ?? "",
      fullname: json?["Fullname"] ?? "",
      amount: json?["Amount"] ?? "",
      contributionType: json?["ContributionType"] ?? "",
      transactionType: json?["TransactionType"] ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
    "MemberID": memberId,
    "Fullname": fullname,
    "Amount": amount,
    "ContributionType": contributionType,
    "TransactionType": transactionType,
  };
}
