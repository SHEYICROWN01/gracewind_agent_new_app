import 'dart:convert';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/model/getWithdrawalModel.dart';

import 'package:http/http.dart' as http;

class GetWithdrawalService {
  Future<List<GetWithdrawal>> getSavingsByDate() async {
    try {
      final response = await http.post(Uri.parse(AppUrl.getWithdrawal));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => GetWithdrawal.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load Savings');
      }
    } catch (e) {
      // handle other exceptions
      throw Exception('Failed to load Savings');
    }
  }
}
