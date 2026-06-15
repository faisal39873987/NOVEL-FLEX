import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:novelflex/UserAuthScreen/SignUpScreens/signUpScreen_Third.dart';
import 'package:transitioner/transitioner.dart';
import '../../Models/UserModel.dart';
import '../../Utils/Constants.dart';
import '../../Utils/navigation_utils.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';
import '../login_screen.dart';

class SignUpScreen_Second extends StatefulWidget {
  static const String id = 'signUp_screen';
  String? ReferralUserID;

  SignUpScreen_Second({Key? key, required this.ReferralUserID})
      : super(key: key);

  @override
  State<SignUpScreen_Second> createState() => _SignUpScreen_SecondState();
}

class _SignUpScreen_SecondState extends State<SignUpScreen_Second> {
  final _fullnameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmpasswordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'GlobalFormKey #SignIn ');

  String? phone;
  String? country = '+971';

  final _fullNameKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  final String _errorMsg = "";

  TextEditingController? _controllerFullName;
  TextEditingController? _controllerEmail;
  TextEditingController? _controllerPhoneNumber;
  TextEditingController? _controllerPassword;
  TextEditingController? _phoneController;

  bool _autoValidate = false;

  final bool _isLoading = false;

  UserModel? _userModel;

  @override
  void initState() {
    super.initState();
    _controllerFullName = TextEditingController();
    _controllerEmail = TextEditingController();
    _controllerPhoneNumber = TextEditingController();
    _controllerPassword = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _controllerFullName!.dispose();
    _controllerEmail!.dispose();
    _controllerPhoneNumber!.dispose();
    _controllerPassword!.dispose();
    _phoneController!.dispose();
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
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    mainText2(width),
                    SizedBox(
                      height: height * 0.2,
                      width: width * 0.4,
                      child: Image.asset(
                          'assets/quotes_data/NoPath_3x-removebg-preview.png'),
                    ),
                    mainText(width),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.04,
                          bottom: height * 0.01,
                          left: width * 0.04,
                          right: width * 0.04),
                      child: TextFormField(
                        key: _fullNameKey,
                        controller: _controllerFullName,
                        focusNode: _fullnameFocusNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        validator: validateFullName,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
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
                            hintText: Languages.of(context)!.userName,
                            // labelText: Languages.of(context)!.userName,
                            hintStyle: const TextStyle(
                              fontFamily: Constants.fontfamily,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.04),
                      child: TextFormField(
                        key: _emailKey,
                        controller: _controllerEmail,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        validator: validateEmail,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phoneFocusNode);
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
                          vertical: height * 0.01, horizontal: width * 0.04),
                      child: SizedBox(
                        height: height * 0.095,
                        child: IntlPhoneField(
                          controller: _phoneController,
                          initialCountryCode: 'AE',
                          cursorColor: Colors.black12,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              errorMaxLines: 1,
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
                              hintText: Languages.of(context)!.phoneNumber,
                              // labelText: Languages.of(context)!.password,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            // _phoneController!.text = phone.completeNumber;
                          },
                          onCountryChanged: (phone) {
                            print('Country code changed to: ${phone.dialCode}');
                            country = phone.dialCode;
                          },
                        ),
                      ),

                      // TextFormField(
                      //   key: _confirPasswordKey,
                      //   controller: _controllerConfirmPassword,
                      //   focusNode: _confirmpasswordFocusNode,
                      //   keyboardType: TextInputType.text,
                      //   textInputAction: TextInputAction.done,
                      //   obscureText: true,
                      //   cursorColor: Colors.black,
                      //   validator: validateConfirmPassword,
                      //   onFieldSubmitted: (_) {
                      //     handleRegisterUser();
                      //   },
                      //   decoration:  InputDecoration(
                      //     errorMaxLines: 3,
                      //     counterText: "",
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     focusedBorder: const OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       borderSide: BorderSide(
                      //         width: 1,
                      //         color:  Colors.black12,
                      //       ),
                      //     ),
                      //     disabledBorder: const OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       borderSide: BorderSide(
                      //         width: 1,
                      //         color:  Color(0xFF256D85),
                      //       ),
                      //     ),
                      //     enabledBorder: const OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       borderSide: BorderSide(
                      //         width: 1,
                      //         color:  Color(0xFF256D85),
                      //       ),
                      //     ),
                      //     border: const OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       borderSide: BorderSide(
                      //         width: 1,
                      //       ),
                      //     ),
                      //     errorBorder: const OutlineInputBorder(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(10)),
                      //         borderSide: BorderSide(
                      //           width: 1,
                      //           color: Colors.red,
                      //         )),
                      //     focusedErrorBorder: const OutlineInputBorder(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       borderSide: BorderSide(
                      //         width: 1,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //     hintText: Languages.of(context)!.confirmpassword,
                      //     // labelText: Languages.of(context)!.confirmpassword,
                      //     hintStyle: const TextStyle(
                      //       fontFamily: Constants.fontfamily,
                      //     )
                      //   ),
                      // ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.04),
                      child: TextFormField(
                        key: _passwordKey,
                        controller: _controllerPassword,
                        focusNode: _passwordFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        validator: validatePassword,
                        obscureText: true,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_confirmpasswordFocusNode);
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
                            hintText: Languages.of(context)!.password,
                            // labelText: Languages.of(context)!.password,
                            hintStyle: const TextStyle(
                              fontFamily: Constants.fontfamily,
                            )),
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      height: height * 0.06,
                      margin: EdgeInsets.only(top: height * 0.05),
                      child: ResuableMaterialButtonSmall(
                        onpress: () {
                          // setState(() {
                          //   _isLoading=true;
                          // });
                          handleRegisterUser();
                        },
                        buttonname: Languages.of(context)!.register,
                      ),
                    ),
                    GestureDetector(
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
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const LoginScreen()),
                        //     ModalRoute.withName("login_screen"));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: height * 0.08,
                        ),
                        child: Text(
                          Languages.of(context)!.alreadyhaveAccountSignIn,
                          style: const TextStyle(
                              color: Color(0xff3a6c83),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget mainText(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.createAccount,
          style: const TextStyle(
              color: Color(0xff002333),
              fontWeight: FontWeight.w700,
              fontFamily: "Lato",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String? validateFullName(String? value) {
    if (value!.isEmpty) {
      return 'Enter Full Name';
    } else {
      return null;
    }
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

  String? validateMobile(String? value) {
    //Mobile number are of 10 digit only
    if (value!.length < 10) {
      return 'Mobile Number cannot be less than 10';
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

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Please Enter Confirm Password';
    if (value != _passwordKey.currentState!.value) {
      return 'Password do not match';
    } else {
      return null;
    }
  }

  void handleRegisterUser() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("phone_number== +${country! + _phoneController!.text.toString()}");
      Transitioner(
        context: context,
        child: SingUpScreen_Third(
          name: _controllerFullName!.text.toString(),
          email: _controllerEmail!.text.toString(),
          password: _controllerPassword!.text.toString(),
          phone: country! + _phoneController!.text.toString(),
          route: "signup",
          photoUrl: "",
        ),
        animation: AnimationType.slideLeft, // Optional value
        duration: const Duration(milliseconds: 1000), // Optional value
        replacement: false, // Optional value
        curveType: CurveType.decelerate, // Optional value
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget reusableTextFormField(
      {var key,
      var controller,
      var focusNode,
      var validator,
      var focusnodeNext,
      var hintText,
      var height,
      var width}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.02, horizontal: width * 0.04),
      child: TextFormField(
        key: key,
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.black,
        validator: validator,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(focusnodeNext);
        },
        decoration: InputDecoration(
          errorMaxLines: 3,
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.blue,
            ),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.blue,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.blue,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
            ),
          ),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Colors.red,
              )),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget mainText2(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.signup,
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
}
