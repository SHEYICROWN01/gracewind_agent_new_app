import 'package:intl/intl.dart';
import 'package:gracewind_agent_new_app/app_export.dart';

class AuthViewModel extends ChangeNotifier {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  bool _loading = false;
  String? _username;
  int? _userid;
  String? _image;
  String? _date;
  String? _password;
  bool _wantsTouchId = false;

  bool get loading => _loading;
  String? get username => _username;
  int? get userid => _userid;
  String? get image => _image;
  String? get date => _date;
  String? get password => _password;
  bool get wantsTouchId => _wantsTouchId;

  final _myRepo = DataRepository();
  Future<void> loginApi(
    dynamic data,
    BuildContext context,
    user,
    password,
    bool wantsTouchId,
  ) async {
    _loading = true;
    notifyListeners();
    _password = password;
    _wantsTouchId = wantsTouchId;

    _myRepo.loginApi(data).then((value) {
      _loading = false;
      var getValue = value;
      _userid = getValue['userid'];
      _username = getValue['username'];
      _image = getValue['image'];
      _date = formatted;

      // Navigate to the dashboard view if previousRoute is null
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.dashboardView,
            (route) => false, // Remove all routes in the stack
      );


      notifyListeners();
    }).onError((error, stackTrace) {
      _loading = false;
      Utils.snackBar(error.toString(), context);
      notifyListeners();
    }).whenComplete(() {
      _loading = false;
      notifyListeners();
    });
  }
}
