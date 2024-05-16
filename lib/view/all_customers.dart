// ignore: file_names
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllMembers extends StatefulWidget {
  const AllMembers({super.key});

  @override
  State<AllMembers> createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  TextEditingController searchController = TextEditingController();
  final AllMemberProvider deleteRecord = AllMemberProvider();

  @override
  void initState() {
    super.initState();
    //Provider.of<AllMemberProvider>(context, listen: false).getAllMembers();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllMemberProvider>(context, listen: false).getAllMembers();
    });
  }

  @override
  void dispose() {
    deleteRecord.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    try {
      await deleteRecord.getAllMembers();
      setState(() {});
    } catch (error) {
      // Handle the error, e.g., show an error message.
      debugPrint('Error refreshing data: $error');
    }
  }

  // Future<void> _onRefresh() async {
  //   await _refreshData();
  // }

  @override
  Widget build(BuildContext context) {
    final deleteRecord = Provider.of<AllMemberProvider>(context, listen: false);
    final memberProvider = Provider.of<AllMemberProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.primaryColor,
        centerTitle: true,

        title: const Text(
          'Customers',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, RouteName.dashboardView);
              },
              icon: const Icon(null),
              label: Text(
                'Move to dashboard',
                style: TextStyle(color: ColorConstant.primaryColor),
              )),
          PopupMenuButton<String>(
            iconColor: Colors.white,
            tooltip: 'filter',
            color: ColorConstant.primaryColor,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Refresh',
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showRefreshConfirmation(context, deleteRecord);
                    },
                    child: const Text('Refresh Record', style: TextStyle(color: Colors.white),)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(memberProvider),
          Expanded(
            child: _buildMemberGrid(memberProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AllMemberProvider memberProvider) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: ColorConstant.primaryColor,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search, size: 10),
          title: TextField(
            controller: searchController,
            onChanged: (query) {
              memberProvider.filterMembers(query);
            },
            decoration: const InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(fontSize: 7),
              border: InputBorder.none,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              searchController.clear();
            },
            icon: const Icon(Icons.cancel, size: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberGrid(AllMemberProvider memberProvider) {
    if (memberProvider.isLoading) {
      return Center(
          child: SpinKitWaveSpinner(
        color: ColorConstant.primaryColor,
        size: 30.0,
      ));
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: getVerticalSize(137.00),
          crossAxisSpacing: getHorizontalSize(23.00),
          mainAxisSpacing: getHorizontalSize(23.00),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: memberProvider.allMember.length,
        itemBuilder: (context, index) {
          final member = memberProvider.allMember[index];
          return GestureDetector(
            onTap: () {
              memberProvider.setSelectedMember(member);
              Navigator.pushNamed(context, RouteName.memberDetails);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 20, 0),
              child: Container(
                decoration: AppDecoration.fillDeeporange800.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showMemberDetail(context, member),
                      child: CustomIconButton(
                        height: 53,
                        width: 53,
                        margin: getMargin(left: 32, top: 5, right: 32),
                        variant: IconButtonVariant.OutlineWhiteA700,
                        child: Hero(
                          tag: 'imageHero_${member.memberId}',
                          child: ClipOval(
                            child: CachedNetworkImage(
                              height: height,
                              width: width,
                              fit: BoxFit.contain,
                              imageUrl: '${AppUrl.domainName}${member.picture}',
                              placeholder: (context, url) => SizedBox(
                                height: 30,
                                width: 30,
                                child: LinearProgressIndicator(
                                  color: Colors.grey.shade200,
                                  backgroundColor: Colors.grey.shade100,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                ImageConstant.imgEllipse1,
                                height: height,
                                width: width,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 32, top: 5, right: 32),
                      child: Text(
                        member.fullname,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtSourceSansProSemiBold15WhiteA700,
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 5, top: 5, right: 5, bottom: 5),
                      child: Text(
                        member.memberId,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtSourceSansProBold20,
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 5, top: 0, right: 5, bottom: 5),
                      child: Text(
                        "Balance: ${member.totalSavings.toString()}",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: member.totalSavings.toString().contains('-')
                                ? Colors.red
                                : Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _showRefreshConfirmation(
      BuildContext context, AllMemberProvider deleteRecord) async {
    bool refreshConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Refresh record".toUpperCase()),
          content: const Text("Click Yes to refresh the existing record."),
          actions: [
            TextButton(
              onPressed: () {
                deleteRecord.deleteCacheAndFetchData();
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    if (refreshConfirmed == true) {}
  }

  Future<void> _showMemberDetail(BuildContext context, Member member) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return MemberDetailScreen(
            member: member,
          );
        },
      ),
    );
  }
}

class MemberDetailScreen extends StatelessWidget {
  final Member member;

  const MemberDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Customize the app bar as needed.
          ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Hero(
            tag: 'imageHero_${member.memberId}',
            child: CachedNetworkImage(
              imageUrl: '${AppUrl.domainName}${member.picture}',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
