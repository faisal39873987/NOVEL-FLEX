import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/localization/Language/languages.dart';
import '../../Models/GiftAmountModel.dart';
import '../../Models/UserPaymentModel.dart';
import '../../Models/UserWithDrawPaymentModel.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  UserPaymentModel? _userPaymentModel;
  UserWithDrawPaymentModel? _userWithDrawPaymentModel;
  GiftAmountModel? _giftAmountModel;
  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(Languages.of(context)!.myWallet,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
      ),
      body: _isInternetConnected
          ? _isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: CustomCard(
                    gif: MoreLoadingGif(
                      type: MoreLoadingGifType.eclipse,
                      size: height * width * 0.0002,
                    ),
                    text: 'Loading',
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: height * 0.5,
                      width: width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                        color: Color(0xffebf5f9),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.3,
                            width: width * 0.8,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                  "assets/quotes_data/wallet_animation_png.gif"),
                            )),
                          ),
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Text(
                            Languages.of(context)!.bank1,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(Languages.of(context)!.bank2,
                              style: const TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(),
                          Container(
                            height: height * 0.08,
                            width: width,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black12,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(),
                                    Text(Languages.of(context)!.giftAmount,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.left),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Text(
                                      "\$ ${_giftAmountModel!.totalAmount.toString()}",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.08,
                            margin: const EdgeInsets.all(8.0),
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black12,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(),
                                    Text(Languages.of(context)!.withdrawAmount,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.left),
                                    const SizedBox(),
                                    Text(
                                      "\$ ${_userWithDrawPaymentModel!.totalAmount.toString()}",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.08,
                            width: width,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black12,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(height * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(),
                                    Text(Languages.of(context)!.totalAmount,
                                        style: const TextStyle(
                                            color: Color(0xff1b4a6b),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0),
                                        textAlign: TextAlign.left),
                                    const SizedBox(),
                                    Text(
                                      "\$ ${_userPaymentModel!.totalAmount.toString()}",
                                      style: const TextStyle(
                                          color: Color(0xff1b4a6b),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                    )
                  ],
                )
          : Center(
              child: Constants.InternetNotConnected(height * 0.03),
            ),

      // floatingActionButton:  FloatingActionButton(
      // onPressed: () {
      //   ToastConstant.showToast(context, "You can collect Payment when Your subscribers reached 50");
      // },
      // child: const Icon(Icons.add),
      //   backgroundColor:Color(0xFF3fa7ca),
      // ),
      //
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.centerFloat,
    );
  }

  Future PaymentApiCall() async {
    ToastConstant.showToast(context, "Wallet is not available in this MVP.");
    setState(() {
      _isLoading = false;
    });
  }

  Future PaymentWithDrawApiCall() async {
    setState(() {
      _isLoading = false;
    });
  }

  Future GiftedAmount() async {
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
      PaymentApiCall();
    }
  }
}
