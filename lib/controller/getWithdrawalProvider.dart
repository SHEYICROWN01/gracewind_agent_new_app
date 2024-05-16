import 'package:gracewind_agent_new_app/app_export.dart';

class GetWithdrawalProvider extends ChangeNotifier {
  final GetWithdrawalService _loanByDateService = GetWithdrawalService();
  List<GetWithdrawal> _allDailySavings = [];
  List<GetWithdrawal> _filteredDailySavings = [];
  bool isLoading = false;
  List<GetWithdrawal> get allDailySavings => _filteredDailySavings.isNotEmpty
      ? _filteredDailySavings
      : _allDailySavings;

  Future<void> getDailySavings() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _loanByDateService.getSavingsByDate();
      _allDailySavings = response;
      _filteredDailySavings = _allDailySavings;
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterMembers(String query) {
    if (query.isNotEmpty) {
      _filteredDailySavings = _allDailySavings
          .where((allDailySavings) =>
              allDailySavings.name
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

  GetWithdrawal findById(String id) {
    return _allDailySavings
        .firstWhere((dailySavings) => dailySavings.memberId == id);
  }
}
