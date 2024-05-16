import 'dart:convert';
import 'dart:io';
import 'package:gracewind_agent_new_app/model/viewDailySavingsModel.dart';
import 'package:gracewind_agent_new_app/utils/app_url.dart';
import 'package:http/http.dart' as http;

class DailyLoanRepaymentService {
  Future<List<ViewDailySavingsModel>> getAllDailyLoanRepayment(String agentID, String date) async {
    try {
      final response = await http.post(Uri.parse('${AppUrl.dailyLoan}?agentID=$agentID&tdate=$date'));
      //final response = await http.post(Uri.parse('https://dashboard.albarkaltd.com/mobileapi/dailyLoan.php?agentID=$agentID&tdate=$date'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => ViewDailySavingsModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load Loan repayment');
      }
    } on SocketException catch (_) {
      
      throw Exception('Failed to connect to the internet');
    } catch (e) {
      // handle other exceptions
      throw Exception('Failed to load Loan repayment');
    }
    // return an empty list if an exception occurs
  }
}
