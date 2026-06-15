import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:novelflex/MixScreens/WalletDirectory/withdrawPaymentScreen.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../../Provider/UserProvider.dart';
import '../../localization/Language/languages.dart';

class UnlockWalletScreenOne extends StatefulWidget {
  const UnlockWalletScreenOne({Key? key}) : super(key: key);

  @override
  State<UnlockWalletScreenOne> createState() => _UnlockWalletScreenOneState();
}

class _UnlockWalletScreenOneState extends State<UnlockWalletScreenOne> {
  static const Color kDarkBlueColor = Color(0xff3a6c83);
  String? cardNumber;
  String? cardHolderName;
  String? expMonth;
  String? expYear;
  String? cvV;
  String? amount = "3";

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return OnBoardingSlider(
      finishButtonText: Languages.of(context)!.confirmTxt,
      // finishButtonColor: kDarkBlueColor,
      onFinish: () {
        Transitioner(
          context: context,
          child: const WithDrawPaymentScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: const Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      },
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: const Color(0xffebf5f9),
      pageBackgroundColor: const Color(0xffebf5f9),
      background: [
        Container(
          margin: EdgeInsets.only(left: width * 0.06),
          padding: EdgeInsets.only(
            left: context.read<UserProvider>().SelectedLanguage == 'English'
                ? width * 0.02
                : 0.0,
            right: context.read<UserProvider>().SelectedLanguage == 'Arabic'
                ? width * 0.02
                : 0.0,
          ),
          alignment: Alignment.center,
          width: width * 0.85,
          height: height * 0.79,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 5),
                    blurRadius: 14,
                    spreadRadius: 0)
              ],
              color: Color(0xffffffff)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  height: height * 0.15,
                  child: Image.asset(
                      "assets/quotes_data/extra_pngs/unlock_wallet.gif")),
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Text(Languages.of(context)!.wallet1,
                    style: const TextStyle(
                        color: Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Neckar",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                    width: 368,
                    height: 1,
                    decoration: const BoxDecoration(color: Color(0xffbcbcbc))),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff676767))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Text(
                      Languages.of(context)!.wallet1,
                      style: const TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle: FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff676767))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Text(
                      Languages.of(context)!.wallet3,
                      style: const TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle: FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff676767))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Text(
                      Languages.of(context)!.wallet4,
                      style: const TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle: FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff676767))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Text(
                      Languages.of(context)!.wallet5,
                      style: const TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle: FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff676767))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Text(
                      Languages.of(context)!.wallet6,
                      style: const TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle: FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.06),
          padding: EdgeInsets.only(left: width * 0.02),
          alignment: Alignment.center,
          width: width * 0.85,
          height: height * 0.79,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 5),
                    blurRadius: 14,
                    spreadRadius: 0)
              ],
              color: Color(0xffffffff)),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                  height: height * 0.15,
                  child: Image.asset("assets/quotes_data/dollar_icon.png")),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Text(Languages.of(context)!.EAccount1,
                    style: const TextStyle(
                        color: Color(0xff2a2a2a),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Neckar",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                    width: 368,
                    height: 1,
                    decoration: const BoxDecoration(color: Color(0xffbcbcbc))),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Expanded(
                child: Text(Languages.of(context)!.EAccount2,
                    style: const TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.06),
          padding: EdgeInsets.only(left: width * 0.02),
          alignment: Alignment.center,
          width: width * 0.85,
          height: height * 0.79,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 5),
                    blurRadius: 14,
                    spreadRadius: 0)
              ],
              color: Color(0xffffffff)),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                  height: height * 0.15,
                  child: Image.asset("assets/quotes_data/dollar_icon.png")),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Text(Languages.of(context)!.FinsihAllsteps,
                    style: const TextStyle(
                        color: Color(0xff2a2a2a),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Neckar",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                    width: 368,
                    height: 1,
                    decoration: const BoxDecoration(color: Color(0xffbcbcbc))),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                  height: height * 0.15,
                  child: Image.asset("assets/quotes_data/done_calping.jpeg")),
            ],
          ),
        ),
      ],
      speed: 2.8,
      pageBodies: [
        Container(),
        Container(),
        Container(),
      ],
    );
  }
}
