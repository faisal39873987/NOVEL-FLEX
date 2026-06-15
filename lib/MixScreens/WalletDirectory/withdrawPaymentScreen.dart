import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';

class WithDrawPaymentScreen extends StatefulWidget {
  const WithDrawPaymentScreen({Key? key}) : super(key: key);

  @override
  State<WithDrawPaymentScreen> createState() => _WithDrawPaymentScreenState();
}

class _WithDrawPaymentScreenState extends State<WithDrawPaymentScreen> {
  final _ibanFN = FocusNode();
  final _nameFN = FocusNode();
  final _fatherFN = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _ibanKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _fatherNameKey = GlobalKey<FormFieldState>();

  TextEditingController? _ibanController;
  TextEditingController? _nameController;
  TextEditingController? _fatherNameController;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  String? amount = "3";

  @override
  void initState() {
    super.initState();
    _ibanController = TextEditingController();
    _nameController = TextEditingController();
    _fatherNameController = TextEditingController();
  }

  @override
  void dispose() {
    _ibanController!.dispose();
    _nameController!.dispose();
    _fatherNameController!.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                height: height * 0.5,
                width: width,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * 0.04),
                        child: TextFormField(
                          key: _ibanKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _ibanController,
                          focusNode: _ibanFN,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          validator: validateIBAN,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_nameFN);
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
                              hintText: Languages.of(context)!.iban,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * 0.04),
                        child: TextFormField(
                          key: _nameKey,
                          controller: _nameController,
                          focusNode: _nameFN,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          validator: validateName,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_fatherFN);
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
                              hintText: Languages.of(context)!.cardHolderName,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * 0.04),
                        child: TextFormField(
                          key: _fatherNameKey,
                          controller: _fatherNameController,
                          focusNode: _fatherFN,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          validator: validateFatherName,
                          // onFieldSubmitted: (_) {
                          //   FocusScope.of(context)
                          //       .requestFocus(_passwordFocusNode);
                          // },
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
                              hintText: Languages.of(context)!.fatherName,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                    ],
                  ),
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
              Visibility(
                  visible: _isLoading,
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.1),
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.03),
                child: ResuableMaterialButtonSmall(
                  onpress: () {
                    if (_formKey.currentState!.validate()) {
                      _checkInternetConnection();
                    } else {
                      ToastConstant.showToast(context,
                          "Please fill all the Fields with Correct information");
                    }
                  },
                  buttonname: Languages.of(context)!.apply,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Text(Languages.of(context)!.carefulText,
                      style: const TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Alexandria",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future WithDrawPAymentApiCall() async {
    setState(() {
      _isLoading = false;
    });
    ToastConstant.showToast(
        context, "Withdrawals are not available in this MVP.");
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
      WithDrawPAymentApiCall();
    }
  }

  String? validateIBAN(String? value) {
    if (value!.isEmpty) {
      return 'Please Inter International Bank Account Number';
    } else {
      return null;
    }
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Account Holder Name';
    } else {
      return null;
    }
  }

  String? validateFatherName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Account Holder Father Name';
    } else {
      return null;
    }
  }
}
