import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/controller/dailySavingsProvider.dart';

class DailyTransaction extends StatefulWidget {
  const DailyTransaction({Key? key}) : super(key: key);

  @override
  State<DailyTransaction> createState() => _DailyTransactionState();
}

class _DailyTransactionState extends State<DailyTransaction> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final username = Provider.of<AuthViewModel>(context, listen: false);
      Provider.of<DailySavingsProvider>(context, listen: false)
          .getDailySavings(username.userid.toString(), username.formatted);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Daily Transactions',
            style: TextStyle(color: Colors.white)),
        backgroundColor: ColorConstant.primaryColor,
        centerTitle: true,
      ),
      body: Consumer<DailySavingsProvider>(
        builder: (context, dailyProvider, child) {
          if (dailyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dailyProvider.allDailySavings.isEmpty) {
              return const Center(
                child: Text('No Transactions'),
              );
            } else {
              return Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dailyProvider.allDailySavings.length,
                      itemBuilder: (context, i) {
                        final dailySavings = dailyProvider.allDailySavings[i];
                        return _buildTransactionCard(
                            dailyProvider, dailySavings);
                      },
                    ),
                  )
                ],
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: ColorConstant.primaryColor,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search, size: 10),
          title: TextField(
            controller: _searchController,
            onChanged: (query) {
              Provider.of<DailySavingsProvider>(context, listen: false)
                  .filterMembers(query);
            },
            decoration: const InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(fontSize: 7),
              border: InputBorder.none,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              _searchController.clear();
              Provider.of<DailySavingsProvider>(context, listen: false)
                  .filterMembers('');
            },
            icon: const Icon(Icons.cancel, size: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
      DailySavingsProvider dailyProvider, ViewDailySavingsModel dailySavings) {
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
                  fontSize: 16,
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
                  fontSize: 14,
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
