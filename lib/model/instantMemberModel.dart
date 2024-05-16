import 'dart:convert';

InstantMemberData instantMemberDataFromJson(String str) =>
    InstantMemberData.fromJson(json.decode(str));

String instantMemberDataToJson(InstantMemberData data) =>
    json.encode(data.toJson());

class InstantMemberData {
  InstantMemberData({
    required this.memberId,
    required this.fullname,
    required this.totalSavings,
  });

  String memberId;
  String fullname;
  int totalSavings;

  factory InstantMemberData.fromJson(Map<String, dynamic> json) =>
      InstantMemberData(
        memberId: json["member_ID"],
        fullname: json["fullname"],
        totalSavings: json["totalSavings"],
      );

  Map<String, dynamic> toJson() => {
        "member_ID": memberId,
        "fullname": fullname,
        "totalSavings": totalSavings,
      };
}
