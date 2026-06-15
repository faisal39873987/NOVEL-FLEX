import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/Constants.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';

class GiftScreen extends StatefulWidget {
  String author_id;
  String amount;
  GiftScreen({Key? key, required this.author_id, required this.amount})
      : super(key: key);

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  bool _isLoading = false;
  bool _isInternetConnected = true;
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
    return Scaffold(
      backgroundColor: const Color(0xffebf6f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Gifts are temporarily unavailable while NovelFlex migrates digital creator support to Apple In-App Purchase.',
                  style: TextStyle(
                    color: Color(0xff3a6c83),
                    fontFamily: Constants.fontfamily,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 110,
                    height: 100,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x17000000),
                              offset: Offset(0, 5),
                              blurRadius: 16,
                              spreadRadius: 0)
                        ],
                        color: Color(0xffffffff)),
                    child: SizedBox(
                        height: height * 0.03,
                        width: width * 0.05,
                        child: Image.asset(
                            "assets/quotes_data/matercard_withDraw.png")),
                  ),
                  Container(
                    width: 110,
                    height: 100,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x17000000),
                              offset: Offset(0, 5),
                              blurRadius: 16,
                              spreadRadius: 0)
                        ],
                        color: Color(0xffffffff)),
                    child: SizedBox(
                        height: height * 0.03,
                        width: width * 0.05,
                        child: Image.asset("assets/quotes_data/bank_imag.png")),
                  ),
                  Container(
                    width: 110,
                    height: 100,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x17000000),
                              offset: Offset(0, 5),
                              blurRadius: 16,
                              spreadRadius: 0)
                        ],
                        color: Color(0xffffffff)),
                    child: SizedBox(
                        height: height * 0.03,
                        width: width * 0.05,
                        child:
                            Image.asset("assets/quotes_data/paypal_img.png")),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.03),
                child: ResuableMaterialButtonSmall(
                  onpress: () {
                    Constants.showToastBlack(
                      context,
                      'Use Apple In-App Purchase for digital gifts in production.',
                    );
                  },
                  buttonname: Languages.of(context)!.gift,
                ),
              ),
              Visibility(
                  visible: _isLoading,
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.1),
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future StripeApiCall() async {
    Constants.showToastBlack(
      context,
      'External card payments are disabled for App Store compliance.',
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future GiftApi() async {
    Constants.showToastBlack(
      context,
      'Digital gifts require an App Store compliant purchase flow.',
    );
    setState(() {
      _isLoading = false;
    });
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
      Constants.showToastBlack(context, "Internet not connected");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInternetConnected = false;
        });
      }
    } else {
      StripeApiCall();
    }
  }
}
