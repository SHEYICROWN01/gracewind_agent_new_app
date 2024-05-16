import 'package:gracewind_agent_new_app/app_export.dart';

class DailyLoanRepaymentProvider extends ChangeNotifier {
  final DailyLoanRepaymentService _dailyLoanRepaymentService =
      DailyLoanRepaymentService();
  List<ViewDailySavingsModel> _allDailyLoanRepayment = [];
  List<ViewDailySavingsModel> _filteredDailyLoanRepayment = [];
  bool isLoading = false;

  List<ViewDailySavingsModel> get allDailyLoanRepayment =>
      _filteredDailyLoanRepayment.isNotEmpty
          ? _filteredDailyLoanRepayment
          : _allDailyLoanRepayment;

  Future<void> getDailyLoanRepayment(String agentId, String date) async {
    isLoading = true;
    notifyListeners();
    final response = await _dailyLoanRepaymentService.getAllDailyLoanRepayment(
        agentId, date);
    _allDailyLoanRepayment = response;
    _filteredDailyLoanRepayment = _allDailyLoanRepayment;
    isLoading = false;
    notifyListeners();
  }

  void filterDailyLoanRepayment(String query) {
    if (query.isNotEmpty) {
      _filteredDailyLoanRepayment = _allDailyLoanRepayment
          .where((allDailyLoan) =>
              allDailyLoan.fullname
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              allDailyLoan.memberId.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredDailyLoanRepayment = _allDailyLoanRepayment;
    }
    notifyListeners();
  }

  ViewDailySavingsModel? findById(String id) {
    return _allDailyLoanRepayment
        .firstWhere((dailyLoan) => dailyLoan.memberId == id);
  }
}
