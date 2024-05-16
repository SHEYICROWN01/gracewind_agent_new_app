
import 'package:flutter/material.dart';
import 'package:gracewind_agent_new_app/model/companyBalanceModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class CompanyBalanceView extends StatefulWidget {
  @override
  _CompanyBalanceViewState createState() => _CompanyBalanceViewState();
}

class _CompanyBalanceViewState extends State<CompanyBalanceView> {
  late Future<CompanyBalance> futureCompanyBalance;

  @override
  void initState() {
    super.initState();
    futureCompanyBalance = fetchCompanyBalance();
  }

  Future<CompanyBalance> fetchCompanyBalance() async {
    final response = await http.get(Uri.parse(
        'https://gracewindconsult.com/gracewindapi/companyBalance.php'));

    if (response.statusCode == 200) {
      return CompanyBalance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load company balance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Balance'),
        // backgroundColor: ColorConstant.deepOrange800,
        centerTitle: true,
      ),
      body: FutureBuilder<CompanyBalance>(
        future: futureCompanyBalance,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String positiveNumber = NumberFormat.currency(symbol: 'NGN')
                .format(snapshot.data!.positiveTotalAmount);
            String negativeNumber = NumberFormat.currency(symbol: 'NGN')
                .format(snapshot.data!.negativeTotalAmount);
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  ListTile(
                    leading:
                    const Icon(Icons.arrow_upward, color: Colors.green),
                    title: const Text('Company Total Savings'),
                    subtitle: Text(positiveNumber,
                        style:
                        const TextStyle(fontSize: 35, color: Colors.green)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading:
                    const Icon(Icons.arrow_downward, color: Colors.red),
                    title: const Text('Company Total Loan'),
                    subtitle: Text(negativeNumber,
                        style:
                        const TextStyle(fontSize: 35, color: Colors.red)),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}