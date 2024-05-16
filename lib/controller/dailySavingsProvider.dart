import 'package:gracewind_agent_new_app/app_export.dart';

class DailySavingsProvider extends ChangeNotifier {
  final DailySavingsService _dailySavingsService = DailySavingsService();
  List<ViewDailySavingsModel> _allDailySavings = [];
  List<ViewDailySavingsModel> _filteredDailySavings = [];
  bool isLoading = false;
  List<ViewDailySavingsModel> get allDailySavings =>
      _filteredDailySavings.isNotEmpty
          ? _filteredDailySavings
          : _allDailySavings;

  Future<void> getDailySavings(String agentID, String date) async {
    isLoading = true;
    notifyListeners();
    final response =
        await _dailySavingsService.getAllDailySavings(agentID, date);
    _allDailySavings = response;
    _filteredDailySavings = _allDailySavings;
    isLoading = false;
    notifyListeners();
  }

  void filterMembers(String query) {
    if (query.isNotEmpty) {
      _filteredDailySavings = _allDailySavings
          .where((allDailySavings) =>
              allDailySavings.fullname
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              allDailySavings.memberId
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredDailySavings = _allDailySavings;
    }
    notifyListeners();
  }

  ViewDailySavingsModel? findById(String id) {
    return _allDailySavings
        .firstWhere((dailySavings) => dailySavings.memberId == id);
  }
}
