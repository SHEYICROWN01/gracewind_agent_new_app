

import 'dart:convert';

UpdateModel updateModelFromJson(String str) => UpdateModel.fromJson(json.decode(str));

String updateModelToJson(UpdateModel data) => json.encode(data.toJson());

class UpdateModel {
  UpdateModel({
    required this.memberId,
    required this.fullname,
    required this.lastname,
    required this.rate,
    required this.phone,
    required this.marital,
    required this.occupation,
    required this.address,
    required this.picture,
  });

  String  memberId;
  String  fullname;
  String ?lastname;
  String ?rate;
  String ?phone;
  String ?marital;
  String ?occupation;
  String ?address;
  String ? picture;

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
    memberId: json["Member_ID"],
    fullname: json["fullname"],
    lastname: json["lastname"],
    rate: json["rate"],
    phone: json["phone"],
    marital: json["marital"],
    occupation: json["occupation"],
    address: json["address"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "Member_ID": memberId,
    "fullname": fullname,
    "lastname": lastname,
    "rate": rate,
    "phone": phone,
    "marital": marital,
    "occupation": occupation,
    "address": address,
    "picture": picture,
  };
}
