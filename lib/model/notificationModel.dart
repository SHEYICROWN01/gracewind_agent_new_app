import 'dart:convert';

WithdrawalStatus withdrawalStatusFromJson(String str) =>
    WithdrawalStatus.fromJson(json.decode(str));

String withdrawalStatusToJson(WithdrawalStatus data) =>
    json.encode(data.toJson());

class WithdrawalStatus {
  WithdrawalStatus({
    required this.memberId,
    required this.fullname,
    required this.approvedBy,
    required this.status,
    required this.amount,
    required this.date,
  });

  String memberId;
  String fullname;
  String approvedBy;
  String status;
  String amount;
  DateTime date;

  factory WithdrawalStatus.fromJson(Map<String, dynamic> json) =>
      WithdrawalStatus(
        memberId: json["MemberID"],
        fullname: json["Fullname"],
        approvedBy: json["Approved by"],
        status: json["Status"],
        amount: json["Amount"],
        date: DateTime.parse(json["Date"]),
      );

  Map<String, dynamic> toJson() => {
        "MemberID": memberId,
        "Fullname": fullname,
        "Approved by": approvedBy,
        "Status": status,
        "Amount": amount,
        "Date": date.toIso8601String(),
      };
}
