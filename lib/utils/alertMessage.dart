// import 'package:another_flushbar/flushbar.dart';
// import 'package:another_flushbar/flushbar_route.dart';
import 'package:gracewind_agent_new_app/app_export.dart';

class Utils {
  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 10.0);
  }

  // static flushBarErrorMessage(String msg, BuildContext context) {
  //   showFlushbar(
  //       context: context,
  //       flushbar: Flushbar(
  //         message: msg,
  //         forwardAnimationCurve: Curves.bounceInOut,
  //         borderRadius: BorderRadius.circular(8),
  //         padding: const EdgeInsets.all(35),
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         backgroundColor: const Color.fromARGB(255, 243, 0, 0),
  //         duration: const Duration(seconds: 3),
  //         reverseAnimationCurve: Curves.easeInOut,
  //         positionOffset: 20,
  //         icon: const Icon(
  //           Icons.error,
  //           size: 20,
  //           color: Colors.white,
  //         ),
  //       )..show(context));
  // }

  static snackBar(String msg, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(msg)));
  }
}
