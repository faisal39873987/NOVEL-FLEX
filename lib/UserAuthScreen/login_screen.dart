import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:sign_in_apple/apple_id_user.dart';
// import 'package:sign_in_apple/sign_in_apple.dart';
import 'package:transitioner/transitioner.dart';
import '../Models/CheckStatusModel.dart';
import '../Models/UserModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/reusable_button_small.dart';
import '../core/config/supabase_config.dart';
import '../core/session/auth_navigation.dart';
import '../data/services/supabase_auth_flow_service.dart';
import '../localization/Language/languages.dart';
import 'FogetPassword/forgetPasswordEmailScreen.dart';
import 'SignUpScreens/SignUpScreen_Second.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const String _googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '362340188692-sks0s537a6k98j6fuvqgfm4rpcqtuf4n.apps.googleusercontent.com',
  );
  static const String _googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
  static const String _appleServiceId =
      String.fromEnvironment('APPLE_SERVICE_ID');
  static const String _appleRedirectUri =
      String.fromEnvironment('APPLE_REDIRECT_URI');

  Map<String, dynamic>? _userData;

  static const String id = 'login_screen';

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _passwordKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();

  TextEditingController? _controllerEmail;
  TextEditingController? _controllerPassword;

  bool _autoValidate = false;

  bool _isLoading = false;

  UserModel? _userModel;
  CheckStatusModel? _checkStatusModel;

  String _errorMsg = "";

  String social_login_ID = "0";

  final String _name = 'Unknown';
  final String _mail = 'Unknown';
  final String _userIdentify = 'Unknown';
  final String _authorizationCode = 'Unknown';
  bool show = true;
  String? fcmToken;
  Dio dio = Dio();
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _listenForSupabaseAuth();
    getToken();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _controllerEmail!.dispose();
    _controllerPassword!.dispose();
    super.dispose();
  }

  void _listenForSupabaseAuth() {
    if (!SupabaseConfig.hasEnvironment) return;

    _authSubscription =
        SupabaseConfig.client.auth.onAuthStateChange.listen((state) async {
      if (!mounted) return;
      if (state.event != AuthChangeEvent.signedIn &&
          state.event != AuthChangeEvent.tokenRefreshed) {
        return;
      }

      await SupabaseAuthFlowService().syncSocialSession(
        context.read<UserProvider>(),
      );
      if (!mounted) return;

      final token = context.read<UserProvider>().UserToken;
      if (token != null && token.trim().isNotEmpty) {
        _navigateAndRemove();
      }
    });
  }

  void handleLoginUser() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _checkInternetConnection();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Fluttertoast.showToast(
        msg: "Internet Not Connected",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 14,
      );
      _errorMsg = "No internet connection.";
    } else {
      _callLoginAPI();
    }
  }

  _navigateAndRemove() {
    goToAuthenticatedHome(context);
  }

  getToken() async {
    SharedPreferences prefts = await SharedPreferences.getInstance();
    fcmToken = prefts.getString('fcm_token');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authBackgroundImage = width < 600
        ? 'assets/images/auth_mobile.png'
        : 'assets/images/auth_desktop.png';
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(authBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      mainText2(width),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                        height: height * 0.2,
                        width: width * 0.4,
                        child: Image.asset(
                            'assets/quotes_data/NoPath_3x-removebg-preview.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * 0.04),
                        child: TextFormField(
                          key: _emailKey,
                          controller: _controllerEmail,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          validator: validateEmail,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          decoration: InputDecoration(
                              errorMaxLines: 3,
                              counterText: "",
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.white12,
                                ),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF256D85),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF256D85),
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  )),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              hintText: Languages.of(context)!.email,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * 0.04),
                        child: Stack(
                          children: [
                            Positioned(
                              child: TextFormField(
                                key: _passwordKey,
                                controller: _controllerPassword,
                                focusNode: _passwordFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.black,
                                validator: validatePassword,
                                obscureText: show,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode);
                                },
                                decoration: InputDecoration(
                                  errorMaxLines: 3,
                                  counterText: "",
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF256D85),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.red,
                                      )),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  hintText: Languages.of(context)!.password,
                                  hintStyle: const TextStyle(
                                    fontFamily: Constants.fontfamily,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: height * 0.01,
                                left: context
                                            .read<UserProvider>()
                                            .SelectedLanguage ==
                                        'English'
                                    ? width * 0.8
                                    : 0.0,
                                right: context
                                            .read<UserProvider>()
                                            .SelectedLanguage ==
                                        'Arabic'
                                    ? width * 0.8
                                    : 0.0,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                    icon: show
                                        ? const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.black38,
                                          )
                                        : const Icon(
                                            Icons.remove_red_eye,
                                            color: Color(0xff3a6c83),
                                          )))
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Transitioner(
                              context: context,
                              // child: ForgetPasswordScreen(),
                              child: const ForgetPasswordEmailScreen(),
                              animation:
                                  AnimationType.slideLeft, // Optional value
                              duration: const Duration(
                                  milliseconds: 1000), // Optional value
                              replacement: false, // Optional value
                              curveType: CurveType.bounce, // Optional value
                            );
                          },
                          child: forgetPassword(height)),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.03),
                        child: ResuableMaterialButtonSmall(
                          onpress: () {
                            handleLoginUser();
                          },
                          buttonname: Languages.of(context)!.login,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: width * 0.2,
                                height: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0xff3a6c83))),
                            Text(Languages.of(context)!.continueWith,
                                style: const TextStyle(
                                    color: Color(0xff002333),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.center),
                            Container(
                                width: width * 0.2,
                                height: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0xff3a6c83)))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _loginWithGoogle();
                              },
                              child: SvgPicture.asset(
                                  "assets/quotes_data/google_login.svg", //asset location

                                  fit: BoxFit.scaleDown),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            GestureDetector(
                              onTap: () async {
                                _loginWithApple();
                              },
                              child: SvgPicture.asset(
                                  "assets/quotes_data/apple_login.svg", //asset location
                                  fit: BoxFit.scaleDown),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Visibility(
                    visible: _isLoading == true,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: Color(0xff1b4a6b),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Transitioner(
                        context: context,
                        child: SignUpScreen_Second(
                          ReferralUserID: "",
                        ),
                        animation: AnimationType.slideLeft, // Optional value
                        duration: const Duration(
                            milliseconds: 1000), // Optional value
                        replacement: true, // Optional value
                        curveType: CurveType.decelerate, // Optional value
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: height * 0.02,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          Languages.of(context)!.donthaveanaccountSignUp,
                          style: const TextStyle(
                              color: Color(0xff3a6c83),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainText(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.welcomenovelflex,
          style: TextStyle(
            color: Colors.black87,
            fontSize: width * 0.05,
            fontWeight: FontWeight.w800,
            fontFamily: Constants.fontfamily,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget mainSmallText(double height) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.02),
      child: Text(
        Languages.of(context)!.socailtext,
        style: TextStyle(
          color: Colors.black26,
          fontSize: height * 0.02,
          fontFamily: Constants.fontfamily,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget mainText2(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.login,
          style: const TextStyle(
              color: Color(0xff002333),
              fontWeight: FontWeight.w700,
              fontFamily: "Lato",
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget forgetPassword(double height) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.01,
                  right: height * 0.04,
                  left: height * 0.04),
              child: Text(
                Languages.of(context)!.forgetPassword,
                style: const TextStyle(
                    color: Color(0xff002333),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: height * 0.04, left: height * 0.04),
              child: SizedBox(
                width: width * 0.24,
                child: const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Email';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = new RegExp(pattern);
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Please enter password';

    if (value.length < 6) {
      return 'Password should be more than 6 characters';
    } else {
      return null;
    }
  }

  Future _callLoginAPI() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await SupabaseAuthFlowService().loginWithEmail(
        email: _controllerEmail!.text.trim(),
        password: _controllerPassword!.text.trim(),
        userProvider: context.read<UserProvider>(),
      );
      if (!mounted) return;
      _navigateAndRemove();
      ToastConstant.showToast(context, "Login Successfully");
    } catch (_) {
      if (!mounted) return;
      ToastConstant.showToast(context, "Invalid Credential!");
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    if (!SupabaseConfig.hasEnvironment) {
      ToastConstant.showToast(context, "Social sign-in is not configured.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (Platform.isAndroid) {
        await _loginWithOAuthRedirect(
          provider: OAuthProvider.google,
          providerName: "Google",
        );
        return;
      }

      final signIn = GoogleSignIn(
        clientId: Platform.isIOS ? _googleIosClientId : null,
        serverClientId:
            _googleWebClientId.isNotEmpty ? _googleWebClientId : null,
      );
      final account = await signIn.signIn();
      if (account == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final authentication = await account.authentication;
      final idToken = authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        await _loginWithOAuthRedirect(
          provider: OAuthProvider.google,
          providerName: "Google",
        );
        return;
      }

      await SupabaseAuthFlowService().loginWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authentication.accessToken,
        userProvider: context.read<UserProvider>(),
      );
      if (!mounted) return;
      _navigateAndRemove();
      ToastConstant.showToast(context, "Login Successfully");
    } catch (error) {
      if (!Platform.isAndroid) {
        try {
          await _loginWithOAuthRedirect(
            provider: OAuthProvider.google,
            providerName: "Google",
          );
          return;
        } catch (_) {
          // Surface the original native sign-in error below.
        }
      }
      if (!mounted) return;
      ToastConstant.showToast(context, "Google sign-in failed: $error");
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithApple() async {
    if (!SupabaseConfig.hasEnvironment) {
      ToastConstant.showToast(context, "Social sign-in is not configured.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (Platform.isAndroid) {
        await _loginWithOAuthRedirect(
          provider: OAuthProvider.apple,
          providerName: "Apple",
        );
        return;
      }

      final rawNonce = SupabaseConfig.client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
        webAuthenticationOptions: Platform.isAndroid
            ? WebAuthenticationOptions(
                clientId: _appleServiceId,
                redirectUri: Uri.parse(_appleRedirectUri),
              )
            : null,
      );

      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AuthException('Apple did not return an ID token.');
      }

      await SupabaseAuthFlowService().loginWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
        userProvider: context.read<UserProvider>(),
      );
      if (!mounted) return;
      _navigateAndRemove();
      ToastConstant.showToast(context, "Login Successfully");
    } catch (error) {
      if (!Platform.isAndroid) {
        try {
          await _loginWithOAuthRedirect(
            provider: OAuthProvider.apple,
            providerName: "Apple",
          );
          return;
        } catch (_) {
          // Surface the original native sign-in error below.
        }
      }
      if (!mounted) return;
      ToastConstant.showToast(context, "Apple sign-in failed: $error");
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithOAuthRedirect({
    required OAuthProvider provider,
    required String providerName,
  }) async {
    final started = await SupabaseAuthFlowService().loginWithOAuth(
      provider: provider,
      redirectTo: SupabaseConfig.authRedirectUrl,
    );

    if (!started) {
      throw AuthException('$providerName sign-in did not start.');
    }

    if (!mounted) return;
    ToastConstant.showToast(
      context,
      "$providerName sign-in opened. Complete login in the browser.",
    );
  }

  Future CHECK_STATUS_API(String id, String email) async {
    setState(() {
      _isLoading = true;
    });
    var map = <String, dynamic>{};
    map['email'] = email;
    map['google_id'] = id;

    final response = await http.post(
      Uri.parse(ApiUtils.CHECK_STATUS_API),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);

      if (jsonData['status'] == 200) {
        print('check_status_api_response: $jsonData');
        _checkStatusModel = CheckStatusModel.fromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
        if (_checkStatusModel!.data == "false") {
          ToastConstant.showToast(
              context, "Use email login while social sign-in is migrated.");
        } else {
          ToastConstant.showToast(
              context, "Use email login while social sign-in is migrated.");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ToastConstant.showToast(context, "Error!");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(context, "Internet Server Error!");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> initPlatformState() async {
  //   SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (AppleIdUser user) async {
  //     print("flutter receiveCode: \n");
  //     print(user.authorizationCode);
  //     print("flutter receiveToken \n");
  //     print(user.identifyToken);
  //     setState(() {
  //       _name = user.name ?? ""; // may be null or "" if use set privacy
  //       _mail = user.mail ?? ""; // may be null or "" if use set privacy
  //       _userIdentify = user.userIdentifier;
  //       _authorizationCode = user.authorizationCode;
  //     });
  //
  //     CHECK_STATUS_API("3",_mail);
  //
  //   }, onCompleteWithError: (AppleSignInErrorCode code) async {
  //     var errorMsg = "unknown";
  //     switch (code) {
  //       case AppleSignInErrorCode.canceled:
  //         errorMsg = "user canceled request";
  //         break;
  //       case AppleSignInErrorCode.failed:
  //         errorMsg = "request fail";
  //         break;
  //       case AppleSignInErrorCode.invalidResponse:
  //         errorMsg = "request invalid response";
  //         break;
  //       case AppleSignInErrorCode.notHandled:
  //         errorMsg = "request not handled";
  //         break;
  //       case AppleSignInErrorCode.unknown:
  //         errorMsg = "request fail unknown";
  //         break;
  //     }
  //     print(errorMsg);
  //   });
  // }

  void saveToPreferencesUserDetail(UserModel? userModel) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    userProvider.setUserEmail(userModel!.user.email);
    userProvider.setUserToken(userModel.user.accessToken);
    userProvider.setUserName(userModel.user.username);
    userProvider.setUserID(userModel.user.id.toString());
    userProvider.setUserImage(userModel.user.image.toString());
    userProvider.setSavedDate(DateTime.now().millisecondsSinceEpoch);
  }
}
