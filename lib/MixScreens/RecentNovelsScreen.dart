import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:transitioner/transitioner.dart';
import '../Models/AllRecentModel.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import '../data/services/supabase_legacy_api_adapter.dart';
import 'BooksScreens/BookDetail.dart';
import '../localization/Language/languages.dart' as lang;

class RecentNovelsScreen extends StatefulWidget {
  const RecentNovelsScreen({Key? key}) : super(key: key);

  @override
  State<RecentNovelsScreen> createState() => _RecentNovelsScreenState();
}

class _RecentNovelsScreenState extends State<RecentNovelsScreen> {
  AllRecentModel? _allrecentModel;
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
          title: Text(
            lang.Languages.of(context)!.recentlyPublish,
            style: const TextStyle(
                color: Color(0xff2a2a2a),
                fontWeight: FontWeight.w700,
                fontFamily: "Alexandria",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
        ),
        body: SafeArea(
          child: _isInternetConnected
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
                        Expanded(
                          flex: 8,
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
                                  _allrecentModel!.data.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Transitioner(
                                      context: context,
                                      child: BookDetail(
                                        bookID: _allrecentModel!.data[index].id
                                            .toString(),
                                      ),
                                      animation: AnimationType
                                          .slideTop, // Optional value
                                      duration: const Duration(
                                          milliseconds: 1000), // Optional value
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
                                                      _allrecentModel!
                                                          .data[index].imagePath
                                                          .toString()),
                                                  fit: BoxFit.cover),
                                              color: Colors.green)),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Expanded(
                                        child: Text(
                                            _allrecentModel!.data[index].title
                                                .toString(),
                                            style: const TextStyle(
                                                color: Color(0xff2a2a2a),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Alexandria",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left),
                                      ),
                                      // Expanded(
                                      //     child: Text(_allrecentModel!.data[index].user[1].username.toString(),
                                      //         style: const TextStyle(
                                      //             color: const Color(0xff676767),
                                      //             fontWeight: FontWeight.w400,
                                      //             fontFamily: "Lato",
                                      //             fontStyle: FontStyle.normal,
                                      //             fontSize: 12.0),
                                      //         textAlign: TextAlign.left)),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      ],
                    )
              : const Center(
                  child: Text("No Internet Connection!"),
                ),
        ));
  }

  Future RecentApiCall() async {
    try {
      final response = await SupabaseLegacyApiAdapter().homeDetails();
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final books = data['recentlyPublishBooks'] as List<dynamic>? ?? [];
      _allrecentModel = AllRecentModel.fromJson(<String, dynamic>{
        'status': 200,
        'data': books,
      });
    } catch (_) {
      _allrecentModel = AllRecentModel.fromJson(<String, dynamic>{
        'status': 200,
        'data': <Map<String, dynamic>>[],
      });
      if (mounted) {
        ToastConstant.showToast(context, "Unable to load recent novels");
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
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
      RecentApiCall();
    }
  }
}
