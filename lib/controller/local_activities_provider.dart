// ... (imports)

import 'dart:io';

import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/db_helper/getSavingsModel.dart';
import 'package:http/http.dart' as http;

class LocalActivitiesProvider extends ChangeNotifier {
  final List<getSavingsModel> _savingsList = [];
  final Map<int, bool> _processing = {};
  final BuildContext context;


  LocalActivitiesProvider(this.context);

  List<getSavingsModel> get savingsList => _savingsList;

  bool isProcessing(int index) {
    return _processing[index] ?? false;
  }

  Future<void> getData() async {
    final getAgentDetails = Provider.of<AuthViewModel>(context, listen: false);
    final savings = await DatabaseHelper.instance
        .getAllSavings(getAgentDetails.username.toString());
    _savingsList.clear();
    _savingsList.addAll(savings);
    notifyListeners();
  }

  Future<bool> processItem({
    required String memberId,
    required String memberName,
    required String amount,
    required String date,
    required String contributionType,
    required String branch,
    required String agentId,
    required String dateTime,
    required String transactionType,
    required int index,
  }) async {
    _processing[index] = true;
    notifyListeners();

    try {
      final url = Uri.parse(AppUrl.insertContribution);
      final request = http.MultipartRequest('POST', url);
      request.fields['member_id'] = memberId;
      request.fields['member_Name'] = memberName;
      request.fields['Amount'] = amount;
      request.fields['date'] = date;
      request.fields['contributionType'] = contributionType;
      request.fields['Branch'] = branch;
      request.fields['agentId'] = agentId;
      request.fields['date2'] = dateTime;
      request.fields['transactionType'] = transactionType;

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
       // Utils.toastMessage(responseString);
        _processing[index] = false;
        notifyListeners();
        return true; // Indicates success
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet');
    } catch (error) {
      debugPrint('Error during processItem: $error');
      throw Exception('An error occurred: $error');
    } finally {
      _processing[index] = false;
      notifyListeners();
    }
  }

}
