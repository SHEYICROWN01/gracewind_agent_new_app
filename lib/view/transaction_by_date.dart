import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/controller/savingsByDateProvider.dart';
import 'package:intl/intl.dart';

class TransactionByDate extends StatefulWidget {
  const TransactionByDate({Key? key}) : super(key: key);

  @override
  State<TransactionByDate> createState() => _TransactionByDateViewState();
}

class _TransactionByDateViewState extends State<TransactionByDate> {
  late DateTime selectedDate;
  String selectedTransactionType = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize selectedDate with the current date
    selectedDate = DateTime.now();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Transactions by date',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorConstant.primaryColor,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'filter',
            color: Colors.white,
            onSelected: (value) {
              // Handle the selected value here (e.g., filter by the selected value)
              setState(() {
                selectedTransactionType = value;
              });
              fetchData();
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('Show All'),
              ),
              const PopupMenuItem<String>(
                value: 'Cash',
                child: Text('Cash'),
              ),
              const PopupMenuItem<String>(
                value: 'Transfer',
                child: Text('Transfer'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: ColorConstant.primaryColor,
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.arrow_circle_right_outlined),
                      title: Text(
                        'Selected Date: ${formattedDate.toString()}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          // Show date picker and update selectedDate
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                            fetchData();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Consumer<SavingsByDateProvider>(
                  builder: (context, dailyProvider, child) {
                    if (dailyProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<ViewDailySavingsModel> filteredList =
                      dailyProvider.allDailySavings.where((dailySavings) {
                        if (selectedTransactionType == 'All') {
                          return true;
                        } else if (selectedTransactionType == 'Cash') {
                          return dailySavings.transactionType.toLowerCase() == 'cash';
                        } else if (selectedTransactionType == 'Transfer') {
                          return dailySavings.transactionType.toLowerCase() == 'transfer';
                        }
                        return false;
                      }).toList();

                      return Expanded(
                        child: filteredList.isEmpty
                            ? const Center(
                          child: Text('No Transactions on the selected date'),
                        )
                            : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, i) {
                            final dailySavings = filteredList[i];
                            return _buildTransactionCard(dailyProvider, dailySavings);
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> fetchData() async {
    final username = Provider.of<AuthViewModel>(context, listen: false);
    await Provider.of<SavingsByDateProvider>(context, listen: false)
        .getDailySavings(username.userid.toString(), selectedDate.toString());
  }

  Widget _buildTransactionCard(
      SavingsByDateProvider dailyProvider, ViewDailySavingsModel dailySavings) {
    bool isRegularSavings = dailySavings.contributionType == "Regular Savi";
    bool isLoanRepayment = dailySavings.contributionType == "Loan Repayment";

    Color amountColor = isRegularSavings
        ? Colors.green
        : isLoanRepayment
        ? Colors.red
        : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dailySavings.fullname,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dailySavings.memberId,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF24487C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount: ${dailySavings.amount}',
                style: TextStyle(
                  fontSize: 14,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transaction Type: ${dailySavings.transactionType}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF24487C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
