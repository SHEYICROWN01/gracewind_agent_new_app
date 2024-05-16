import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/utils/inputSavingsTextFields2.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ConfirmGetWithdrawalList extends StatefulWidget {

  final List list;
  final int index;
  const ConfirmGetWithdrawalList(
      {Key? key,
      required this.list,
      required this.index,

      })
      : super(key: key);

  @override
  State<ConfirmGetWithdrawalList> createState() =>
      _ConfirmGetWithdrawalListState();
}

class _ConfirmGetWithdrawalListState extends State<ConfirmGetWithdrawalList> {
  bool _isLoadingApprove = false;
  bool _isLoadingDisapprove = false;
  // Define the function to update the withdrawal request
  Future<void> updateWithdrawalRequest(String id, String username,
      String status, String memberid, String amount) async {
    // API endpoint URL
    const String apiUrl =
        'https://gracewindconsult.com/gracewindapi/updateWithdrawalRequestStatus.php';

    // Request body
    Map<String, dynamic> requestBody = {
      'id': id.toString(),
      'username': username,
      'status': status,
      'memberid': memberid,
      'amount': amount
    };

    try {
      setState(() {
        if (status == 'Approved') {
          _isLoadingApprove = true;
        } else if (status == 'Disapproved') {
          _isLoadingDisapprove = true;
        }
      });

      // Send the POST request to the API
      final response = await http.post(Uri.parse(apiUrl), body: requestBody);

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = json.decode(response.body);

        // Check if the API request was successful
        if (responseData['success'] == true) {
          // Get the success message
          final String message = responseData['message'];
          // Display the success message
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: const Color(0xFF24487C),
            gravity: ToastGravity.SNACKBAR,
          );
        } else {
          final String message = responseData['message'];
          // Display the error message
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: const Color(0xFF24487C),
            gravity: ToastGravity.SNACKBAR,
          );
        }
      } else {
        // Display an error message if the API request failed
        Fluttertoast.showToast(
          msg: ' ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: const Color(0xFF24487C),
          gravity: ToastGravity.SNACKBAR,
        );
      }
    } catch (error) {
      // Display an error message if there was an exception
      Fluttertoast.showToast(
        msg: '$error',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: const Color(0xFF24487C),
        gravity: ToastGravity.SNACKBAR,
      );
    } finally {
      setState(() {
        if (status == 'Approved') {
          _isLoadingApprove = false;
        } else if (status == 'Disapproved') {
          _isLoadingDisapprove = false;
        }
      });
    }
  }

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  DateTime currentDate = DateTime.now();

  String? customerID;
  String? fullName;
  String? onlineAgentID;
  String? location;
  String? userRate;
  String? userLastSavings;
  String? userTotalSavings;
  String? myAmount;
  bool _processing = false;
  bool choice = true;
  TextEditingController? customerid = TextEditingController();
  TextEditingController? fullname = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController? agentName = TextEditingController();
  TextEditingController? agentbranch = TextEditingController();
  TextEditingController? date = TextEditingController();
  TextEditingController? nowdate2 = TextEditingController();
  TextEditingController? contribu = TextEditingController();
  TextEditingController? rate = TextEditingController();
  TextEditingController? lastSavings = TextEditingController();
  TextEditingController totalSavings = TextEditingController();
  String transaction = "Savings";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Withdrawal Options',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            InputSavingsTextFields2(
              editable: false,
              myController: customerid!,
              hintText: '${widget.list[widget.index].memberId}',
              labelText: '${widget.list[widget.index].memberId}',
            ),
            InputSavingsTextFields2(
              editable: false,
              myController: fullname!,
              hintText: 'Member FullName',
              labelText: '${widget.list[widget.index].name}',
            ),
            InputSavingsTextFields2(
              editable: false,
              myController: fullname!,
              hintText: 'Amount',
              labelText: '${widget.list[widget.index].amount}',
            ),
            InputSavingsTextFields2(
              editable: false,
              myController: fullname!,
              hintText: 'Charges',
              labelText: '${widget.list[widget.index].charges}',
            ),
            InputSavingsTextFields2(
              editable: false,
              myController: fullname!,
              hintText: 'Phone',
              labelText: '${widget.list[widget.index].phone}',
            ),
            InputSavingsTextFields2(
              editable: false,
              myController: fullname!,
              hintText: 'Branch',
              labelText: '${widget.list[widget.index].branch}',
            ),
            InputSavingsTextFields2(
              editable: false,
              myController: fullname!,
              hintText: 'Date',
              labelText: '${widget.list[widget.index].date3}',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _isLoadingApprove
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () {
                          // Call the updateWithdrawalRequest function
                          updateWithdrawalRequest(
                              '${widget.list[widget.index].id}',
                              username.username.toString(),
                              'Approved',
                              '${widget.list[widget.index].memberId}',
                              '${widget.list[widget.index].amount}');
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 3,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: _processing
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Approve",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                _isLoadingDisapprove
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () {
                          // Call the updateWithdrawalRequest function
                          updateWithdrawalRequest(
                              '${widget.list[widget.index].id}',
                              username.username.toString(),
                              'Disapproved',
                              '${widget.list[widget.index].memberId}',
                              '${widget.list[widget.index].amount}');
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 3,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: _processing
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Disapprove",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
