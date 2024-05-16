// To parse this JSON data, do
//
//     final userWithdrawalWallet = userWithdrawalWalletFromJson(jsonString);

import 'dart:convert';

List<UserWithdrawalWallet> userWithdrawalWalletFromJson(String str) =>
    List<UserWithdrawalWallet>.from(
        json.decode(str).map((x) => UserWithdrawalWallet.fromJson(x)));

String userWithdrawalWalletToJson(List<UserWithdrawalWallet> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserWithdrawalWallet {
  String amount;
  DateTime date;
  String agentUsername;
  String accType;

  UserWithdrawalWallet({
    required this.amount,
    required this.date,
    required this.agentUsername,
    required this.accType,
  });

  factory UserWithdrawalWallet.fromJson(Map<String, dynamic> json) =>
      UserWithdrawalWallet(
        amount: json["Amount"],
        date: DateTime.parse(json["Date"]),
        agentUsername: json["Agent_Username"],
        accType: json["AccType"],
      );

  Map<String, dynamic> toJson() => {
    "Amount": amount,
    "Date":
    "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "Agent_Username": agentUsername,
    "AccType": accType,
  };
}
