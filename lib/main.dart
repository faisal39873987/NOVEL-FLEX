import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:novelflex/TabScreens/home_screen.dart';
import 'package:novelflex/UserAuthScreen/SignUpScreens/SignUpScreen_Second.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import 'Provider/UserProvider.dart';
import 'Provider/VariableProvider.dart';
import 'UserAuthScreen/login_screen.dart';
import 'core/config/supabase_config.dart';
import 'core/session/auth_navigation.dart';
import 'data/services/supabase_auth_flow_service.dart';
import 'localization/locale_constants.dart';
import 'localization/localizations_delegate.dart';
import 'phone_ui/phone_onboarding_preferences_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

BuildContext? context1;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

Future<void> main() async {
  // HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.hasEnvironment) {
    await SupabaseConfig.initialize();
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(Phoenix(child: MyApp(sharedPreferences: prefs)));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
);

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  MyApp({super.key, required this.sharedPreferences});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  String? token;

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    const iosInitializationSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: iosInitializationSetting);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    setFCMToken();
  }

  setFCMToken() async {
    SharedPreferences prefts = await SharedPreferences.getInstance();
    token = "notifications_removed";
    prefts.setString('fcm_token', token.toString());
    print(" token__ $token");
  }

  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(widget.sharedPreferences)),
        ChangeNotifierProvider<VariableProvider>(
            create: (context) => VariableProvider()),
      ],
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        locale: _locale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: const SplashFirst(),
        routes: {
          'tab_screen': (context) => const TabScreen(),
          'login_screen': (context) => const LoginScreen(),
        },
      ),
    );
  }
}

class SplashFirst extends StatefulWidget {
  const SplashFirst({Key? key}) : super(key: key);

  @override
  State<SplashFirst> createState() => _SplashFirstState();
}

