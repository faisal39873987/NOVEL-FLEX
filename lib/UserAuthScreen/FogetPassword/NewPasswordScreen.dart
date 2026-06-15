import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Models/ForgetPasswordModel.dart';
import '../../Models/ResetPasswordModel.dart';
import '../../Utils/Constants.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../data/services/supabase_auth_flow_service.dart';
import '../../localization/Language/languages.dart';
import '../login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  static const String id = 'forgetPassword_screen';
  String token;

  NewPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordFNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  final _passKey = GlobalKey<FormFieldState>();
  final _cPassKey = GlobalKey<FormFieldState>();

  TextEditingController? _passcontoller;
  TextEditingController? _cPAsscontroller;

  bool _autoValidate = false;

  bool _isLoading = false;

  ForgetPasswordModel? _forgetPasswordModel;
  ResetPasswordModel? _resetPasswordModel;

  @override
  void initState() {
    super.initState();
    _passcontoller = TextEditingController();
    _cPAsscontroller = TextEditingController();
  }

  @override
  void dispose() {
    _passcontoller!.dispose();
    _cPAsscontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          toolbarHeight: height * 0.1,
          title: Text(
            Languages.of(context)!.forgetPassword,
            style: const TextStyle(
                color: Color(0xff002333),
                fontWeight: FontWeight.w700,
                fontFamily: "Lato",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0.0,
          leading: const SafeBackButton(),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.05,
                        ),
                        mainText2(width),
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
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.1,
                                right: width * 0.04,
                                left: width * 0.04),
                            child: TextFormField(
                              key: _passKey,
                              controller: _passcontoller,
                              focusNode: _passwordFNode,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              validator: validatePassword,
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
                                  hintText: Languages.of(context)!.newFpassword,
                                  // labelText: Languages.of(context)!.email,
                                  hintStyle: const TextStyle(
                                    fontFamily: Constants.fontfamily,
                                  )),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.05,
                                right: width * 0.04,
                                left: width * 0.04),
                            child: TextFormField(
                              key: _cPassKey,
                              controller: _cPAsscontroller,
                              focusNode: _confirmPasswordFocusNode,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              obscureText: true,
                              validator: validateConfirmPassword,
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
                                  hintText:
                                      Languages.of(context)!.confirmnewpassword,
                                  // labelText: Languages.of(context)!.email,
                                  hintStyle: const TextStyle(
                                    fontFamily: Constants.fontfamily,
                                  )),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: height * 0.06),
                            child: ResuableMaterialButtonSmall(
                              onpress: () {
                                handleForgetUser();
                              },
                              buttonname: Languages.of(context)!.doneText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void handleResetUser() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey1.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey1.currentState!.save();
      //Call api
      // _checkInternetConnection();
      _checkInternetConnection1();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void handleForgetUser() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey1.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey1.currentState!.save();
      //Call api
      // _checkInternetConnection();
      _checkInternetConnection1();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _navigateAndRemove() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        ModalRoute.withName("login_screen"));
    // Fluttertoast.showToast(
    //     msg:
    //         "Verification Email is Sent to Your Given Email Address  Successfully!",
    //     gravity: ToastGravity.BOTTOM,
    //     backgroundColor: Colors.black87,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Widget mainText2(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Languages.of(context)!.newPasswordCreate,
            style: const TextStyle(
                color: Color(0xff3a6c83),
                fontWeight: FontWeight.w700,
                fontFamily: "Lato",
                fontStyle: FontStyle.normal,
                fontSize: 20.0),
            textAlign: TextAlign.center),
      ],
    );
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Please enter password';

    if (value.length < 6) {
      return 'Password should be more than 6 characters';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Please Enter Confirm Password';
    if (value != _passKey.currentState!.value) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  Future _checkInternetConnection1() async {
    // if (this.mounted) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      ToastConstant.showToast(context, "Internet Not Connected");
      // if (this.mounted) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }
    } else {
      _callForgetPassword1stAPI();
    }
  }

  Future _callForgetPassword1stAPI() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await SupabaseAuthFlowService().resetPassword(
        _passcontoller!.text.trim(),
      );
      if (!mounted) return;
      ToastConstant.showToast(context, "Password updated successfully");
      setState(() {
        _isLoading = false;
      });
      _navigateAndRemove();
    } catch (_) {
      if (!mounted) return;
      ToastConstant.showToast(
          context, "Open the password reset email link before updating");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
