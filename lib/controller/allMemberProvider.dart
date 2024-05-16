import 'dart:io';

import 'package:gracewind_agent_new_app/model/memberModel.dart';
import 'package:gracewind_agent_new_app/service/allMemberService.dart';
import 'package:gracewind_agent_new_app/utils/alertMessage.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SelectedMember {
  Member member;
  SelectedMember(this.member);
}

class AllMemberProvider extends ChangeNotifier {
  final AllMemberService _allMemberService = AllMemberService();
  List<Member>? _allMember = [];
  List<Member> _filteredMembers = [];
  bool isLoading = false;
  SelectedMember? _selectedMember;

  // Method to set the selected member
  void setSelectedMember(Member member) {
    _selectedMember = SelectedMember(member);
    notifyListeners();
  }

  SelectedMember? get selectedMember => _selectedMember;

  // Getter to return all members, filtered if necessary
  List<Member> get allMember =>
      _filteredMembers.isNotEmpty ? _filteredMembers : _allMember!;

  // Method to fetch all members from the API or cache
  Future<void> getAllMembers() async {
    await APICacheManager().isAPICacheKeyExist('Member');
    isLoading = true;
    notifyListeners();

    try {
      final response = await _allMemberService.getAllMember();
      _allMember = response;
      _filteredMembers = _allMember!;
    } on SocketException {
      Utils.toastMessage('No connectivity');
      // Return null or handle the error as needed
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to filter members based on a search query
  void filterMembers(String query) {
    if (query.isNotEmpty) {
      _filteredMembers = _allMember!
          .where((allMember) =>
              allMember.fullname
                  .toLowerCase()
                  .contains(query.toLowerCase().trim()) ||
              allMember.memberId
                  .toLowerCase()
                  .contains(query.toLowerCase().trim()))
          .toList();
    } else {
      _filteredMembers = _allMember!;
    }
    notifyListeners();
  }

  // Method to find a member by ID
  Member? findById(String id) {
    return _allMember!.firstWhere((member) => member.memberId == id);
  }

  // Method to delete the cache for 'Member' and fetch new data
  Future<void> deleteCacheAndFetchData() async {
    await APICacheManager().deleteCache('Member');
    await getAllMembers();
  }
}
