import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transitioner/transitioner.dart';
import '../Models/SeeAllModel.dar.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../data/services/supabase_legacy_api_adapter.dart';
import '../localization/Language/languages.dart';
import 'BooksScreens/BookDetail.dart';

class SeeAllBookScreen extends StatefulWidget {
  String? categoriesId;
  SeeAllBookScreen({super.key, required this.categoriesId});

  @override
  State<SeeAllBookScreen> createState() => _SeeAllBookScreenState();
}

class _SeeAllBookScreenState extends State<SeeAllBookScreen> {
  SeeAllBooksModelClass? _seeAllBooksModelClass;
  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    super.initState();
    print("seeAllCategories_id= ${widget.categoriesId}");
    _checkInternetConnection();
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
      ALLBOOKSApiCall();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
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
        toolbarHeight: height * 0.05,
      ),
      body: _isInternetConnected == false
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "INTERNET NOT CONNECTED",
                      style: TextStyle(
                        fontFamily: Constants.fontfamily,
                        color: Color(0xFF256D85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.019,
                    ),
                    InkWell(
                      child: Container(
                        width: width * 0.40,
                        height: height * 0.058,
                        decoration: BoxDecoration(
                          color: const Color(0xFF256D85),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              40.0,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "No Internet Connected",
                            style: TextStyle(
                              fontFamily: Constants.fontfamily,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        _checkInternetConnection();
                      },
                    ),
                  ],
                ),
              ),
            )
          : _isLoading
              ? const Align(
                  alignment: Alignment.center,
                  child: Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(),
                  ))
              : _seeAllBooksModelClass!.data.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: height * 0.4),
                      child: Center(
                        child: Text(
                          Languages.of(context)!.nodata,
                          style: const TextStyle(
                              color: Color(0xff3a6c83),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                        ),
                      ))
                  : Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.03,
                                  right: width * 0.01),
                              child: GridView.count(
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 3,
                                childAspectRatio: 0.78,
                                mainAxisSpacing: height * 0.01,
                                children: List.generate(
                                    _seeAllBooksModelClass!.data.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Transitioner(
                                        context: context,
                                        child: BookDetail(
                                          bookID: _seeAllBooksModelClass!
                                              .data[index].id
                                              .toString(),
                                        ),
                                        animation: AnimationType
                                            .slideTop, // Optional value
                                        duration: const Duration(
                                            milliseconds:
                                                1000), // Optional value
                                        replacement: false, // Optional value
                                        curveType: CurveType
                                            .decelerate, // Optional value
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: width * 0.25,
                                            height: height * 0.13,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        _seeAllBooksModelClass!
                                                            .data[index]
                                                            .imagePath
                                                            .toString()),
                                                    fit: BoxFit.cover),
                                                color: Colors.green)),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Expanded(
                                          child: Text(
                                              _seeAllBooksModelClass!
                                                  .data[index].title
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Color(0xff2a2a2a),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Alexandria",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                              textAlign: TextAlign.left),
                                        ),
                                        Expanded(
                                            child: Text(
                                                _seeAllBooksModelClass!
                                                    .data[index]
                                                    .user[0]
                                                    .username
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Color(0xff676767),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Lato",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.left)),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        ],
                      )),
    );
  }

  Future ALLBOOKSApiCall() async {
    try {
      final categoryId = int.tryParse(widget.categoriesId.toString());
      final response = categoryId == null
          ? <String, dynamic>{'status': 200, 'data': <Map<String, dynamic>>[]}
          : await SupabaseLegacyApiAdapter().categoryBooks(categoryId);
      _seeAllBooksModelClass = SeeAllBooksModelClass.fromJson(response);
    } catch (_) {
      _seeAllBooksModelClass = SeeAllBooksModelClass.fromJson(
        <String, dynamic>{'status': 200, 'data': <Map<String, dynamic>>[]},
      );
      if (mounted) {
        ToastConstant.showToast(context, "Unable to load books");
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }
}
