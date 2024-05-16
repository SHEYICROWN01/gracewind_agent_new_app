import 'package:gracewind_agent_new_app/app_export.dart';

class DashboardActionButtons extends StatefulWidget {
  final void Function(String) updateText;

  const DashboardActionButtons({
    Key? key,
    required this.updateText,
  }) : super(key: key);

  @override
  State<DashboardActionButtons> createState() => _DashboardActionButtonsState();
}

class _DashboardActionButtonsState extends State<DashboardActionButtons> {
  late DashboardViewModel _viewModel; // Instance variable

  Future<void> fetchData() async {
    final getUsername = Provider.of<AuthViewModel>(context, listen: false);
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    await _viewModel.fetchDashboardData(getUsername.username!).then((_) => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          for (final action in actions)
            Expanded(
              child: buildActionButton(
                action.icon,
                action.color,
                action.label,
                action.getData(_viewModel.dashboardModels),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildActionButton(
      IconData icon,
      Color color,
      String label,
      String? data,
      ) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.hardEdge,
      color: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          if (data != null) {
            widget.updateText(data);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 12,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Action {
  final IconData icon;
  final Color color;
  final String label;
  final String? Function(DashboardModels?) getData;

  Action({
    required this.icon,
    required this.color,
    required this.label,
    required this.getData,
  });
}

final actions = [
  Action(
    icon: Icons.sell,
    color: Colors.white,
    label: 'Total',
    getData: (models) => models?.totalCash ?? '0',
  ),
  Action(
    icon: Icons.arrow_upward,
    color: Colors.green,
    label: 'Savings',
    getData: (models) => models?.totalDailySavings ?? '0',
  ),
  Action(
    icon: Icons.arrow_downward,
    color: Colors.red,
    label: 'Loan',
    getData: (models) => models?.totalLoanRepayment ?? '0',
  ),

];

