import 'package:gracewind_agent_new_app/app_export.dart';


class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<WithdrawalStatus> _allNotification = [];
  List<WithdrawalStatus> _filteredNotification = [];
  bool isLoading = false;
  List<WithdrawalStatus> get allNotification =>
      _filteredNotification.isNotEmpty
          ? _filteredNotification
          : _allNotification;

  Future<void> getNotification(String agentID) async {
    isLoading = true;
    notifyListeners();
    final response =
    await _notificationService.getAllNotifications(agentID);
    _allNotification = response;
    _filteredNotification = _allNotification;
    isLoading = false;
    notifyListeners();
  }

  void filterMembers(String query) {
    if (query.isNotEmpty) {
      _filteredNotification = _allNotification
          .where((allDailySavings) =>
      allDailySavings.fullname
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          allDailySavings.memberId
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredNotification = _allNotification;
    }
    notifyListeners();
  }

  WithdrawalStatus? findById(String id) {
    return _allNotification
        .firstWhere((dailySavings) => dailySavings.memberId == id);
  }
}
