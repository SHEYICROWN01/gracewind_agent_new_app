import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gracewind_agent_new_app/app_export.dart';

class AccountSummary extends StatefulWidget {
  const AccountSummary({Key? key}) : super(key: key);

  @override
  _AccountSummaryState createState() => _AccountSummaryState();
}

class _AccountSummaryState extends State<AccountSummary> {
  Map<String, int> data = {
    "TotalSavings": 0,
    "TotalRegularSavings": 0,
    "TotalLoanRepayment": 0,
    "TotalLoanRepaymentWithdrawal": 0,
    "TotalRegularSavingsWithdrawal": 0,
    "TotalWithdrawal": 0,
    "TotalLoanRepaymentCharges": 0,
    "TotalRegularSavingsCharges": 0,
    "TotalCharges": 0,
  };
  DateTime selectedDate = DateTime.now();

  Future<void> fetchData(String agent, DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await http.get(
        Uri.parse('${AppUrl.agentAccount}?date=$formattedDate&agentID=$agent'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData.containsKey("TotalRegularSavings") &&
          decodedData.containsKey("TotalLoanRepayment") &&
          decodedData.containsKey("TotalSavings") &&
          decodedData.containsKey("TotalLoanRepaymentWithdrawal") &&
          decodedData.containsKey("TotalRegularSavingsWithdrawal") &&
          decodedData.containsKey("TotalWithdrawal") &&
          decodedData.containsKey("TotalLoanRepaymentCharges") &&
          decodedData.containsKey("TotalRegularSavingsCharges") &&
          decodedData.containsKey("TotalCharges")) {
        setState(() {
          data = {
            "TotalRegularSavings":
                int.tryParse(decodedData["TotalRegularSavings"].toString()) ??
                    0,
            "TotalLoanRepayment":
                int.tryParse(decodedData["TotalLoanRepayment"].toString()) ?? 0,
            "TotalSavings":
                int.tryParse(decodedData["TotalSavings"].toString()) ?? 0,
            "TotalLoanRepaymentWithdrawal": int.tryParse(
                    decodedData["TotalLoanRepaymentWithdrawal"].toString()) ??
                0,
            "TotalRegularSavingsWithdrawal": int.tryParse(
                    decodedData["TotalRegularSavingsWithdrawal"].toString()) ??
                0,
            "TotalWithdrawal":
                int.tryParse(decodedData["TotalWithdrawal"].toString()) ?? 0,
            "TotalLoanRepaymentCharges": int.tryParse(
                    decodedData["TotalLoanRepaymentCharges"].toString()) ??
                0,
            "TotalRegularSavingsCharges": int.tryParse(
                    decodedData["TotalRegularSavingsCharges"].toString()) ??
                0,
            "TotalCharges":
                int.tryParse(decodedData["TotalCharges"].toString()) ?? 0,
          };
        });
      } else {
        // Handle the case where the expected fields are missing or have unexpected types
        // You can show an error message or set default values as appropriate.
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final agentDetails = Provider.of<AuthViewModel>(context, listen: false);
    fetchData(agentDetails.userid.toString(), selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final agentDetails = Provider.of<AuthViewModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchData(agentDetails.userid.toString(), selectedDate);
    }
  }

  List<Widget> buildCardList() {
    final cardList = data.entries.map((entry) {
      final formattedValue = NumberFormat.currency(locale: 'en_NG', symbol: '')
          .format(entry.value.toDouble());
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          title: Text(
            entry.key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            formattedValue,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }).toList();

    final dividedCards = <Widget>[];
    for (var i = 0; i < cardList.length; i += 3) {
      if (i > 0) {
        dividedCards.add(const Divider());
      }
      dividedCards.addAll(cardList.sublist(i, i + 3));
    }

    return dividedCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Account Summary'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: buildCardList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectDate(context);
        },
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}
