import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:http/http.dart' as http;

class WithdrawalDialog extends StatefulWidget {
  const WithdrawalDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalDialogState createState() => _WithdrawalDialogState();
}

class _WithdrawalDialogState extends State<WithdrawalDialog> {
  final formKey = GlobalKey<FormState>();
  int totalAmount = 0;
  int totalSavingBalance = 0;
  int amountToSave = 0;
  String selectedRadioValue = 'Cash';
  TextEditingController amountController = TextEditingController();
  TextEditingController chargesController = TextEditingController();
  String contributionType = '';

  Future confirmWith() async {
    final allMemberProvider =
        Provider.of<AllMemberProvider>(context, listen: false);
    final selectedMember = allMemberProvider.selectedMember;
    final getAgentDetails = Provider.of<AuthViewModel>(context, listen: false);
    try {
      setState(() {});

      final url = Uri.parse(AppUrl.insertWithdrawal);
      var request = http.MultipartRequest('POST', url);
      request.fields['member_id'] = selectedMember!.member.memberId.toString();
      request.fields['member_name'] = selectedMember.member.fullname.toString();
      request.fields['phone'] = selectedMember.member.phone.toString();
      request.fields['amount'] = totalAmount.toString();
      request.fields['amount2'] = totalAmount.toString();
      request.fields['agentId'] = getAgentDetails.userid.toString();
      request.fields['Branch'] = selectedMember.member.branch.toString();
      request.fields['account_type'] = contributionType;
      request.fields['actual_amount'] = amountController.text;
      request.fields['charges'] = chargesController.text;

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        CoolAlert.show(
          onConfirmBtnTap: () {
            Navigator.pushReplacementNamed(context, RouteName.allMembers);
          },
          context: context,
          barrierDismissible: false,
          type: CoolAlertType.success,
          text: "Request sent successful",
        );

        amountController.clear();
        chargesController.clear();
      } else if (response.statusCode != 200) {
        // ignore: use_build_context_synchronously
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Oops...",
          text: "Sorry, Something went wrong",
        );
        setState(() {});
      }
    } on SocketException {
      Utils.toastMessage('No connectivity');
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    chargesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allMemberProvider = Provider.of<AllMemberProvider>(context);
    final selectedMember = allMemberProvider.selectedMember;
    return AlertDialog(
      title: const Text('Withdrawal Request'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '#20000',
                  suffixIcon: Icon(Icons.currency_exchange),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: TextFormField(
                controller: chargesController,
                decoration: const InputDecoration(
                  labelText: 'Charges',
                  hintText: '#20000',
                  suffixIcon: Icon(Icons.currency_exchange),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  try {} catch (e) {
                    Utils.toastMessage(
                        'Invalid input. Please enter a valid number.');
                    return 'Invalid input';
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              totalAmount = int.parse(amountController.text) +
                  int.parse(chargesController.text);

              totalSavingBalance =
                  int.parse(selectedMember!.member.totalSavings.toString());
              amountToSave = int.parse(amountController.text);

              if (totalAmount <= totalSavingBalance) {
                contributionType = "Regular Savi";
              } else if (totalAmount > totalSavingBalance) {
                contributionType = 'Loan Repayment';
              }
              ArtDialogResponse response = await ArtSweetAlert.show(
                  barrierDismissible: false,
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      denyButtonText: "Cancel",
                      title: "₦${amountController.text}",
                      text:
                          "Confirm the above Amount \n You won't be able to revert this!",
                      confirmButtonText: "Yes, Confirmed",
                      type: ArtSweetAlertType.warning));
              if (response == null) {
                return;
              }
              if (response.isTapConfirmButton) {
                confirmWith();
              }
            }

            // Process data here

            // Close the dialog
          },
          child: const Text('Withdrawal'),
        ),
      ],
    );
  }
}
