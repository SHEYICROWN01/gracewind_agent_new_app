import 'dart:convert';
import 'dart:io';

import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/controller/auth_provider/auth_repositoy.dart';
import 'package:gracewind_agent_new_app/utils/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DailyExpenses extends StatefulWidget {
  const DailyExpenses({Key? key}) : super(key: key);

  @override
  State<DailyExpenses> createState() => _DailyExpensesState();
}

class _DailyExpensesState extends State<DailyExpenses> {
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  @override
  dispose() {
    super.dispose();
    expensesController.dispose();
    amountController.dispose();
  }

  _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        shape: const StadiumBorder(),
        content: Text(msg),
      ),
    );
  }

  Future<void> uploadExpenses() async {
    final agentId = Provider.of<AuthViewModel>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse(AppUrl.dailyExpenses);
      var request = http.MultipartRequest('POST', url)
        ..fields['agentId'] = agentId.userid.toString()
        ..fields['agent_username'] = agentId.username.toString()
        ..fields['expenses'] = expensesController.text
        ..fields['amount'] = amountController.text;

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isLoading = false;
          expensesController.clear();
        });

        _showSnackBar('Successful ', ColorConstant.primaryColor);
        Navigator.of(context).pop();
        getMethod();
      } else {
        setState(() {
          isLoading = false;
        });

        _showSnackBar('Sorry, Something went wrong ', Colors.red);
      }
    } on SocketException {
      setState(() {
        isLoading = false;
      });

      _showSnackBar('No connectivity ', Colors.red);
    }
  }

  Future<void> getMethod() async {
    final agentId = Provider.of<AuthViewModel>(context, listen: false);
    var url = Uri.parse('${AppUrl.getDailyExpenses}?agentId=${agentId.userid}');

    var response = await http.post(url, body: {
      'agentId': '${agentId.userid}',
    });

    var resBodyID = json.decode(response.body);
    return resBodyID;
  }

  @override
  void initState() {
    super.initState();
    getMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expenses'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ColorConstant.primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(child: buildComment()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExpenseDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildComment() {
    return FutureBuilder(
      future: getMethod(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List? snap = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error Fetching Data'),
          );
        }

        return ListView.builder(
          itemCount: snap!.length,
          itemBuilder: (context, index) {
            return Center(
              child: Card(
                elevation: 5,
                child: ListTile(
                  title: Text(
                    '${snap[index]['Expenses']}',
                    style: const TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: ${snap[index]['Amount']}',
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                          )),
                      Text('Date: ${snap[index]['Date']}',
                          style: const TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.w300)),
                    ],
                  ),
                  leading: const Icon(Icons.monetization_on_rounded),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Expense'),
          content: IntrinsicHeight(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: expensesController,
                    decoration: const InputDecoration(labelText: 'Expense'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: () {
                      if (expensesController.text.isEmpty) {
                        _showSnackBar('Enter Daily Expenses', Colors.red);
                      } else if (amountController.text.isEmpty) {
                        _showSnackBar('Enter Expenses Amount', Colors.red);
                      } else {
                        uploadExpenses();
                      }
                    },
                    child: const Text('Add'),
                  ),
          ],
        );
      },
    );
  }
}