class _SplashFirstState extends State<SplashFirst> with WidgetsBindingObserver {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenForAuthChanges();
    expireToken();
    Timer(const Duration(microseconds: 0), () async {
      final userProvider = context.read<UserProvider>();
      final usesSupabase = SupabaseConfig.hasEnvironment;

      if (usesSupabase) {
        await SupabaseAuthFlowService().syncProvider(
          userProvider,
        );
      }

      final token = userProvider.UserToken;
      final hasToken = token != null && token.trim().isNotEmpty;
      final isGuest = userProvider.IsGuest;
      final shouldShowAuth =
          !isGuest && (!hasToken || (!usesSupabase && expireToken() >= 13));
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool(
            PhoneOnboardingPreferencesScreen.completedKey,
          ) ??
          false;

      if (!onboardingCompleted) {
        Transitioner(
          context: context,
          child: PhoneOnboardingPreferencesScreen(
            nextScreen: shouldShowAuth ? const SplashPage() : const TabScreen(),
          ),
          animation: AnimationType.fadeIn, // Optional value
          duration: const Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      } else if (shouldShowAuth) {
        Transitioner(
          context: context,
          child: const SplashPage(),
          animation: AnimationType.fadeIn, // Optional value
          duration: const Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      } else {
        Transitioner(
          context: context,
          child: const TabScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: const Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      }
    });
  }

  void _listenForAuthChanges() {
    if (!SupabaseConfig.hasEnvironment) return;

    _authSubscription =
        SupabaseConfig.client.auth.onAuthStateChange.listen((state) async {
      if (!mounted) return;
      await SupabaseAuthFlowService()
          .syncProvider(context.read<UserProvider>());

      if (state.event == AuthChangeEvent.passwordRecovery) {
        showPasswordRecoveryScreen();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  int expireToken() {
    final currentTime = DateTime.now();
    final savedTime = context.read<UserProvider>().GetSavedTime == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(
            context.read<UserProvider>().GetSavedTime!);
    final diffDay = currentTime.difference(savedTime).inDays;
    print("days differences for expiry token $diffDay");

    return diffDay;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xffebf5f9),
        body: Center(
            child: CupertinoActivityIndicator(color: Color(0xff1b4a6b))));
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().setLanguage('English');
      changeLanguage(context, 'en');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/quotes_data/bg_login.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: height * 0.15,
            // left: _width*0.5,
            child: Container(
              height: height * 0.2,
              width: width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/quotes_data/NoPath_3x-removebg-preview.png',
                      ),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            top: height * 0.4,
            left: width * 0.2,
            child: Container(
                width: 256,
                height: 2,
                decoration: const BoxDecoration(color: Color(0xff333333))),
          ),
          Positioned(
            top: height * 0.45,
            left: context.read<UserProvider>().SelectedLanguage == 'English'
                ? width * 0.1
                : 0.0,
            right: context.read<UserProvider>().SelectedLanguage == 'Arabic'
                ? width * 0.05
                : 0.0,
            child: Text(Languages.of(context)!.labelWelcome,
                style: const TextStyle(
                    color: Color(0xff101010),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
          ),
          Positioned(
              top: height * 0.7,
              left: width * 0.1,
              child: GestureDetector(
                onTap: () {
                  Transitioner(
                    context: context,
                    child: const LoginScreen(),
                    animation: AnimationType.slideLeft, // Optional value
                    duration:
                        const Duration(milliseconds: 1000), // Optional value
                    replacement: true, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                },
                child: Container(
                  width: width * 0.83,
                  height: height * 0.06,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x24000000),
                            offset: Offset(0, 7),
                            blurRadius: 14,
                            spreadRadius: 0)
                      ],
                      color: Color(0xff3a6c83)),
                  child: Center(
                    child: Text(
                      Languages.of(context)!.login,
                      style: const TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ),
                  ),
                ),
              )),
          Positioned(
            top: height * 0.79,
            left: width * 0.1,
            child: GestureDetector(
              onTap: () {
                context.read<UserProvider>().startGuestSession();
                Transitioner(
                  context: context,
                  child: SignUpScreen_Second(
                    ReferralUserID: "",
                  ),
                  animation: AnimationType.slideLeft, // Optional value
                  duration:
                      const Duration(milliseconds: 1000), // Optional value
                  replacement: true, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              },
              child: Container(
                width: width * 0.83,
                height: height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    )),
                child: Center(
                  child: Text(
                    Languages.of(context)!.signup,
                    style: const TextStyle(
                        color: Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.05,
            left: context.read<UserProvider>().SelectedLanguage == 'English'
                ? width * 0.8
                : width * 0.02,
            child: GestureDetector(
              child: Column(
                children: [
                  Text(
                    context.read<UserProvider>().SelectedLanguage == 'English'
                        ? "🇦🇪"
                        : "🇺🇸",
                    style: TextStyle(fontSize: width * height * 0.0001),
                  ),
                  Text(
                    context.read<UserProvider>().SelectedLanguage == 'English'
                        ? "العربية"
                        : "English ",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ],
              ),
              onTap: () {
                UserProvider userProviderlng =
                    Provider.of<UserProvider>(this.context, listen: false);
                if (userProviderlng.SelectedLanguage == 'English') {
                  userProviderlng.setLanguage('Arabic');
                  changeLanguage(context, 'ar');
                } else {
                  userProviderlng.setLanguage('English');
                  changeLanguage(context, 'en');
                }
              },
            ),
          ),
          Positioned(
            top: height * 0.88,
            left: width * 0.1,
            child: GestureDetector(
              onTap: () {
                Transitioner(
                  context: context,
                  child: HomeScreen(
                    route: "guest",
                  ),
                  animation: AnimationType.slideLeft, // Optional value
                  duration:
                      const Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              },
              child: Container(
                width: width * 0.83,
                height: height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    )),
                child: Center(
                  child: Text(
                    Languages.of(context)!.guest,
                    style: const TextStyle(
                        color: Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? Positioned(
                  top: height * 0.6,
                  left: width * 0.4,
                  right: width * 0.4,
                  child: const CupertinoActivityIndicator(
                    color: Color(0xff1b4a6b),
                  ))
              : Container()
        ],
      ),
    );
  }
}
