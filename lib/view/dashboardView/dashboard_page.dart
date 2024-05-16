import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = const FlutterSecureStorage();
  // final PageController _pageController = PageController();
  String? currentUser;
  DateTime timeBackPress = DateTime.now();
  Future<bool> _onWillPop() async {
    final difference = DateTime.now().difference(timeBackPress);
    final isExitWarning = difference >= const Duration(seconds: 2);
    timeBackPress = DateTime.now();

    if (isExitWarning) {
      Future.delayed(Duration.zero, () {
        Utils.toastMessage('Press back again to exit');
      });
      return true;
    } else {
      Fluttertoast.cancel();
      exit(0);

    }

  }

  int currentPage = 0;
  int currentChip = 0;
  bool isLoading = true;

  String getGreeting() {
    var now = DateTime.now();
    var formatter = DateFormat('H');
    var hour = int.parse(formatter.format(now));

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void initState() {
    // final wantsTouchId = Provider.of<AuthViewModel>(context).wantsTouchId;
    getGreeting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeGlobal.setTheme('cryptoDashboardTheme');
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        isLoading = false;
      });
    });

    //authenticate();

    setState(() {
      
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the AuthViewModel after the widget has been fully initialized
    final authViewModel = Provider.of<AuthViewModel>(context);
    if (authViewModel.wantsTouchId) {
      authenticateWithFingerprint();
    }
  }

  void authenticate() async {
    final username = Provider.of<AuthViewModel>(context).username;
    final password = Provider.of<AuthViewModel>(context).password;
    bool authenticated = false;
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          authenticated = await auth.authenticate(
              localizedReason: 'Enable Face ID to sign in more easily');
          if (authenticated) {
            storage.write(key: 'username', value: username);
            storage.write(key: 'password', value: password);
            storage.write(key: 'usingBiometric', value: 'true');
          }
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          final authenticated = await auth.authenticate(
              localizedReason: 'Enable Face ID to sign in more easily');
          if (authenticated) {
            storage.write(key: 'username', value: username);
            storage.write(key: 'password', value: password);
            storage.write(key: 'usingBiometric', value: 'true');
          }
        }
      }
    } else {
      debugPrint('cant check');
    }
  }

  Future<void> authenticateWithFingerprint() async {
    final username = Provider.of<AuthViewModel>(context).username;
    final password = Provider.of<AuthViewModel>(context).password;
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with fingerprint for the first time');
    } catch (e) {
      debugPrint('Error during fingerprint authentication: $e');
    }

    if (authenticated) {
      storage.write(key: 'username', value: username);
      storage.write(key: 'password', value: password);
      storage.write(key: 'usingBiometric', value: 'true');
      Utils.toastMessage('Authenticated');
    } else {
      //Utils.toastMessage('Fingerprint authentication failed or canceled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final getUsername = Provider.of<AuthViewModel>(context, listen: true);

    return ChangeNotifierProvider(
        create: (_) =>
            DashboardViewModel()..fetchDashboardData(getUsername.username!),
        child: Consumer<DashboardViewModel>(builder: (_, viewModel, __) {
          return PopScope(
              canPop: false,
              onPopInvoked : (didPop){
                _onWillPop();
              },

            // canPop:_onWillPop ,
            // onWillPop: _onWillPop,
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showMemberDetail(context),
                            child: Hero(
                              tag: 'profilepics',
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    width: getSize(
                                        65.0), // Adjust the size as needed
                                    height: getSize(
                                        65.0), // Adjust the size as needed
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: ColorConstant.primaryColor,
                                          width: 2.0),
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        height: height,
                                        width: width,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            '${AppUrl.domainName}${getUsername.image}',
                                        placeholder: (context, url) => SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: LinearProgressIndicator(
                                            color: Colors.grey.shade200,
                                            backgroundColor: Colors.grey.shade100,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          ImageConstant.imgEllipse1,
                                          height: height,
                                          width: width,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                    ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                                '${getGreeting()}, ${getUsername.username}'
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, RouteName.notification),
                            child: const badges.Badge(
                              badgeContent: Text('3'),
                              badgeStyle:
                                  badges.BadgeStyle(badgeColor: Colors.red),
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(
                              Icons.logout,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const MainBoard(),
                      const SecondActionButton(),
                      const ThirdActionBoard(),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: 0,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                selectedItemColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.black,
                items: const [
                  BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(Icons.home_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: "Wallet",
                    icon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: "Activity",
                    icon: Icon(Icons.bar_chart_outlined),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancel",
            title: "Are you sure?",
            text: "Logout Now!",
            confirmButtonText: "Yes, Logout",
            type: ArtSweetAlertType.warning));

    // ignore: unrelated_type_equality_checks
    if (response == false) {
      return;
    }

    if (response.isTapConfirmButton) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginAuth()),
      );

      return;
    }
  }

  Future<void> _showMemberDetail(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const MemberDetailScreenPic();
        },
      ),
    );
  }
}

class MemberDetailScreenPic extends StatelessWidget {
  const MemberDetailScreenPic({super.key});

  @override
  Widget build(BuildContext context) {
    final getUsername = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
            tag: 'profilepics',
            child: CachedNetworkImage(
              imageUrl: '${AppUrl.domainName}${getUsername.image}',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
