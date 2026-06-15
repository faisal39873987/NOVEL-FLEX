import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';
import '../Models/AuthorProfileModelEdit.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../data/services/supabase_auth_flow_service.dart';
import '../localization/Language/languages.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AuthorProfileEditModel? _authorProfileEditModel;
  bool _isLoading = false;
  bool _UploadLoading = false;
  bool _isInternetConnected = true;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  File? imageFile;
  bool _isImageLoading = false;

  @override
  void initState() {
    _checkInternetConnection();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
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
      body: SafeArea(
        child: _isInternetConnected
            ? _isLoading
                ? const Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(
                      color: Color(0xff1b4a6b),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _getFromGallery();
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: height * 0.2,
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              child: CircleAvatar(
                                                radius: width * height * 0.0002,
                                                backgroundColor: Colors.black12,
                                                backgroundImage: NetworkImage(
                                                  _authorProfileEditModel!
                                                      .data.profilePath
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                top: height * 0.07,
                                                width: width * 0.35,
                                                child: Visibility(
                                                    visible: _isImageLoading,
                                                    child: const Center(
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    )))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: width * 0.55,
                                      top: height * 0.12,
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                color: const Color(0xffebf5f9),
                                child: Column(
                                  children: [
                                    Text(
                                      (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .UserName!),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .UserEmail!,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xff676767),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Alexandria",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                              width: 427.5,
                              height: 1,
                              decoration: const BoxDecoration(
                                  color: Color(0xffbcbcbc))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.02, right: width * 0.02),
                          height: height * 0.07,
                          width: width * 0.95,
                          child: TextFormField(
                            // key: _bookTitleKey,
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // labelText: widget.labelText,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.02, right: width * 0.02),
                          height: height * 0.07,
                          width: width * 0.95,
                          child: TextFormField(
                            // key: _bookTitleKey,
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // labelText: widget.labelText,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.02, right: width * 0.02),
                          height: height * 0.07,
                          width: width * 0.95,
                          child: TextFormField(
                            // key: _bookTitleKey,
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // labelText: widget.labelText,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            EDIT_PROFILE_Api();
                          },
                          child: Container(
                            width: width * 0.9,
                            height: height * 0.065,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xff3a6c83),
                                  width: 2,
                                )),
                            child: Center(
                              child: Text(
                                Languages.of(context)!.update,
                                style: const TextStyle(
                                    color: Color(0xff3a6c83),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDeleteDialog();
                          },
                          child: Container(
                            width: width * 0.9,
                            height: height * 0.065,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xff3a6c83),
                                  width: 2,
                                )),
                            child: Center(
                              child: Text(
                                Languages.of(context)!.DeleteAccount,
                                style: const TextStyle(
                                    color: Color(0xff3a6c83),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Visibility(
                          visible: _UploadLoading == true,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      ],
                    ),
                  )
            : const Center(
                child: Text("No Internet Connection!"),
              ),
      ),
    );
  }

  void showDeleteDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.DeleteAccount,
            style: const TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
            Languages.of(context)!.deleteAccountText,
            style: const TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  Languages.of(context)!.yes,
                  style: const TextStyle(fontFamily: Constants.fontfamily),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await DELETE_PROFILE_Api();
                }),
            CupertinoDialogAction(
              child: Text(
                Languages.of(context)!.no,
                style: const TextStyle(fontFamily: Constants.fontfamily),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future ProfileApiCall() async {
    final response =
        await http.get(Uri.parse(ApiUtils.PROFILE_AUTHOR_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('edit_profile_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _authorProfileEditModel = authorProfileEditModelFromJson(jsonData);
        setState(() {
          _isLoading = false;
        });

        _nameController!.text =
            _authorProfileEditModel!.data.username.toString();
        _emailController!.text = _authorProfileEditModel!.data.email.toString();
        _phoneNumberController!.text =
            _authorProfileEditModel!.data.phone.toString();
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
      ProfileApiCall();
    }
  }

  Future<void> EDIT_PROFILE_Api() async {
    setState(() {
      _UploadLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };

    var map = <String, dynamic>{};
    map['username'] = _nameController!.text.trim();
    map['email'] = _emailController!.text.trim();
    map['phone'] = _phoneNumberController!.text.trim();

    final response = await http.post(Uri.parse(ApiUtils.EDIT_PROFILE_),
        body: map, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        setState(() {
          _UploadLoading = false;
        });
        ToastConstant.showToast(context, jsonData['data']);
        Transitioner(
          context: context,
          child: const TabScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: const Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      } else {
        ToastConstant.showToast(context, jsonData['data']);
        setState(() {
          _UploadLoading = false;
        });
      }
    }
  }

  Future<void> DELETE_PROFILE_Api() async {
    setState(() {
      _UploadLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await SupabaseAuthFlowService().deleteAccount(userProvider);
      if (!mounted) return;
      ToastConstant.showToast(context, "Account deleted successfully.");
      Phoenix.rebirth(context);
    } catch (error) {
      if (!mounted) return;
      ToastConstant.showToast(context, error.toString());
      setState(() {
        _UploadLoading = false;
      });
    }
  }

  _getFromGallery() async {
    final PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
      UploadCoverImageApi();
    }
  }

  Future<void> UploadCoverImageApi() async {
    setState(() {
      _isImageLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUtils.PROFILE_IMAGE_UPDATE_API));

    request.files.add(http.MultipartFile.fromBytes(
      "profile_photo",
      File(imageFile!.path).readAsBytesSync(),
      filename: "Image.jpg",
      contentType: MediaType('image', 'jpg'),
    ));
    request.headers.addAll(headers);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("profile Image Update Successfully! ");
          print('book_cover_image_upload ${response.body}');
          Constants.showToastBlack(
              context, "Profile Image Update Successfully!");
          setState(() {
            _isImageLoading = false;
          });
          _checkInternetConnection();
        } else {
          setState(() {
            _isImageLoading = false;
          });
          Constants.showToastBlack(context, "sorry try again!");
        }
      });
    });
  }
}
