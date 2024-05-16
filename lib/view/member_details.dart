import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/model/userWithdrawalWallet.dart';
import 'package:gracewind_agent_new_app/view/addSaving.dart';
import 'package:gracewind_agent_new_app/view/addWithdrawal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class MemberDetails extends StatefulWidget {
  const MemberDetails({Key? key}) : super(key: key);

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  bool showTransactionHistory = true; // Initially show transaction history
  TextEditingController amountController = TextEditingController();

  bool isLoading = true;
  bool walletLoading = false;

  String savingsData = '';
  int totalSavingBalance = 0;
  int amountToSave = 0;
  bool walletWithdrawalLoading = false;

  List<UserWallet> _listWallet = [];
  List<UserWithdrawalWallet> _listWithdrawalWallet = [];

  Future<void> fetchUserWallet() async {
    final allMemberProvider =
        Provider.of<AllMemberProvider>(context, listen: false);
    final selectedMember = allMemberProvider.selectedMember;
    try {
      setState(() {
        walletLoading = true;
      });
      var url = Uri.parse(
          '${AppUrl.newMemberWallet}?memberid=${selectedMember!.member.memberId}');
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _listWallet =
            data.map<UserWallet>((json) => UserWallet.fromJson(json)).toList();
      }
    } on SocketException {
      Utils.toastMessage('No connectivity');
    } finally {
      setState(() {
        walletLoading = false;
      });
    }
  }

  Future<void> fetchUserWithdrawalWallet() async {
    final allMemberProvider =
        Provider.of<AllMemberProvider>(context, listen: false);
    final selectedMember = allMemberProvider.selectedMember;
    try {
      setState(() {
        walletWithdrawalLoading = true;
      });
      var url = Uri.parse(
          '${AppUrl.withdrawalWallet}?memberid=${selectedMember!.member.memberId}');
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _listWithdrawalWallet = data
            .map<UserWithdrawalWallet>(
                (json) => UserWithdrawalWallet.fromJson(json))
            .toList();
      }
    } on SocketException {
      Utils.toastMessage('No connectivity');
    } finally {
      setState(() {
        walletWithdrawalLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserWallet();
    fetchUserWithdrawalWallet();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allMemberProvider = Provider.of<AllMemberProvider>(context);
    final selectedMember = allMemberProvider.selectedMember;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        body: SingleChildScrollView(
          child: SizedBox(
            height: getVerticalSize(764.00),
            width: size.width,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _buildMainContainer(selectedMember),
                _buildProfileImage(selectedMember),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Savings / Withdrawal',
          onPressed: () {
            showModalBottomSheet(
                isDismissible: false,
                showDragHandle: true,
                elevation: 2.0,
                enableDrag: true,
                barrierColor: Colors.white.withOpacity(0.4),
                // useSafeArea: true,
                backgroundColor: ColorConstant.primaryColor,
                context: context,
                builder: (context) => SafeArea(
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                              leading: const Icon(Icons.monetization_on_sharp,
                                  color: Colors.white),
                              title: const Text(
                                'Add New Savings',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                              onTap: () async {
                                Navigator.pop(context);

                                _openSavingsDialog(context);
                              }),
                          ListTile(
                            leading: const Icon(
                              Icons.money,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Request Withdrawal',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              _openWithdrawalDialog(context);
                            },
                          ),
                        ],
                      ),
                    ));
          },
          backgroundColor: ColorConstant.primaryColor,
          child: Icon(Icons.add, color: ColorConstant.whiteA700),
        ),
      ),
    );
  }

  Widget _buildMainContainer(SelectedMember? selectedMember) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: getMargin(left: 23, top: 40, right: 24, bottom: 39),
        decoration: AppDecoration.fillDeeporange800
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder20),
        child: ListView(
          children: [
            _buildUserInfo(selectedMember),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: getPadding(left: 16, top: 9, right: 16),
                  child: Text(
                    "Transaction History",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtSourceSansProSemiBold15WhiteA700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showTransactionHistory = !showTransactionHistory;
                    });
                  },
                  child: Padding(
                    padding: getPadding(left: 16, top: 9, right: 16),
                    child: Text(
                      showTransactionHistory
                          ? 'Show Withdrawal History'
                          : 'Show Transaction History',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtSourceSansProSemiBold15WhiteA700,
                    ),
                  ),
                ),
              ],
            ),
            showTransactionHistory
                ? _buildTransactionHistory()
                : _buildWithdrawalHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(SelectedMember? selectedMember) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: getMargin(left: 117, right: 117, bottom: 15),
        decoration: AppDecoration.fillDeeporange800
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: getPadding(all: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(getHorizontalSize(59.77)),
                child: CommonImageView(
                  url: '${AppUrl.domainName}${selectedMember?.member.picture}',
                  imagePath: ImageConstant.imgEllipse2,
                  height: getSize(119.00),
                  width: getSize(119.00),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(SelectedMember? selectedMember) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: getPadding(left: 13, top: 90, right: 13),
        child: Column(
          children: [
            Text(
              selectedMember!.member.fullname.toString(),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: getFontSize(15),
                fontFamily: 'Source Sans Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              selectedMember.member.memberId.toString(),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: getFontSize(15),
                fontFamily: 'Source Sans Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Rate: ${selectedMember.member.rate}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: getFontSize(15),
                fontFamily: 'Source Sans Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              selectedMember.member.memberId.isEmpty
                  ? ('0')
                  : 'Savings:   ₦${selectedMember.member.totalSavings}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                color:
                    int.parse(selectedMember.member.totalSavings.toString()) < 0
                        ? Colors.red
                        : Colors.green,
                fontSize: getFontSize(15),
                fontFamily: 'Source Sans Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: getVerticalSize(455.00),
          width: getHorizontalSize(299.00),
          margin: getMargin(left: 13, top: 8, right: 13, bottom: 28),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: getMargin(left: 2, right: 2),
                  decoration: AppDecoration.fillWhiteA700,
                  child: walletLoading
                      ? SpinKitCubeGrid(
                          color: ColorConstant.primaryColor,
                          size: 30.0,
                        )
                      : _buildTransactionList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawalHistory() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: getVerticalSize(455.00),
          width: getHorizontalSize(299.00),
          margin: getMargin(left: 13, top: 8, right: 13, bottom: 28),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: getMargin(left: 2, right: 2),
                  decoration: AppDecoration.fillWhiteA700,
                  child: walletWithdrawalLoading
                      ? SpinKitCubeGrid(
                          color: ColorConstant.primaryColor,
                          size: 30.0,
                        )
                      : _buildWithdrawalList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_listWallet.isEmpty) {
      return Center(
        child: Text(
          'No Transaction',
          style: TextStyle(
            color: Colors.black,
            fontSize: getFontSize(16),
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return SizedBox(
      height: double.infinity,
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _listWallet.length,
        itemBuilder: (context, index) {
          bool isRegularSavings =
              _listWallet[index].contributionType == "Regular Savi";
          bool isLoanRepayment =
              _listWallet[index].contributionType == "Loan Repayment";

          Color amountColor = isRegularSavings
              ? Colors.green
              : isLoanRepayment
                  ? Colors.red
                  : Colors.black;
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: getPadding(left: 13, top: 17, right: 13),
                  child: Text(
                    _listWallet[index].date.toString(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtSourceSansProSemiBold14Black90099,
                  ),
                ),
              ),
              Container(
                margin: getMargin(top: 14),
                decoration: AppDecoration.fillGray30087,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: getPadding(left: 4, top: 14, bottom: 14),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(getHorizontalSize(19.00)),
                        child: CommonImageView(
                          imagePath: ImageConstant.logo,
                          height: getVerticalSize(38.00),
                          width: getHorizontalSize(45.00),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 8, top: 14, bottom: 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(right: 10),
                            child: Text(
                              "Grace wind Consult",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtSourceSansProSemiBold14,
                            ),
                          ),
                          Container(
                            width: getHorizontalSize(216.00),
                            margin: getMargin(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: getPadding(top: 1),
                                  child: Text(
                                    'Transaction by : ${_listWallet[index].agentUsername}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getFontSize(12),
                                      fontFamily: 'Source Sans Pro',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: getPadding(top: 1),
                                    child: Text(
                                      _listWallet[index].amount.length < 2
                                          ? (' ')
                                          : _listWallet[index].amount,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: amountColor,
                                        fontSize: getFontSize(12),
                                        fontFamily: 'Source Sans Pro',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWithdrawalList() {
    if (_listWithdrawalWallet.isEmpty) {
      return Center(
        child: Text(
          'No Withdrawal Transaction',
          style: TextStyle(
            color: Colors.black,
            fontSize: getFontSize(16),
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return SizedBox(
      height: double.infinity,
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _listWithdrawalWallet.length,
        itemBuilder: (context, index) {
          bool isRegularSavings =
              _listWithdrawalWallet[index].accType == "Regular Savi";
          bool isLoanRepayment =
              _listWithdrawalWallet[index].accType == "Loan Repayment";

          Color amountColor = isRegularSavings
              ? Colors.green
              : isLoanRepayment
                  ? Colors.red
                  : Colors.black;
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: getPadding(left: 13, top: 17, right: 13),
                  child: Text(
                    _listWithdrawalWallet[index].date.toString(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtSourceSansProSemiBold14Black90099,
                  ),
                ),
              ),
              Container(
                margin: getMargin(top: 14),
                decoration: AppDecoration.fillGray30087,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: getPadding(left: 4, top: 14, bottom: 14),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(getHorizontalSize(19.00)),
                        child: CommonImageView(
                          imagePath: ImageConstant.logo,
                          height: getVerticalSize(38.00),
                          width: getHorizontalSize(45.00),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(left: 8, top: 14, bottom: 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(right: 10),
                            child: Text(
                              "Grace Wind Consult",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtSourceSansProSemiBold14,
                            ),
                          ),
                          Container(
                            width: getHorizontalSize(216.00),
                            margin: getMargin(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: getPadding(top: 1),
                                  child: Text(
                                    'Transaction by : ${_listWithdrawalWallet[index].agentUsername}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getFontSize(12),
                                      fontFamily: 'Source Sans Pro',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: getPadding(top: 1),
                                    child: Text(
                                      _listWithdrawalWallet[index]
                                                  .amount
                                                  .length <
                                              2
                                          ? (' ')
                                          : _listWithdrawalWallet[index].amount,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: amountColor,
                                        fontSize: getFontSize(12),
                                        fontFamily: 'Source Sans Pro',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openSavingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SavingsDialog();
      },
    );
  }

  void _openWithdrawalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WithdrawalDialog();
      },
    );
  }
}
