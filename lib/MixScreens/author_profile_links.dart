import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import '../Models/GetSocailLinksModel.dart';
import '../Models/SocailLinksModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import '../localization/Language/languages.dart';

class AddAuthorProfileLinks extends StatefulWidget {
  const AddAuthorProfileLinks({Key? key}) : super(key: key);

  @override
  State<AddAuthorProfileLinks> createState() => _AddAuthorProfileLinksState();
}

class _AddAuthorProfileLinksState extends State<AddAuthorProfileLinks> {
  SocailLinksModel? _socailLinksModel;
  GetSocailLinksModel? _getSocailLinksModel;
  bool _isLoading = false;
  bool _isLoader = false;
  bool _isInternetConnected = true;

  final _fbFocusNode = FocusNode();
  final _ybFocusNode = FocusNode();
  final _IsFocusNode = FocusNode();
  final _twFocusNode = FocusNode();
  final _tkFocusNode = FocusNode();

  final _fbKey = GlobalKey<FormFieldState>();
  final _ybKey = GlobalKey<FormFieldState>();
  final _IsKey = GlobalKey<FormFieldState>();
  final _twKey = GlobalKey<FormFieldState>();
  final _tkKey = GlobalKey<FormFieldState>();

  final TextEditingController _fbController = TextEditingController();
  final TextEditingController _ybController = TextEditingController();
  final TextEditingController _IsController = TextEditingController();
  final TextEditingController _twController = TextEditingController();
  final TextEditingController _tkController = TextEditingController();

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
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          backgroundColor: const Color(0xffebf5f9),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              )),
          title: Text(Languages.of(context)!.linksText,
              style: const TextStyle(
                  color: Color(0xff2a2a2a),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Alexandria",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
        ),
        body: _isLoader
            ? Align(
                alignment: Alignment.center,
                child: CustomCard(
                  gif: MoreLoadingGif(
                    type: MoreLoadingGifType.ripple,
                    size: height * width * 0.0002,
                  ),
                  text: 'Loading',
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          height: height * 0.12,
                          width: width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/quotes_data/fb_icon.png"))),
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            key: _fbKey,
                            controller: _fbController,
                            focusNode: _fbFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            // onFieldSubmitted: (_) {
                            //   FocusScope.of(context)
                            //       .requestFocus(_ybFocusNode);
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
                                hintText: Languages.of(context)!.fbLink,
                                // labelText: Languages.of(context)!.email,
                                hintStyle: const TextStyle(
                                  fontFamily: Constants.fontfamily,
                                )),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          height: height * 0.12,
                          width: width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/quotes_data/yb_icon.png"))),
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            key: _ybKey,
                            controller: _ybController,
                            focusNode: _ybFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_ybFocusNode);
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
                                hintText: Languages.of(context)!.ybLink,
                                // labelText: Languages.of(context)!.email,
                                hintStyle: const TextStyle(
                                  fontFamily: Constants.fontfamily,
                                )),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          height: height * 0.12,
                          width: width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/quotes_data/insta_icon.png"))),
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            key: _IsKey,
                            controller: _IsController,
                            focusNode: _IsFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_IsFocusNode);
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
                                hintText: Languages.of(context)!.insLink,
                                // labelText: Languages.of(context)!.email,
                                hintStyle: const TextStyle(
                                  fontFamily: Constants.fontfamily,
                                )),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          height: height * 0.12,
                          width: width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/quotes_data/tw_icon.png"))),
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            key: _twKey,
                            controller: _twController,
                            focusNode: _twFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_tkFocusNode);
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
                                hintText: Languages.of(context)!.twLink,
                                // labelText: Languages.of(context)!.email,
                                hintStyle: const TextStyle(
                                  fontFamily: Constants.fontfamily,
                                )),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          height: height * 0.12,
                          width: width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/quotes_data/tk_icon.png"))),
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: TextFormField(
                            key: _tkKey,
                            controller: _tkController,
                            focusNode: _tkFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
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
                                hintText: Languages.of(context)!.tkLink,
                                // labelText: Languages.of(context)!.email,
                                hintStyle: const TextStyle(
                                  fontFamily: Constants.fontfamily,
                                )),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        _checkInternetConnection2();
                      },
                      child: Container(
                        width: width * 0.9,
                        height: height * 0.065,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x24000000),
                                  offset: Offset(0, 7),
                                  blurRadius: 14,
                                  spreadRadius: 0)
                            ],
                            color: Color(0xff3a6c83)),
                        child: Center(
                          child: Text(
                            Languages.of(context)!.saved,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Lato",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),
                    Visibility(
                      visible: _isLoading,
                      child: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ],
                ),
              ));
  }

  Future UpdateLinks() async {
    var map = <String, dynamic>{};
    map['facebook_link'] = _fbController.text.toString().trim();
    map['youtube_link'] = _ybController.text.toString().trim();
    map['instagram_link'] = _IsController.text.toString().trim();
    map['twitter_link'] = _twController.text.toString().trim();
    map['ticktok_link'] = _tkController.text.toString().trim();

    final response = await http.post(Uri.parse(ApiUtils.UPDATE_LINKS),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('update_link_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _socailLinksModel = socailLinksModelFromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
    if (mounted) {
      setState(() {
        _isLoader = true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (mounted) {
        setState(() {
          _isLoader = false;
          _isInternetConnected = false;
        });
      }
    } else {
      GetLinks();
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
      Constants.showToastBlack(context, "Internet not connected");
      if (mounted) {
        setState(() {
          _isLoader = false;
          _isInternetConnected = false;
        });
      }
    } else {
      UpdateLinks();
    }
  }

  Future GetLinks() async {
    final response = await http.get(Uri.parse(ApiUtils.GET_LINKS), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('get_link_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        if (jsonData1['data'] == null) {
          setState(() {
            _fbController.text = "";
            _ybController.text = "";
            _IsController.text = "";
            _twController.text = "";
            _tkController.text = "";
            _isLoader = false;
          });
        } else {
          _getSocailLinksModel = getSocailLinksModelFromJson(jsonData);
          setState(() {
            _fbController.text = _getSocailLinksModel!.data.facebookLink == null
                ? ""
                : _getSocailLinksModel!.data.facebookLink.toString();
            _ybController.text = _getSocailLinksModel!.data.youtubeLink == null
                ? ""
                : _getSocailLinksModel!.data.youtubeLink.toString();
            _IsController.text =
                _getSocailLinksModel!.data.instagramLink == null
                    ? ""
                    : _getSocailLinksModel!.data.instagramLink.toString();
            _twController.text = _getSocailLinksModel!.data.twitterLink == null
                ? ""
                : _getSocailLinksModel!.data.twitterLink.toString();
            _tkController.text = _getSocailLinksModel!.data.ticktokLink == null
                ? ""
                : _getSocailLinksModel!.data.ticktokLink.toString();
            _isLoader = false;
          });
        }
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoader = false;
        });
      }
    }
  }
}
