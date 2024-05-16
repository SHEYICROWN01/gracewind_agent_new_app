import 'dart:convert';

SavingsDetails savingsDetailsFromJson(String str) =>
    SavingsDetails.fromJson(json.decode(str));

String savingsDetailsToJson(SavingsDetails data) => json.encode(data.toJson());

class SavingsDetails {
  SavingsDetails({
    required this.memberId,
    required this.rate,
    required this.fullname,
    required this.branch,
    required this.representative,
    required this.picture,
    required this.totalSavings,
    required this.monthlyRate,
    required this.monthlyRatePercentage,
  });

  String memberId;
  String rate;
  String fullname;
  String branch;
  String representative;
  String picture;
  int totalSavings;
  double monthlyRate;
  int monthlyRatePercentage;

  factory SavingsDetails.fromJson(Map<String, dynamic> json) => SavingsDetails(
        memberId: json["member_ID"],
        rate: json["rate"],
        fullname: json["fullname"],
        branch: json["branch"],
        representative: json["representative"],
        picture: json["picture"],
        totalSavings: json["totalSavings"],
        monthlyRate: json["monthlyRate"].toDouble(),
        monthlyRatePercentage: json["monthlyRatePercentage"],
      );

  Map<String, dynamic> toJson() => {
        "member_ID": memberId,
        "rate": rate,
        "fullname": fullname,
        "branch": branch,
        "representative": representative,
        "picture": picture,
        "totalSavings": totalSavings,
        "monthlyRate": monthlyRate,
        "monthlyRatePercentage": monthlyRatePercentage,
      };
}
