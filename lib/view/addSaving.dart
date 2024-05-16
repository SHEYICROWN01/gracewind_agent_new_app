import 'package:gracewind_agent_new_app/app_export.dart';

class SavingsDialog extends StatefulWidget {
  const SavingsDialog({super.key});

  @override
  _SavingsDialogState createState() => _SavingsDialogState();
}

class _SavingsDialogState extends State<SavingsDialog> {
  final formKey = GlobalKey<FormState>();
  String selectedRadioValue = 'Cash';
  TextEditingController amountController = TextEditingController();
  String contributionType = '';

  @override
  void dispose() {
  
    super.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allMemberProvider = Provider.of<AllMemberProvider>(context);
    final selectedMember = allMemberProvider.selectedMember;
    final getAgentDetails = Provider.of<AuthViewModel>(context);
    return AlertDialog(
      title: const Text('New Savings'),
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
                validator: (value) {
                  int totalSavingBalance = 0;
                  int amountToSave = 0;

                  try {
                    totalSavingBalance = int.parse(
                        selectedMember!.member.totalSavings.toString());
                    amountToSave = int.parse(amountController.text);

                    if (totalSavingBalance >= 0) {
                      contributionType = "Regular Savi";
                    } else if (totalSavingBalance < 0) {
                      final debtAmount = totalSavingBalance.abs();

                      if (amountToSave > debtAmount) {
                        amountToSave = debtAmount;
                        final errorMessage =
                            "Please settle the outstanding balance of \n  NGN$debtAmount before initiating new savings.";
                        return errorMessage;
                      } else {
                        contributionType = 'Loan Repayment';
                      }
                    } else {
                      if (amountToSave == 0) {
                        return 'Amount can\'t be less than 100';
                      }
                    }
                  } catch (e) {
                    Utils.toastMessage(
                        'Invalid input. Please enter a valid number.');
                    return 'Invalid input';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(height: 6),
            RadioListTile<String>(
              title: const Text('Cash'),
              value: 'Cash',
              groupValue: selectedRadioValue,
              onChanged: (value) {
                setState(() {
                  selectedRadioValue = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Transfer'),
              value: 'Transfer',
              groupValue: selectedRadioValue,
              onChanged: (value) {
                setState(() {
                  selectedRadioValue = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
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
              // ignore: unnecessary_null_comparison
              if (response == null) {
                return;
              }
              if (response.isTapConfirmButton) {
                String value = await DatabaseHelper.instance.addSavings(
                    MySavingsModel(
                        selectedMember!.member.memberId,
                        selectedMember.member.fullname,
                        amountController.text,
                        getAgentDetails.userid.toString(),
                        selectedMember.member.branch,
                        contributionType,
                        selectedRadioValue,
                        getAgentDetails.date,
                        getAgentDetails.formatted,
                        getAgentDetails.username));

                if (value == 'Successful') {
                  Utils.toastMessage('Successful');

                  Navigator.pushReplacementNamed(context, RouteName.allMembers);
                } else if (value == 'Error') {
                  Utils.toastMessage('Error');
                }
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
