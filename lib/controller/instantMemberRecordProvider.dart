import 'package:gracewind_agent_new_app/app_export.dart';

class InstantMemberRecordProvider extends ChangeNotifier {
  final InstantMemberRecordService _dailySavingsService =
      InstantMemberRecordService();
  List<InstantMemberData> _allMemberRecord = [];
  List<InstantMemberData> _filteredAllMemberRecord = [];
  bool isLoading = false;
  List<InstantMemberData> get allDailySavings =>
      _filteredAllMemberRecord.isNotEmpty
          ? _filteredAllMemberRecord
          : _allMemberRecord;

  Future<void> getAllMemberRecord() async {
    isLoading = true;
    notifyListeners();
    final response = await _dailySavingsService.getAllMember();
    _allMemberRecord = response;
    _filteredAllMemberRecord = _allMemberRecord;
    isLoading = false;
    notifyListeners();
  }

  void filterMembers(String query) {
    if (query.isNotEmpty) {
      _filteredAllMemberRecord = _allMemberRecord
          .where((allDailySavings) =>
              allDailySavings.fullname
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              allDailySavings.memberId
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredAllMemberRecord = _allMemberRecord;
    }
    notifyListeners();
  }

  InstantMemberData findById(String id) {
    return _allMemberRecord
        .firstWhere((dailySavings) => dailySavings.memberId == id);
  }
}
