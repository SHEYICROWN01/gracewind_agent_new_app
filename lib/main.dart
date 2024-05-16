import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:gracewind_agent_new_app/controller/dailySavingsProvider.dart';
import 'package:gracewind_agent_new_app/controller/getWithdrawalProvider.dart';
import 'package:gracewind_agent_new_app/controller/local_activities_provider.dart';
import 'package:gracewind_agent_new_app/controller/savingsByDateProvider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://299d04f1a917d2b01e166732936bbb02@o4506616329797632.ingest.sentry.io/4506616345591808';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 0.01;
    },
    appRunner: () => runApp(const MyApp()),
  );

  try {
    int? test;
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        ChangeNotifierProvider<DashboardViewModel>(
            create: (_) => DashboardViewModel()),
        ChangeNotifierProvider<AllMemberProvider>(
            create: (_) => AllMemberProvider()),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider()),
        ChangeNotifierProvider<SavingsByDateProvider>(
            create: (_) => SavingsByDateProvider()),
        ChangeNotifierProvider<DailySavingsProvider>(
            create: (_) => DailySavingsProvider()),
        ChangeNotifierProvider<InstantMemberRecordProvider>(
            create: (_) => InstantMemberRecordProvider()),
        ChangeNotifierProvider<LocalActivitiesProvider>(
            create: (_) => LocalActivitiesProvider(context)),
        ChangeNotifierProvider<GetWithdrawalProvider>(
            create: (_) => GetWithdrawalProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grace Wind Consult',
        theme: ThemeData.light(useMaterial3: true).copyWith(
          primaryColor: ColorConstant.primaryColor,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: ColorConstant.primaryColor,
              selectionColor: ColorConstant.primaryColor),
          textTheme: ThemeData.light().textTheme.copyWith(
                // ignore: deprecated_member_use
                bodyText2: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
          bottomAppBarTheme:
              BottomAppBarTheme(color: ColorConstant.primaryColor),
        ),
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
