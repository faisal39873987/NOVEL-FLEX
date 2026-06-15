import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/UserAuthScreen/SignUpScreens/signUpScreen_Author.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:transitioner/transitioner.dart';
import '../../Models/UserModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../core/session/auth_navigation.dart';
import '../../data/services/supabase_auth_flow_service.dart';
import '../../localization/Language/languages.dart';

class SingUpScreen_Third extends StatefulWidget {
  String name;
  String email;
  String password;
  String phone;
  String route;
  String photoUrl;

  SingUpScreen_Third(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.phone,
      required this.route,
      required this.photoUrl});

  @override
  State<SingUpScreen_Third> createState() => _SingUpScreen_ThirdState();
}

class _SingUpScreen_ThirdState extends State<SingUpScreen_Third> {
  bool isReader = false;
  bool isWriter = true;
  bool _isLoading = false;
  UserModel? _userModel;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        title: Text(
          Languages.of(context)!.signup,
          style: TextStyle(
              color: const Color(0xFF256D85), fontSize: width * 0.043),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: height * 0.03,
              color: Colors.black54,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          mainText(width),
          InkWell(
            onTap: () {
              setState(() {
                isWriter = true;
                isReader = false;
                warningAuthor();
              });
            },
            child: Container(
              width: width * 0.8,
              height: height * 0.2,
              decoration: isWriter
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: const Color(0xff30fc56), width: 3),
                      color: isWriter
                          ? const Color(0xff3a6c83)
                          : const Color(0xffebf5f9))
                  : BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: const Color(0xff3a6c83), width: 3)),
              child: Stack(
                children: [
                  Positioned(
                      left: width * 0.1,
                      top: height * 0.1,
                      child: Text(Languages.of(context)!.iamWriter,
                          style: TextStyle(
                              color: isWriter
                                  ? const Color(0xffffffff)
                                  : const Color(0xff002333),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center)),
                  Positioned(
                      left: width * 0.17,
                      top: height * 0.05,
                      child: Image.asset(
                        "assets/quotes_data/extra_pngs/penfancy.png",
                        color: isWriter
                            ? const Color(0xffffffff)
                            : const Color(0xff002333),
                      )),
                  Positioned(
                      left: width * 0.5,
                      top: height * 0.05,
                      child: Image.asset(
                          "assets/quotes_data/extra_pngs/WritingIllustration.png")),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isWriter = false;
                isReader = true;
                warning();
              });
            },
            child: Container(
              width: width * 0.8,
              height: height * 0.2,
              decoration: isReader
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: const Color(0xff30fc56), width: 3),
                      color: isReader
                          ? const Color(0xff3a6c83)
                          : const Color(0xffebf5f9))
                  : BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: const Color(0xff3a6c83), width: 3)),
              child: Stack(
                children: [
                  Positioned(
                      left: width * 0.1,
                      top: height * 0.1,
                      child: Text(Languages.of(context)!.iamreader,
                          style: TextStyle(
                              color: isReader
                                  ? const Color(0xffffffff)
                                  : const Color(0xff002333),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center)),
                  Positioned(
                      left: width * 0.17,
                      top: height * 0.05,
                      child: Image.asset(
                        "assets/quotes_data/extra_pngs/glasses.png",
                        color: isReader
                            ? const Color(0xffffffff)
                            : const Color(0xff002333),
                      )),
                  Positioned(
                      left: width * 0.35,
                      top: height * 0.04,
                      child: Image.asset(
                          "assets/quotes_data/extra_pngs/VNU_M527_04.png")),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isLoading == true,
            child: const Center(
              child: CupertinoActivityIndicator(
                color: Color(0xff1b4a6b),
              ),
            ),
          ),
          Container(
            width: width * 0.9,
            height: height * 0.06,
            margin: EdgeInsets.only(top: height * 0.05),
            child: ResuableMaterialButtonSmall(
              onpress: () {
                if (isWriter) {
                  if (widget.route == "login") {
                    Transitioner(
                      context: context,
                      child: SignUpAuthorScreen(
                        name: widget.name,
                        email: widget.email,
                        password: widget.password,
                        status: "writer",
                        phone: widget.phone,
                        photoUrl: widget.photoUrl,
                        lstatus: "login",
                      ),
                      animation: AnimationType.slideLeft, // Optional value
                      duration:
                          const Duration(milliseconds: 1000), // Optional value
                      replacement: false, // Optional value
                      curveType: CurveType.decelerate,
                    );
                  } else {
                    Transitioner(
                      context: context,
                      child: SignUpAuthorScreen(
                        name: widget.name,
                        email: widget.email,
                        password: widget.password,
                        status: "writer",
                        phone: widget.phone,
                        photoUrl: "",
                        lstatus: "",
                      ),
                      animation: AnimationType.slideLeft, // Optional value
                      duration:
                          const Duration(milliseconds: 1000), // Optional value
                      replacement: true, // Optional value
                      curveType: CurveType.decelerate,
                    );
                  }
                } else {
                  if (widget.route == "login") {
                    _checkInternetConnection2();
                  } else {
                    _checkInternetConnection();
                  }
                }
              },
              buttonname: Languages.of(context)!.register,
            ),
          ),
          const SizedBox(),
          const SizedBox()
        ],
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

  Widget mainText(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.selectAccountType,
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

  void warning() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      animType: QuickAlertAnimType.slideInUp,
      confirmBtnColor: const Color(0xFF256D85),
      text:
          "${Languages.of(context)!.dialogTitle} Reader ${Languages.of(context)!.dialogTitleN}",
    );
  }

  void warningAuthor() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      animType: QuickAlertAnimType.slideInUp,
      confirmBtnColor: const Color(0xFF256D85),
      text:
          "${Languages.of(context)!.dialogTitle} Author ${Languages.of(context)!.dialogTitleY}",
    );
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
      READER_REGISTER_API();
    }
  }

  Future _checkInternetConnection2() async {
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
      READER_SOCIAL_API();
    }
  }

  Future READER_REGISTER_API() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await SupabaseAuthFlowService().signUpReader(
        email: widget.email.trim(),
        password: widget.password.trim(),
        username: widget.name.trim(),
        phone: widget.phone.trim(),
        userProvider: context.read<UserProvider>(),
      );
      if (!mounted) return;
      ToastConstant.showToast(context, "Registration successful");
      _navigateAndRemove();
    } catch (_) {
      if (!mounted) return;
      ToastConstant.showToast(context, "Registration failed. Try again.");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future READER_SOCIAL_API() async {
    setState(() {
      _isLoading = true;
    });

    var map = <String, dynamic>{};
    map['username'] = widget.name.trim();
    map['email'] = widget.email.trim();
    map['google_id'] = widget.phone.trim();
    map['type'] = "reader";

    final response = await http.post(
      Uri.parse(ApiUtils.USER_SOCIAL_REGISTER),
      body: map,
    );

    var jsonData;

    switch (response.statusCode) {
      case 200:
        //Success

        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 200) {
          print("reader_ social_response${jsonData.toString()}");
          ToastConstant.showToast(context, jsonData['message'].toString());
          _navigateAndRemove();
          setState(() {
            _isLoading = false;
          });
        } else {
          ToastConstant.showToast(context, jsonData['message'].toString());
          setState(() {
            _isLoading = false;
          });
        }

        break;
      case 401:
        jsonData = json.decode(response.body);
        print('jsonData 401: $jsonData');
        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_401);

        break;
      case 404:
        jsonData = json.decode(response.body);
        print('jsonData 404: $jsonData');

        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_404);

        break;
      case 400:
        jsonData = json.decode(response.body);
        print('jsonData 400: $jsonData');

        ToastConstant.showToast(context, 'Email already Exist.');

        break;
      case 405:
        jsonData = json.decode(response.body);
        print('jsonData 405: $jsonData');
        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_405);

        break;
      case 422:
        jsonData = json.decode(response.body);
        print('jsonData 422: $jsonData');

        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_422);
        break;
      case 500:
        jsonData = json.decode(response.body);
        print('jsonData 500: $jsonData');

        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_500);

        break;
      default:
        jsonData = json.decode(response.body);
        print('jsonData failed: $jsonData');

        ToastConstant.showToast(context, "Login Failed Try Again");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _navigateAndRemove() {
    navigateAfterAuthMutation(context);
  }

  signUp({String? email, String? password}) async {
    _navigateAndRemove();
  }
}
