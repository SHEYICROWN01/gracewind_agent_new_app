import 'dart:convert';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  String memberId;
  String rate;
  String fullname;
  String branch;
  String picture;
  String phone;
  int totalSavings;

  Member({
    required this.memberId,
    required this.rate,
    required this.fullname,
    required this.branch,
    required this.picture,
    required this.phone,
    required this.totalSavings,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        memberId: json["member_ID"],
        rate: json["rate"],
        fullname: json["fullname"],
        branch: json["branch"],
        picture: json["picture"],
        phone: json["phone"],
        totalSavings: json["totalSavings"],
      );

  Map<String, dynamic> toJson() => {
        "member_ID": memberId,
        "rate": rate,
        "fullname": fullname,
        "branch": branch,
        "picture": picture,
        "phone": phone,
        "totalSavings": totalSavings,
      };
}
