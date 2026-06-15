import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../Models/UserModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../core/session/auth_navigation.dart';
import '../../data/services/supabase_auth_flow_service.dart';
import '../../localization/Language/languages.dart';
import 'package:http/http.dart' as http;

class SignUpAuthorScreen extends StatefulWidget {
  String name;
  String email;
  String password;
  String status;
  String phone;
  String photoUrl;
  String lstatus;
  SignUpAuthorScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.status,
      required this.phone,
      required this.photoUrl,
      required this.lstatus});

  @override
  State<SignUpAuthorScreen> createState() => _SignUpAuthorScreenState();
}

class _SignUpAuthorScreenState extends State<SignUpAuthorScreen> {
  final _descriptionKey = GlobalKey<FormFieldState>();
  TextEditingController? _descriptionController;
  File? imageFile;
  bool isLoading = false;
  UserModel? _userModel;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            mainText(width),
            SizedBox(
              height: height * 0.03,
            ),
            GestureDetector(
              onTap: () {
                _getFromGallery();
              },
              child: Container(
                  width: width * 0.385,
                  height: height * 0.18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffd9e7ed),
                  ),
                  child: widget.lstatus == ""
                      ? imageFile == null
                          ? Center(
                              child: Text(
                                Languages.of(context)!.selectPicture,
                                style: const TextStyle(
                                    color: Color(0xff3a6c83),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                            )
                          : ClipOval(
                              // clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(imageFile!.path),
                                fit: BoxFit.cover,
                              ),
                            )
                      : Image.network(widget.photoUrl)),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.015, left: width * 0.02, right: width * 0.02),
              height: height * 0.3,
              width: width * 0.9,
              child: TextFormField(
                key: _descriptionKey,
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.black,
                validator: validateDescription,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffd9e7ed),
                  hintText: Languages.of(context)!.bioHint,
                  hintStyle: const TextStyle(
                      color: Color(0xff16003b),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Arial",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Color(0xFF256D85)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Color(0xFF256D85)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading == true,
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
                  if (widget.lstatus == "") {
                    if (_descriptionController!.text != "" &&
                        imageFile != null) {
                      _checkInternetConnection();
                    } else {
                      ToastConstant.showToast(
                          context, "Please fill all Fields");
                    }
                  } else {
                    _checkInternetConnection2();
                  }
                },
                buttonname: Languages.of(context)!.register,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainText(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.letsReaderKnowYuBetter,
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

  String? validateDescription(String? value) {
    if (value!.isEmpty) {
      return 'Enter Description';
    } else {
      return null;
    }
  }

  _getFromGallery() async {
    final PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile = File(image.path);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final fileName = path.basename(imageFile!.path);
      final File localImage = await imageFile!.copy('$appDocPath/$fileName');

      // prefs!.setString("image", localImage.path);

      setState(() {
        imageFile = File(image.path);
        // UploadProfileImageApi();
      });
    }
  }

  Future<void> WRITER_REGISTER_API() async {
    setState(() {
      isLoading = true;
    });

    try {
      await SupabaseAuthFlowService().signUpAuthor(
        email: widget.email.trim(),
        password: widget.password.trim(),
        username: widget.name.trim(),
        phone: widget.phone.trim(),
        description: _descriptionController!.text.trim(),
        userProvider: context.read<UserProvider>(),
      );
      if (!mounted) return;
      ToastConstant.showToast(context, "Author registration successful");
      setState(() {
        isLoading = false;
      });
      _navigateAndRemove();
    } catch (_) {
      if (!mounted) return;
      ToastConstant.showToast(context, "Author registration failed");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future WRITER_SOCIAL_API() async {
    setState(() {
      isLoading = true;
    });

    print("google_id${widget.phone}");
    print("username${widget.name}");
    print("email${widget.email}");
    print("image${widget.phone}");

    var map = <String, dynamic>{};
    map['username'] = widget.name.trim().toString();
    map['email'] = widget.email.trim().toString();
    map['type'] = widget.status.trim().toString();
    map['google_id'] = widget.phone.trim().toString();
    map['image'] = widget.photoUrl.trim().toString();

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
          ToastConstant.showToast(context, jsonData['message'].toString());
          _navigateAndRemove();
          setState(() {
            isLoading = false;
          });
          print("Social Writer response${jsonData.toString()}");
        } else {
          ToastConstant.showToast(context, jsonData['message'].toString());
          setState(() {
            isLoading = false;
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
        isLoading = false;
      });
    }
  }

  Future _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Fluttertoast.showToast(
        msg: "Internet Not Connected",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 14,
      );
    } else {
      WRITER_REGISTER_API();
    }
  }

  Future _checkInternetConnection2() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Fluttertoast.showToast(
        msg: "Internet Not Connected",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 14,
      );
    } else {
      WRITER_SOCIAL_API();
    }
  }

  _navigateAndRemove() {
    navigateAfterAuthMutation(context);
  }
}
