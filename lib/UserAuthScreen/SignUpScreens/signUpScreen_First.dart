import 'package:custom_signin_buttons/button_builder.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/UserAuthScreen/login_screen.dart';
import '../../Utils/navigation_utils.dart';
import '../../localization/Language/languages.dart';
import 'SignUpScreen_Second.dart';
import 'dart:io';

class SignUpScreen_First extends StatefulWidget {
  const SignUpScreen_First({Key? key}) : super(key: key);

  @override
  State<SignUpScreen_First> createState() => _SignUpScreen_FirstState();
}

class _SignUpScreen_FirstState extends State<SignUpScreen_First> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              mainText2(width),
              SizedBox(
                height: height * 0.1,
                width: width * 0.6,
                child: Image.asset(
                  'assets/quotes_data/NoPath.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSignInButton(
                    text: 'Sign In With Email',
                    customIcon: Icons.email,
                    iconLeftPadding: width * 0.06,
                    iconSize: height * width * 0.0001,
                    height: height * 0.075,
                    width: width * 0.85,
                    iconTopPadding: height * 0.01,
                    buttonColor: const Color(0xff3a6c83),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen_Second(
                                    ReferralUserID: "",
                                  )));
                    },
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomSignInButton(
                    text: 'Sign In With Gmail',
                    height: height * 0.075,
                    iconSize: height * width * 0.00015,
                    width: width * 0.85,
                    iconLeftPadding: width * 0.04,
                    customIcon: Icons.g_mobiledata_outlined,
                    buttonColor: const Color(0xfff14336),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomSignInButton(
                    text: 'Sign In With Facebook',
                    customIcon: Icons.facebook_outlined,
                    height: height * 0.075,
                    width: width * 0.85,
                    iconLeftPadding: width * 0.055,
                    iconTopPadding: 5,
                    iconSize: height * width * 0.0001,
                    buttonColor: const Color(0xff2275e9),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Platform.isIOS
                      ? CustomSignInButton(
                          text: 'Sign In With Apple',
                          customIcon: Icons.apple,
                          height: height * 0.075,
                          width: width * 0.85,
                          iconLeftPadding: width * 0.055,
                          iconSize: height * width * 0.0001,
                          iconTopPadding: 5,
                          buttonColor: const Color(0xff1e1e1e),
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          mini: false,
                        )
                      : Container(),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      Languages.of(context)!.alreadyhaveAccountSignIn,
                      style: const TextStyle(
                          color: Color(0xff002333),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
