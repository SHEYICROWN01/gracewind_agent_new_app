import 'package:gracewind_agent_new_app/app_export.dart';

class ThirdActionBoard extends StatefulWidget {
  const ThirdActionBoard({
    super.key,
  });

  @override
  State<ThirdActionBoard> createState() => _ThirdActionBoardState();
}

class _ThirdActionBoardState extends State<ThirdActionBoard> {
  final TextEditingController _textFieldController = TextEditingController();
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.1), // Transparent black for the shadow
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3), // Changes the position of the shadow
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildExpanded('Update Member ', Icons.update,
                    () => Navigator.pushNamed(context, RouteName.updateMember)),
                buildExpanded('Member Data', Icons.data_saver_off,
                    () => Navigator.pushNamed(context, RouteName.memberData)),
                buildExpanded(
                    'Transactions by Date',
                    Icons.money,
                    () => Navigator.pushNamed(
                        context, RouteName.transactionByDate)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildExpanded('Note', Icons.note_alt_outlined,
                    () => Navigator.pushNamed(context, RouteName.noteView)),
                buildExpanded('Expenses ', Icons.account_balance_wallet_sharp,
                    () => Navigator.pushNamed(context, RouteName.dailyExpense)),
                buildExpanded(
                    'Account Report',
                    Icons.book,
                    () =>
                        Navigator.pushNamed(context, RouteName.accountSummary)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.hardEdge,
                      color: ColorConstant.primaryColor.withOpacity(0.1),
                      child: InkWell(
                        onTap: () {
                          _displayTextInputDialog(context);
                        },
                        // => Navigator.pushNamed(
                        //     context, RouteName.getDateForDeleteContribution),
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: ColorConstant.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'MGT Only',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildExpanded(
      String text, IconData iconData, void Function() onTap) {
    return Expanded(
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.hardEdge,
            color: ColorConstant.primaryColor.withOpacity(0.1),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  iconData,
                  color: ColorConstant.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Management Only'),
          content: Form(
            key: formKey, // Use the same form key as the parent widget
            autovalidateMode: AutovalidateMode.always, // Enable auto-validation
            child: TextFormField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                hintText: "Authorization Code",
              ),
              validator: (val) {
                if (val != "GraceWind2024") {
                  return "Enter a valid authorization code";
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _textFieldController.clear();
                  Navigator.pop(context);

                  Navigator.pushNamed(context, RouteName.managementScreen);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
