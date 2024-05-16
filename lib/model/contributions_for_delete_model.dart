// To parse this JSON data, do
//
//     final viewDailySavingsModel = viewDailySavingsModelFromJson(jsonString);

import 'dart:convert';

ContributionForDeleteModel viewDailySavingsModelFromJson(String str) =>
    ContributionForDeleteModel.fromJson(json.decode(str));

String viewDailySavingsModelToJson(ContributionForDeleteModel data) =>
    json.encode(data.toJson());

class ContributionForDeleteModel {
  ContributionForDeleteModel(
      {
        required this.id,
        required this.memberId,
        required this.fullname,
        required this.amount,
        required this.date,
        required this.contributionType,
        required this.branch,
        required this.agentId
      });

  String id;
  String memberId;
  String fullname;
  String amount;
  String date;
  String contributionType;
  String branch;
  String agentId;

  factory ContributionForDeleteModel.fromJson(Map<String, dynamic> json) =>
      ContributionForDeleteModel(
          id: json["Id"],
          memberId: json["MemberID"],
          fullname: json["Fullname"],
          amount: json["Amount"],
          date: json["Date"],
          contributionType: json["ContributionType"],
          branch: json["Branch"],
          agentId: json["AgentId"]);

  Map<String, dynamic> toJson() => {
    "Id":id,
    "MemberID": memberId,
    "Fullname": fullname,
    "Amount": amount,
    "Date": date,
    "ContributionType": contributionType,
    "Branch": branch,
    "AgentId": agentId
  };
}
