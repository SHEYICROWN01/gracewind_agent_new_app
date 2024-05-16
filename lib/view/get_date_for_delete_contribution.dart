import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/view/get_contribution_for_delete.dart';
import 'package:intl/intl.dart';

class SelectDateForDeleteContributions extends StatefulWidget {
  const SelectDateForDeleteContributions({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectDateForDeleteContributionsState createState() =>
      _SelectDateForDeleteContributionsState();
}

class _SelectDateForDeleteContributionsState
    extends State<SelectDateForDeleteContributions> {
  DateTime? _selectedDate;
  TextEditingController authorizationCode = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _goToNextPage(BuildContext context) {
    final getUsername = Provider.of<AuthViewModel>(context, listen: false);
    if (_selectedDate != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GetContributionsForDelete(
                  selectedDate: _selectedDate!,
                  username: getUsername.username.toString(),
                )),
      );
    } else {
      // Utils.toastMessage('Choose Date');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF24487C),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Select Date for savings'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF24487C),
                ),
                onPressed: () => _selectDate(context),
                child: const Text('Click here to select Date', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              if (_selectedDate != null)
                Text(
                    'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF24487C),
                ),
                onPressed: () {
                  debugPrint(_selectedDate.toString());
                  if(_selectedDate == null){
                    Utils.snackBar('Please select date to proceed',context);
                  }
                  _goToNextPage(context);
                },
                child: const Text('Proceed', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
