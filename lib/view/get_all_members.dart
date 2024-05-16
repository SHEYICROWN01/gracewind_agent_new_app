
// // all_members.dart
// import 'package:albarka_agent_app/app_export.dart';
// import 'package:albarka_agent_app/controller/all_member_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class AllMembers extends StatefulWidget {
//   const AllMembers({Key? key}) : super(key: key);

//   @override
//   State<AllMembers> createState() => _AllMembersState();
// }

// class _AllMembersState extends State<AllMembers> {
//   final TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AllMemberBloc()..add(FetchAllMembersEvent()),
//       child: BlocBuilder<AllMemberBloc, AllMemberState>(
//         builder: (context, state) {
//           if (state is AllMemberLoadingState) {
//             return _buildLoading();
//           } else if (state is AllMemberLoadedState) {
//             return _buildLoaded(state);
//           } else if (state is AllMemberErrorState) {
//             return _buildError(state.error);
//           } else {
//             return _buildLoading();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildLoading() {
//     return Center(
//       child: SpinKitWave(
//         color: ColorConstant.primaryColor,
//         size: 30.0,
//       ),
//     );
//   }

//   Widget _buildLoaded(AllMemberLoadedState state) {
//     final memberProvider = context.read<AllMemberBloc>();

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: ColorConstant.primaryColor,
//         centerTitle: true,
//         title: const Text(
//           'Customers',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             tooltip: 'filter',
//             color: Colors.white,
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem<String>(
//                 value: 'Refresh',
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                     memberProvider.add(DeleteCacheAndFetchDataEvent());
//                   },
//                   child: const Text('Refresh Record'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           memberProvider.add(FetchAllMembersEvent());
//         },
//         child: Column(
//           children: [
//             _buildSearchBar(memberProvider),
//             Expanded(
//               child: _buildMemberGrid(state.allMembers),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar(AllMemberBloc memberProvider) {
//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       color: ColorConstant.primaryColor,
//       child: Card(
//         child: ListTile(
//           leading: const Icon(Icons.search, size: 20),
//           title: TextField(
//             controller: searchController,
//             onChanged: (query) {
//               memberProvider.add(FilterMembersEvent(query));
//             },
//             decoration: const InputDecoration(
//               hintText: "Search",
//               hintStyle: TextStyle(fontSize: 14),
//               border: InputBorder.none,
//             ),
//           ),
//           trailing: IconButton(
//             onPressed: () {
//               searchController.clear();
//             },
//             icon: const Icon(Icons.cancel, size: 20),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMemberGrid(List<Member> members) {
//     if (members.isEmpty) {
//       return const Center(
//         child: Text('No members available.'),
//       );
//     } else {
//       return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisExtent: 200.0,
//           crossAxisSpacing: 20.0,
//           mainAxisSpacing: 20.0,
//         ),
//         itemCount: members.length,
//         itemBuilder: (context, index) {
//           final member = members[index];
//           return GestureDetector(
//             onTap: () {
//               context.read<AllMemberBloc>().add(SelectedMemberEvent(member));
//               Navigator.pushNamed(context, RouteName.memberDetails);
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 decoration: AppDecoration.fillDeeporange800.copyWith(
//                   borderRadius: BorderRadius.circular(5.0),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Hero(
//                       tag: 'imageHero_${member.memberId}',
//                       child: ClipOval(
//                         child: CachedNetworkImage(
//                           imageUrl:
//                               'https://dashboard.albarkaltd.com/${member.picture}',
//                           placeholder: (context, url) => const CircularProgressIndicator(),
//                           errorWidget: (context, url, error) => const Icon(Icons.error),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     Text(
//                       member.fullname,
//                       style: AppStyle.txtSourceSansProSemiBold15WhiteA700,
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 5.0),
//                     Text(
//                       member.memberId,
//                       style: AppStyle.txtSourceSansProBold20,
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }

//   Widget _buildError(String error) {
//     return Center(
//       child: Text('Error: $error'),
//     );
//   }
// }