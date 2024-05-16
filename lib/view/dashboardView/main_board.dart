import 'package:gracewind_agent_new_app/controller/dashboard_controller.dart';
import 'package:gracewind_agent_new_app/route/route_name.dart';
import 'package:gracewind_agent_new_app/utils/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dashboard_action_button.dart';

class MainBoard extends StatefulWidget {
  const MainBoard({super.key});

  @override
  State<MainBoard> createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoard> {
  late String availableBalance = '';
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDashboard(context);
  }

  Widget _buildDashboard(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // ... Your existing code ...
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: ColorConstant.primaryColor,
              ),
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        size: 15,
                        Icons.safety_check_outlined,
                        color: ColorConstant.whiteA700,
                      ),
                      const Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Icon(
                          size: 22,
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorConstant.whiteA700,
                        ),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteName.dailyTransaction),
                        child: const Text(
                          "Transaction History >",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      viewModel.dashboardModels != null
                          ? Text(
                              hidePassword
                                  ? '*****'
                                  : NumberFormat.currency(
                                          symbol: '', decimalDigits: 0)
                                      .format(tryParseDouble(
                                          availableBalance,
                                          viewModel
                                              .dashboardModels!.totalCash)),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : SpinKitPumpingHeart(
                              color: ColorConstant.whiteA700,
                              size: 30.0,
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // ... Your existing code ...
                  DashboardActionButtons(
                    updateText: (text) {
                      setState(() {
                        availableBalance = text;
                      });
                      // ... Your existing code ...
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  double tryParseDouble(String value, String value2) {
    if (value.isEmpty && value2.isEmpty) {
      return 0.0; // Default value
    }
    try {
      return double.parse(value.isEmpty ? value2 : value);
    } catch (e) {
      return 0.0; // Default value
    }
  }
}
