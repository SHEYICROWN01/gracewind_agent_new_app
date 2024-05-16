import 'package:http/http.dart' as http;
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:intl/intl.dart';

class DashboardViewModel extends ChangeNotifier {

  DashboardModels? _dashboardModels;

  DashboardModels? get dashboardModels => _dashboardModels;
   static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  Future<void> fetchDashboardData(String username ) async {
   
    final url = Uri.parse(AppUrl.dashboardApiEndPoint);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username});

    final response = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      _dashboardModels = DashboardModels.fromJson(parsedJson);
      notifyListeners();
    } else {
      throw Exception('Failed to fetch dashboard data');
    }
  }


}
