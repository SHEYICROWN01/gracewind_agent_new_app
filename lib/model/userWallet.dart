// To parse this JSON data, do
//
//     final userWallet = userWalletFromJson(jsonString);

import 'dart:convert';

UserWallet userWalletFromJson(String str) => UserWallet.fromJson(json.decode(str));

String userWalletToJson(UserWallet data) => json.encode(data.toJson());

class UserWallet {
  String memberName;
  String amount;
  DateTime date;
  String contributionType;
  int total;
  String agentId;
  String agentUsername;

  UserWallet({
    required this.memberName,
    required this.amount,
    required this.date,
    required this.contributionType,
    required this.total,
    required this.agentId,
    required this.agentUsername,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    memberName: json["Member_Name"],
    amount: json["Amount"],
    date: DateTime.parse(json["Date"]),
    contributionType: json["contribution_type"],
    total: json["Total"],
    agentId: json["agent_id"],
    agentUsername: json["agent_username"],
  );

  Map<String, dynamic> toJson() => {
    "Member_Name": memberName,
    "Amount": amount,
    "Date": date.toIso8601String(),
    "contribution_type": contributionType,
    "Total": total,
    "agent_id": agentId,
    "agent_username": agentUsername,
  };
}
