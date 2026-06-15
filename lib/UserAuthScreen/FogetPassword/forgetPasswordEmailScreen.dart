import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Models/forgetPasswordModelEmail.dart';
import '../../Utils/Constants.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../core/config/supabase_config.dart';
import '../../core/session/auth_navigation.dart';
import '../../data/services/supabase_auth_flow_service.dart';
import '../../localization/Language/languages.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordEmailScreen> createState() =>
      _ForgetPasswordEmailScreenState();
}

class _ForgetPasswordEmailScreenState extends State<ForgetPasswordEmailScreen> {
  TextEditingController otpController = TextEditingController();
  TextEditingController? _controllerEmail;
  final _emailFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool firstState = false;

  final _emailKey = GlobalKey<FormFieldState>();

  ForgetPasswordModelEmail? forgetPasswordModelEmail;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0,
        leading: const SafeBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.2,
                  ),
                  Container(
                    width: width * 0.5,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.lock,
                      color: const Color(0xff3a6c83),
                      size: height * width * 0.0003,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: Text(Languages.of(context)!.resetPasswordtxt,
                        style: const TextStyle(
                            color: Color(0xff3a6c83),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Text(Languages.of(context)!.resetPasswordtxt2,
                          style: const TextStyle(
                              color: Color(0xff002333),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.center)),
                  Visibility(
                    visible: !firstState,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.05,
                          right: width * 0.05,
                          top: height * 0.05),
                      child: TextFormField(
                        key: _emailKey,
                        controller: _controllerEmail,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        validator: validateEmail,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus();
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
                                color: Color(0xFF256D85),
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
                  ),
                  Visibility(
                    visible: firstState,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.05,
                          right: width * 0.05,
                          top: height * 0.05),
                      child: TextFormField(
                        controller: otpController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                        enabled: false,
                        validator: validateOtp,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus();
                        },
                        decoration: const InputDecoration(
                            errorMaxLines: 3,
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                )),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                            hintText:
                                'Check your email, then open the reset link.',
                            // labelText: Languages.of(context)!.email,
                            hintStyle: TextStyle(
                              fontFamily: Constants.fontfamily,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.06),
                    child: ResuableMaterialButtonSmall(
                      onpress: () async {
                        if (firstState) {
                          goToLogin(context);
                        } else {
                          _checkInternetConnection();
                        }
                      },
                      buttonname: Languages.of(context)!.continuebtn,
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          color: Color(0xff1b4a6b),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  String? validateOtp(String? value) {
    if (value!.isEmpty) {
      return 'Enter OTP to verify';
    } else {
      return null;
    }
  }

  Future _checkInternetConnection() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      ToastConstant.showToast(context, "Internet Not Connected");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _callResetPassword1stAPI();
    }
  }

  Future _callResetPassword1stAPI() async {
    try {
      await SupabaseAuthFlowService().sendPasswordReset(
        email: _controllerEmail!.text.trim(),
        redirectTo: SupabaseConfig.authRedirectUrl,
      );
      if (!mounted) return;
      ToastConstant.showToast(context, "Password reset email sent");
      setState(() {
        firstState = true;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      ToastConstant.showToast(context, "Unable to send password reset email");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
