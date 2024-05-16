import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gracewind_agent_new_app/app_export.dart';
import '../model/contributions_for_delete_model.dart';
import 'package:http/http.dart' as http;


class GetContributionsForDelete extends StatefulWidget {
  final DateTime selectedDate;
  final String username;
  const GetContributionsForDelete({Key? key, required this.selectedDate, required this.username, })
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GetContributionsForDeleteState createState() => _GetContributionsForDeleteState();
}

class _GetContributionsForDeleteState extends State<GetContributionsForDelete> {
  bool isLoading = false;
  List<ContributionForDeleteModel> _list = [];
  final List<ContributionForDeleteModel> _search = [];
  var loading = false;
  var deleteLoading = false;
  Future<void> fetchData() async {
    try {
      setState(() {
        loading = true;
      });
      _list.clear();
      var url = Uri.parse(
          'https://www.gracewindconsult.com/gracewindmobileapi/getContributionForDelete.php?date=${widget.selectedDate}');

      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _list = data
            .map<ContributionForDeleteModel>(
                (json) => ContributionForDeleteModel.fromJson(json))
            .toList();
        setState(() {
          loading = false;
        });
      }
    } on SocketException {
      Fluttertoast.showToast(
          msg: "No connectivity",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.SNACKBAR);
    }
  }
  Future<void> deleteContributions(String id) async {
    try {
      setState(() {
        deleteLoading = true;
      });
      _list.clear();
      var url = Uri.parse(
          'https://www.gracewindconsult.com/gracewindmobileapi/deleteContribution.php?id=$id}');

      final response = await http.post(url);
      if (response.statusCode == 200) {

        Fluttertoast.showToast(
            msg: "Contributions Deleted",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            gravity: ToastGravity.SNACKBAR);
        setState(() {
          deleteLoading = false;
        });
        fetchData();
      }

    } on SocketException {
      deleteLoading = false;
      Fluttertoast.showToast(
          msg: "No connectivity",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.SNACKBAR);
    }
  }

  TextEditingController controller = TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var f in _list) {
      if (f.fullname.toLowerCase().contains(text) ||
          f.memberId.toString().contains(text) ||
          f.fullname.toUpperCase().contains(text)) {
        _search.add(f);
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final username = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Online Daily Savings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        backgroundColor: const Color(0xFF24487C),
        leading: IconButton(
            onPressed: () {
           Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color(0xFF24487C),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                  controller: controller,
                  onChanged: onSearch,
                  decoration: const InputDecoration(
                      hintText: "Search", border: InputBorder.none),
                ),
                trailing: IconButton(
                  onPressed: () {
                    controller.clear();
                    onSearch('');
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ),
            ),
          ),
          loading
              ? const Center(
            child: LinearProgressIndicator(
              backgroundColor: Colors.red,
            ),
          )
              : Expanded(
            child: _search.isNotEmpty || controller.text.isNotEmpty
                ? RefreshIndicator(
              child: deleteLoading == true ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  SpinKitCubeGrid(
                                    color: Colors.indigoAccent,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text('Wait while processing...')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : ListView.builder(
                itemCount: _search.length,
                itemBuilder: (context, i) {
                  return Container(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          trailing: IconButton(
                            onPressed: () async {
                              ArtDialogResponse response = await ArtSweetAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      denyButtonText: "Cancel",
                                      title: "Are you sure?",
                                      text: "confirm to delete contribution",
                                      confirmButtonText: "Yes, Delete",
                                      type: ArtSweetAlertType.warning));
                              // ignore: unrelated_type_equality_checks
                              if (response == false) {
                                return;
                              }
                              if (response.isTapConfirmButton) {
                                deleteContributions(_search[i].id);
                                return;
                              }
                            },

                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          title: Text(_search[i].fullname,
                              style: const TextStyle(
                                  fontSize: 12.0,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'MemberID: ${_search[i].memberId}',
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF24487C))),
                              Text('Amount: ${_search[i].amount}',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      color: Color(0xFF24487C))),

                              Text(
                                  'Date: ${_search[i].date}',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF24487C))),
                              Text(
                                  'ContributionType: ${_search[i].contributionType}',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF24487C))),
                              Text(
                                  'Branch: ${_search[i].branch}',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF24487C))),
                              Text(
                                  'AgentId: ${_search[i].agentId}',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      color: Color(0xFF24487C))),

                            ],
                          ),
                        ),
                      ));
                },
              ),
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1),
                        () {
                      setState(() {
                        fetchData();
                      });
                    });
              },
            )
                : RefreshIndicator(
                child: deleteLoading == true ? Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    SpinKitCubeGrid(
                                      color: Colors.indigoAccent,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text('Wait while processing...')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, i) {
                    return Container(
                        padding: const EdgeInsets.all(3.0),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                              trailing: deleteLoading == true
                                  ? const CircularProgressIndicator()
                                  : IconButton(
                                onPressed: () async {
                                  ArtDialogResponse response = await ArtSweetAlert.show(
                                      barrierDismissible: false,
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          denyButtonText: "Cancel",
                                          title: "Are you sure?",
                                          text: "confirm to delete contribution",
                                          confirmButtonText: "Yes, Delete",
                                          type: ArtSweetAlertType.warning));
                                  // ignore: unrelated_type_equality_checks
                                  if (response == false) {
                                    return;
                                  }
                                  if (response.isTapConfirmButton) {
                                    deleteContributions(_list[i].id);
                                    return;
                                  }
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                              title: Text(
                                  _list[i].fullname.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'MemberID: ${_list[i].memberId}',
                                      style: const TextStyle(
                                          fontSize: 12.0,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w900,
                                          color:
                                          Color(0xFF24487C))),
                                  Text('Amount: ${_list[i].amount}',
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          color:
                                          Color(0xFF24487C))),
                                  Text(
                                      'Date: ${_list[i].date}',
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          color: Color(0xFF24487C))),
                                  Text(
                                      'ContributionType: ${_list[i].contributionType}',
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF24487C))),
                                  Text(
                                      'Branch: ${_list[i].branch}',
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF24487C))),
                                  Text(
                                      'AgentId: ${_list[i].agentId}',
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF24487C))),

                                ],
                              )),
                        ));
                  },
                ),
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1),
                          () {
                        setState(() {
                          fetchData();
                        });
                      });
                }),
          ),
        ],
      ),
    );
  }
}

