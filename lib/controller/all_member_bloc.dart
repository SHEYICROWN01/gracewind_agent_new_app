// // all_member_bloc.dart
// import 'dart:io';

// import 'package:albarka_agent_app/model/memberModel.dart';
// import 'package:albarka_agent_app/service/allMemberService.dart';
// import 'package:api_cache_manager/api_cache_manager.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // Events
// abstract class AllMemberEvent {}

// class FetchAllMembersEvent extends AllMemberEvent {}

// class FilterMembersEvent extends AllMemberEvent {
//   final String query;

//   FilterMembersEvent(this.query);
// }

// class DeleteCacheAndFetchDataEvent extends AllMemberEvent {}

// class SelectedMemberEvent extends AllMemberEvent {
//   final Member member;

//   SelectedMemberEvent(this.member);
// }

// // States
// abstract class AllMemberState {}

// class AllMemberInitialState extends AllMemberState {}

// class AllMemberLoadingState extends AllMemberState {}

// class AllMemberLoadedState extends AllMemberState {
//   final List<Member> allMembers;

//   AllMemberLoadedState(this.allMembers);
// }

// class AllMemberErrorState extends AllMemberState {
//   final String error;

//   AllMemberErrorState(this.error);
// }

// // BLoC
// class AllMemberBloc extends Bloc<AllMemberEvent, AllMemberState> {
//   final AllMemberService _allMemberService = AllMemberService();
//   List<Member>? _allMember = [];
//   List<Member> _filteredMembers = [];
//   Member? _selectedMember;

//  AllMemberBloc() : super(AllMemberInitialState()) {
//     // Register a handler for FetchAllMembersEvent
//     on<FetchAllMembersEvent>((event, emit) async {
//       try {
//         emit(AllMemberLoadingState());
//         final response = await _allMemberService.getAllMember();
//         _allMember = response;
//         _filteredMembers = _allMember!;
//         emit(AllMemberLoadedState(_allMember!));
//       } on SocketException {
//         emit(AllMemberErrorState('No connectivity'));
//       }
//     });
//   }
//   Future<AllMemberState> _fetchAllMembers() async {
//     try {
//       final response = await _allMemberService.getAllMember();
//       _allMember = response;
//       _filteredMembers = _allMember!;
//       return AllMemberLoadedState(_allMember!);
//     } on SocketException {
//       return AllMemberErrorState('No connectivity');
//     }
//   }

//   void _filterMembers(String query) {
//     if (query.isNotEmpty) {
//       _filteredMembers = _allMember!
//           .where((allMember) =>
//               allMember.fullname.toLowerCase().contains(query.toLowerCase().trim()) ||
//               allMember.memberId.toLowerCase().contains(query.toLowerCase().trim()))
//           .toList();
//     } else {
//       _filteredMembers = _allMember!;
//     }
//   }

//   Future<void> _deleteCacheAndFetchData() async {
//     await APICacheManager().deleteCache('Member');
//     await _fetchAllMembers();
//   }

//   Member? get selectedMember => _selectedMember;
// }
