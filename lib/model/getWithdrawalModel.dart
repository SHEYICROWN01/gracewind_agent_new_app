import 'dart:convert';

List<GetWithdrawal> getWithdrawalFromJson(String str) =>
    List<GetWithdrawal>.from(
        json.decode(str).map((x) => GetWithdrawal.fromJson(x)));

String getWithdrawalToJson(List<GetWithdrawal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetWithdrawal {
  String id;
  String name;
  String memberId;
  String phone;
  String amount;
  String amount2;
  String accType;
  String actualAmount;
  String charges;
  String agentId;
  String approvedBy;
  String branch;
  String status2;
  DateTime date3;

  GetWithdrawal({
    required this.id,
    required this.name,
    required this.memberId,
    required this.phone,
    required this.amount,
    required this.amount2,
    required this.accType,
    required this.actualAmount,
    required this.charges,
    required this.agentId,
    required this.approvedBy,
    required this.branch,
    required this.status2,
    required this.date3,
  });

  factory GetWithdrawal.fromJson(Map<String, dynamic> json) => GetWithdrawal(
        id: json["id"],
        name: json["name"],
        memberId: json["member_id"],
        phone: json["phone"],
        amount: json["amount"],
        amount2: json["amount2"],
        accType: json["acc_type"],
        actualAmount: json["actual_amount"],
        charges: json["charges"],
        agentId: json["agent_id"],
        approvedBy: json["approved_by"],
        branch: json["branch"],
        status2: json["status2"],
        date3: DateTime.parse(json["date3"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "member_id": memberId,
        "phone": phone,
        "amount": amount,
        "amount2": amount2,
        "acc_type": accType,
        "actual_amount": actualAmount,
        "charges": charges,
        "agent_id": agentId,
        "approved_by": approvedBy,
        "branch": branch,
        "status2": status2,
        "date3": date3.toIso8601String(),
      };
}
