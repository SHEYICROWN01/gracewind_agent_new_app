import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/view/auth/register_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({super.key});

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool hidePassword = true;
  String username = "";
  String password = "";
  bool isLoading = true;
  bool isFirstLogin = true;
  bool _useTouchId = false;
  bool userHasTouchId = false;
  late SharedPreferences prefs;
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeGlobal.setTheme('authTheme');
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        isLoading = false;
      });
    });
    getSecureStorage();

    super.initState();
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'true';
    });
  }

  Future<void> authenticateWithFingerprint() async {
    final authViewModel = context.read<AuthViewModel>();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with fingerprint',
      );
    } catch (e) {
      Utils.snackBar('Error during fingerprint authentication: $e', context);
    }

    if (authenticated) {
      final userStoredUsername = await storage.read(key: 'username');
      final userStoredPassword = await storage.read(key: 'password');

      Map<String, dynamic> data = {
        "username": userStoredUsername,
        "password": userStoredPassword,
      };
      await authViewModel.loginApi(
          jsonEncode(data), context, username, password, _useTouchId);
    } else {
      // Fingerprint authentication failed or user canceled
      Utils.toastMessage('Fingerprint  canceled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.loading) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: SpinKitPouringHourGlassRefined(
          color: ColorConstant.primaryColor,
          size: 30.0,
        )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              //center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //logo image
                      Image(
                        image: AssetImage(ImageConstant.logo),
                        width: 100,
                        height: 100,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Welcome.",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text("Do login to continue"),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                        ),
                        validator: (val) {
                          if (val!.length < 2) {
                            return "Enter your username";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            username = val;
                          });
                        },
                      ),
                      TextFormField(
                        obscureText: hidePassword,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            child: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: ColorConstant.primaryColor,
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val!.length < 2) {
                            return "Enter your Password";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const Row(
                        children: [
                          Text("Don't have an account?"),
                          Register(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: ColorConstant.primaryColor),
                        onPressed: () => login(),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('Sign In')),
                        ),
                      ),
                      const Center(
                          // child: Register(),
                          ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          SizedBox(width: 20),
                          Text("Or login with"),
                          SizedBox(width: 20),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      userHasTouchId
                          ? GestureDetector(
                              onTap: () {
                                // authenticate();
                                authenticateWithFingerprint();
                              },
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: ColorConstant.primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Icon(
                                      Icons.fingerprint,
                                      size: 40,
                                    )),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  activeColor: ColorConstant.primaryColor,
                                  value: _useTouchId,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _useTouchId = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const Text(
                                  'Use Touch ID',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final authViewModel = context.read<AuthViewModel>();
      Map<String, dynamic> data = {
        "username": username,
        "password": password,
      };

      await authViewModel.loginApi(jsonEncode(data), context, username, password, _useTouchId);
    }
  }
}
