// To parse this JSON data, do
//
//     final loanWallet = loanWalletFromJson(jsonString);

import 'dart:convert';

LoanWallet loanWalletFromJson(String str) => LoanWallet.fromJson(json.decode(str));

String loanWalletToJson(LoanWallet data) => json.encode(data.toJson());

class LoanWallet {
  LoanWallet({
    required this.memberName,
    required this.amount,
    required this.date,
    required this.contributionType,
    required this.total,
  });

  String memberName;
  String amount;
  DateTime date;
  String contributionType;
  String total;

  factory LoanWallet.fromJson(Map<String, dynamic> json) => LoanWallet(
    memberName: json["Member_Name"],
    amount: json["Amount"],
    date: DateTime.parse(json["Date"]),
    contributionType: json["contribution_type"],
    total: json["Total"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "Member_Name": memberName,
    "Amount": amount,
    "Date": date.toIso8601String(),
    "contribution_type": contributionType,
    "Total": total,
  };
}
