import 'dart:convert';

CompanyBalance companyBalanceFromJson(String str) =>
    CompanyBalance.fromJson(json.decode(str));

class CompanyBalance {
  final double positiveTotalAmount;
  final double negativeTotalAmount;

  CompanyBalance(
      {required this.positiveTotalAmount, required this.negativeTotalAmount});

  factory CompanyBalance.fromJson(Map<String, dynamic> json) {
    return CompanyBalance(
      positiveTotalAmount: json['positiveTotalAmount']?.toDouble() ?? 0.0,
      negativeTotalAmount: json['negativeTotalAmount']?.toDouble() ?? 0.0,
    );
  }
}

// class CompanyBalance {
//   CompanyBalance({
//     required this.positiveTotalAmount,
//     required this.negativeTotalAmount,
//   });
//
//   double positiveTotalAmount;
//   double negativeTotalAmount;
//
//   factory CompanyBalance.fromJson(Map<String, dynamic> json) => CompanyBalance(
//     positiveTotalAmount: json["positiveTotalAmount"],
//     negativeTotalAmount: json["negativeTotalAmount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "positiveTotalAmount": positiveTotalAmount,
//     "negativeTotalAmount": negativeTotalAmount,
//   };
// }
