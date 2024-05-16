import 'dart:convert';
import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/model/viewDailySavingsModel.dart';

import 'package:http/http.dart' as http;

class DailySavingsService {
  Future<List<ViewDailySavingsModel>> getAllDailySavings(
      String agentID, String date) async {
    try {
      final response = await http.post(Uri.parse('${AppUrl.dailySavings}?agentID=$agentID&tdate=$date}'
          // 'https://dashboard.albarkaltd.com/mobileapi/davilySavings.php?agentID=$agentID&tdate=$date'

      ));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map((e) => ViewDailySavingsModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load Savings');
      }
    } on SocketException {
      throw Exception('Failed to connect to server');
    }
  }
}
