import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/view/account_summary.dart';
import 'package:gracewind_agent_new_app/view/all_customers.dart';
import 'package:gracewind_agent_new_app/view/auth/register_auth.dart';
import 'package:gracewind_agent_new_app/view/daily_transactions.dart';
import 'package:gracewind_agent_new_app/view/expenses.dart';
import 'package:gracewind_agent_new_app/view/get_all_members.dart';
import 'package:gracewind_agent_new_app/view/localActivities.dart';
import 'package:gracewind_agent_new_app/view/management_list.dart';
import 'package:gracewind_agent_new_app/view/noteView.dart';
import 'package:gracewind_agent_new_app/view/notification.dart';
import 'package:gracewind_agent_new_app/view/transaction_by_date.dart';

import '../view/get_date_for_delete_contribution.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RouteName.dailyExpense:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DailyExpenses());
      case RouteName.loginAuth:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginAuth());

      case RouteName.openAccount:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Register());

      case RouteName.customerRegistration:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CustomerRegistration());

      case RouteName.recover:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Recover());

      case RouteName.notification:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NotificationView());

      case RouteName.localActivities:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LocalActivities());

      case RouteName.memberData:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MemberRecord());
      case RouteName.dashboardView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const DashboardPage());
      case RouteName.updateMember:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UpdateProfile());

      case RouteName.allMembers:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AllMembers());
      case RouteName.transactionByDate:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TransactionByDate());

      case RouteName.accountSummary:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AccountSummary());

      case RouteName.dailyTransaction:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DailyTransaction());

      case RouteName.memberDetails:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MemberDetails());

      case RouteName.noteView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NoteView());

      case RouteName.getDateForDeleteContribution:
        return MaterialPageRoute(builder: (BuildContext context) => const SelectDateForDeleteContributions());

      case RouteName.managementScreen:
        return MaterialPageRoute(builder: (BuildContext context) => const ManagementScreen());


      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route found'),
            ),
          );
        });
    }
  }
}
