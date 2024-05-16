import 'dart:convert';

DashboardModels dashboardModelsFromJson(String str) =>
    DashboardModels.fromJson(json.decode(str));

String dashboardModelsToJson(DashboardModels data) =>
    json.encode(data.toJson());

class DashboardModels {
  DashboardModels({
    required this.totalDailySavings,
    required this.totalLoanRepayment,
    required this.totalCash,
    required this.agentId,
    required this.agentPicture,
  });

  String totalDailySavings;
  String totalLoanRepayment;
  String totalCash;
  String agentId;
  String agentPicture;

  factory DashboardModels.fromJson(Map<String, dynamic> json) =>
      DashboardModels(
        totalDailySavings: json["totalDailySavings"].toString(),
        totalLoanRepayment: json["totalLoanRepayment"].toString(),
        totalCash: json["totalCash"].toString(),
        agentId: json["agentId"].toString(),
        agentPicture: json["agentPicture"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "totalDailySavings": totalDailySavings,
        "totalLoanRepayment": totalLoanRepayment,
        "totalCash": totalCash,
        "agentId": agentId,
        "agentPicture": agentPicture,
      };
}
