import 'package:flutter/material.dart';
import 'package:gracewind_agent_new_app/route/route_name.dart';
import 'package:gracewind_agent_new_app/view/getWithdrawalList.dart';
import 'package:gracewind_agent_new_app/view/viewCompanyBalance.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  Widget _buildManagementItem({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Management Only'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildManagementItem(
                  title: 'Company Balance',
                  color: Colors.amber,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyBalanceView(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16.0),
                _buildManagementItem(
                  title: 'Delete Contributions',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteName.getDateForDeleteContribution);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                _buildManagementItem(
                  title: 'Withdrawal Request',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetWithdrawalList(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
