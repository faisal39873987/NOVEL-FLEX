import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:credit_card_scanner/credit_card_scanner.dart';
// import 'package:credit_card_scanner/models/card_details.dart';
// import 'package:credit_card_scanner/models/card_scan_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transitioner/transitioner.dart';
import '../../Utils/Constants.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';
import '../BooksScreens/BookDetail.dart';

class StripePayment extends StatefulWidget {
  String bookId;
  StripePayment({Key? key, required this.bookId}) : super(key: key);

  @override
  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  // CardDetails? _cardDetails;
  // CardScanOptions scanOptions = const CardScanOptions(
  //   scanCardHolderName: true,
  //   enableLuhnCheck: false,
  //   enableDebugLogs: true,
  //   scanExpiryDate: true,
  //   validCardsToScanBeforeFinishingScan: 5,
  //   possibleCardHolderNamePositions: [
  //     CardHolderNameScanPosition.aboveCardNumber,
  //   ],
  // );
  //
  // Future<void> scanCard() async {
  //   final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
  //   if ( !mounted || cardDetails == null ) return;
  //   setState(() {
  //     _cardDetails = cardDetails;
  //   });
  // }
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
      // appBar: AppBar(
      //   backgroundColor: const Color(0xffebf5f9),
      //   elevation: 0.0,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(
      //         Icons.arrow_back_ios,
      //         color: Colors.black54,
      //       )),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF19547b),
              Color(0xFF43cea2),
              Color(0xFF19547b),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            IconButton(
                onPressed: () => safeBack(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xffffffff),
                )),
            SizedBox(
              height: height * 0.01,
            ),
            Center(
              child: SizedBox(
                height: height * 0.2,
                width: width * 0.4,
                child: Image.asset(
                  'assets/quotes_data/NoPath_3x-removebg-preview.png',
                ),
              ),
            ),
            Center(
              child: Text(Languages.of(context)!.amountAndroid,
                  style: const TextStyle(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w300,
                      fontFamily: "Alexandria",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Payments are temporarily unavailable while NovelFlex migrates digital content purchases to Apple In-App Purchase.',
                style: TextStyle(
                  color: Colors.white,
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
                      color: Color(0xffebf5f9)),
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
                      color: Color(0xffebf5f9)),
                  child: SizedBox(
                      height: height * 0.03,
                      width: width * 0.05,
                      child: Image.asset("assets/quotes_data/bank_imag.png")),
                ),
                GestureDetector(
                  // onTap: (){
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) => UsePaypal(
                  //             sandboxMode: false,
                  //             clientId:
                  //             "AeNe9f_qZbK-PxOKuAmzhUunMQMGDMBsmm02IuRoC0z79h5wkmj2uvBQF5wWgjbsDljVIyaKLcRw358W",
                  //             secretKey:
                  //             "AeNe9f_qZbK-PxOKuAmzhUunMQMGDMBsmm02IuRoC0z79h5wkmj2uvBQF5wWgjbsDljVIyaKLcRw358W",
                  //             returnURL: "nativexo://paypalpay",
                  //             cancelURL: "https://samplesite.com/cancel",
                  //             transactions: const [
                  //               {
                  //                 "amount": {
                  //                   "total": '3.00',
                  //                   "currency": "USD",
                  //                   "details": {
                  //                     "subtotal": '3.00',
                  //                     "shipping": '0',
                  //                     "shipping_discount": 0
                  //                   }
                  //                 },
                  //                 "description":
                  //                 "The payment transaction description.",
                  //                 // "payment_options": {
                  //                 //   "allowed_payment_method":
                  //                 //       "INSTANT_FUNDING_SOURCE"
                  //                 // },
                  //                 "item_list": {
                  //                   "items": [
                  //                     {
                  //                       "name": "subscription",
                  //                       "quantity": 1,
                  //                       "price": '3.00',
                  //                       "currency": "USD"
                  //                     }
                  //                   ],
                  //
                  //                   // shipping address is not required though
                  //                   "shipping_address": {
                  //                     "recipient_name": "Mouza Altuniji",
                  //                     "line1": "Al mourjan Tower Murror road",
                  //                     "line2": "Office no 7 M floor",
                  //                     "city": "Abu Dhabi",
                  //                     "country_code": "AE",
                  //                     "postal_code": "00000",
                  //                     "phone": "+971505796166",
                  //                     "state": "United Arab Emirates"
                  //                   },
                  //                 }
                  //               }
                  //             ],
                  //             note: "Contact us for any questions on your order.",
                  //             onSuccess: (Map params) async {
                  //               print("onSuccess: $params");
                  //               Subscribe();
                  //             },
                  //             onError: (error) {
                  //               print("onError: $error");
                  //             },
                  //             onCancel: (params) {
                  //               print('cancelled: $params');
                  //             }),
                  //       ),
                  //     );
                  //
                  // },
                  onTap: () {
                    Constants.showToastBlack(
                      context,
                      'PayPal is disabled for digital content purchases on iOS.',
                    );
                  },
                  child: Container(
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
                        color: Color(0xffebf5f9)),
                    child: SizedBox(
                        height: height * 0.03,
                        width: width * 0.05,
                        child:
                            Image.asset("assets/quotes_data/paypal_img.png")),
                  ),
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
                    'Use Apple In-App Purchase for subscriptions in production.',
                  );
                },
                buttonname: Languages.of(context)!.subscribeTxt,
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
            // Container(
            //   margin: EdgeInsets.only(top: _height * 0.03),
            //   child: ResuableMaterialButtonSmall(
            //     onpress: () {
            //       scanCard();
            //     },
            //     buttonname: Languages.of(context)!.scan,
            //   ),
            // ),
            const SizedBox(),
          ],
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

  Future Subscribe() async {
    ToastConstant.showToast(
        context, "Subscriptions are not available in this MVP.");
    Transitioner(
      context: context,
      child: BookDetail(
        bookID: widget.bookId,
      ),
      animation: AnimationType.slideLeft,
      duration: const Duration(milliseconds: 1000),
      replacement: true,
      curveType: CurveType.decelerate,
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
