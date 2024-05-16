import 'dart:convert';
import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/model/viewDailySavingsModel.dart';

import 'package:http/http.dart' as http;

class LoanByDateService {
  Future<List<ViewDailySavingsModel>> getSavingsByDate(
      String agentID, String date) async {
    try {
      final response = await http.post(Uri.parse(
        '${AppUrl.getDailyLoan}?agentID=$agentID&tdate=$date'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => ViewDailySavingsModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load Savings');
      }
    } on SocketException {
      // handle socket exception
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    } catch (e) {
      // handle other exceptions
      throw Exception('Failed to load Savings');
    }
  }
}
