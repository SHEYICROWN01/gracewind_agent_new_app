// ignore: file_names
import 'dart:io';

import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/controller/local_activities_provider.dart';
import 'package:gracewind_agent_new_app/db_helper/getSavingsModel.dart';
import 'package:http/http.dart' as http;

class LocalActivities extends StatefulWidget {
  const LocalActivities({super.key});

  @override
  State<LocalActivities> createState() => _LocalActivitiesState();
}

class _LocalActivitiesState extends State<LocalActivities> {
  List<getSavingsModel> _savingsList = [];

  Future<List<getSavingsModel>> _getData() async {
    final getAgentDetails = Provider.of<AuthViewModel>(context, listen: false);
    final savings = await DatabaseHelper.instance
        .getAllSavings(getAgentDetails.username.toString());
    setState(() {
      _savingsList = savings;
    });
    return _savingsList;
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getAgentDetails = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: const Text('Local Savings'),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
              ))
        ],
      ),
      body: FutureBuilder<List<getSavingsModel>>(
        future: _getData(),
        builder: (context, AsyncSnapshot<List<getSavingsModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: ColorConstant.primaryColor,
              color: Colors.green,
            ));
          } else if (_savingsList.isEmpty) {
            return Center(
              child: Text(
                'No Savings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getFontSize(16),
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: double.maxFinite,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    elevation: 5,
                    child: ListTile(
                      trailing: GestureDetector(
                          onTap: () {
                            _showLogoutDialog(context, index);
                            AlertDialog(
                              title: Text("Delete Savings".toUpperCase()),
                              content: const Text(
                                  "Are you sure you want to delete savings."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                          child: const Icon(Icons.delete, color: Colors.red)),
                      leading: Consumer<LocalActivitiesProvider>(
                        builder: (context, provider, child) {
                          return ElevatedButton.icon(
                            onPressed: () async {
                              if (!provider.isProcessing(index) &&
                                  index < _savingsList.length) {
                                debugPrint('Processing item at index: $index');
                                bool success = await provider.processItem(
                                  memberId:
                                      _savingsList[index].memberID.toString(),
                                  memberName:
                                      _savingsList[index].memberName.toString(),
                                  amount: _savingsList[index].amount.toString(),
                                  date: _savingsList[index].dateNow.toString(),
                                  contributionType: _savingsList[index]
                                      .contributionType
                                      .toString(),
                                  branch: _savingsList[index].branch.toString(),
                                  agentId: getAgentDetails.userid.toString(),
                                  dateTime:
                                      _savingsList[index].dateTime.toString(),
                                  transactionType: _savingsList[index]
                                      .transactionType
                                      .toString(),
                                  index: index,
                                );
                                debugPrint(success.toString());
                                if (success) {
                                  await DatabaseHelper.instance
                                      .deleteRecordByID(
                                    'savings',
                                    _savingsList[index].id,
                                  );
                                  // Perform actions on success
                                  Utils.toastMessage(
                                      'Savings processed successfully');
                                } else {
                                  // Perform actions on failure
                                  Utils.toastMessage(
                                      'Error processing savings');
                                }
                              }
                            },
                            icon: provider.isProcessing(index)
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Icon(Icons.upload,
                                    size: 12, color: Colors.white),
                            label: const Text(''),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.primaryColor,
                            ),
                          );
                        },
                      ),
                      title: Text(
                        'Account N0: ${snapshot.data?[index].memberID}',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fullname: ${snapshot.data?[index].memberName}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Amount ₦:${snapshot.data?[index].amount}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Transaction Type: ${snapshot.data?[index].transactionType}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data?[index].dateNow}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, int index) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancel",
            title: "Delete Savings".toUpperCase(),
            text: "Are you sure you want to delete savings?",
            confirmButtonText: "Yes, Delete",
            type: ArtSweetAlertType.warning));

    // ignore: unrelated_type_equality_checks
    if (response == false) {
      return;
    }

    if (response.isTapConfirmButton) {
      await DatabaseHelper.instance.deleteRecordByID(
        'savings',
        _savingsList[index].id,
      );
      Utils.toastMessage('Savings deleted');
      //Navigator.pop(context);
      //Navigator.pop(context);

      return;
    }
  }
}
