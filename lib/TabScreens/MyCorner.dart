import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:transitioner/transitioner.dart';
import '../MixScreens/BooksScreens/BookDetail.dart';
import '../Models/LikesBooksModel.dart' as likes_model;
import '../Models/SavedBooksModel.dart' as saved_model;
import '../Utils/Constants.dart';
import '../Widgets/loading_widgets.dart';
import '../data/repositories/favorite_repository.dart';
import '../data/services/supabase_legacy_api_adapter.dart';

class MyCorner extends StatefulWidget {
  const MyCorner({Key? key}) : super(key: key);

  @override
  State<MyCorner> createState() => _MyCornerState();
}

class _MyCornerState extends State<MyCorner> {
  saved_model.SavedBooksModel? _savedBooksModel;
  likes_model.LikesBooksModel? _likesBooksModel;

  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  bool saved = true;
  bool liked = false;
  bool history = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        // leading: Container(
        //   width: 0.0,
        //   height: 0.0,
        // ),
        title: Text(Languages.of(context)!.myCorner,
            style: const TextStyle(
                color: Color(0xff2a2a2a),
                fontWeight: FontWeight.w700,
                fontFamily: "Alexandria",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            textAlign: TextAlign.end),
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saved = true;
                      liked = false;
                      history = false;
                    });
                    _checkInternetConnection();
                  },
                  child: Container(
                      width: width * 0.25,
                      height: height * 0.04,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(17)),
                          color:
                              saved ? const Color(0xff3a6c83) : Colors.black54),
                      child: Center(
                        child: Text(
                          Languages.of(context)!.saved,
                          style: _widgetTextStyle(),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saved = false;
                      liked = true;
                      history = false;
                    });

                    _checkInternetConnectionQ();
                  },
                  child: Container(
                      width: width * 0.25,
                      height: height * 0.04,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(17)),
                          color:
                              liked ? const Color(0xff3a6c83) : Colors.black54),
                      child: Center(
                        child: Text(
                          Languages.of(context)!.liked,
                          style: _widgetTextStyle(),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saved = false;
                      liked = false;
                      history = true;
                    });
                  },
                  child: Container(
                      width: width * 0.3,
                      height: height * 0.04,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(17)),
                          color: history
                              ? const Color(0xffebf5f9)
                              : const Color(0xffebf5f9)),
                      child: Center(
                        child: Text(
                          "",
                          style: _widgetTextStyle(),
                        ),
                      )),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: height * 0.02),
              width: width,
              height: 1,
              decoration: const BoxDecoration(color: Color(0xffbcbcbc))),
          Expanded(
            child: _isInternetConnected
                ? _isLoading
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
                    : saved
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.03,
                                right: width * 0.01),
                            child: _savedBooksModel!.data.isEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.all(height * width * 0.0004),
                                    child: Center(
                                      child: Text(
                                        Languages.of(context)!.nodata,
                                        style: const TextStyle(
                                            fontFamily: Constants.fontfamily,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _savedBooksModel!.data.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Transitioner(
                                            context: context,
                                            child: BookDetail(
                                              bookID: _savedBooksModel!
                                                  .data[index].id
                                                  .toString(),
                                            ),
                                            animation: AnimationType
                                                .slideTop, // Optional value
                                            duration: const Duration(
                                                milliseconds:
                                                    1000), // Optional value
                                            replacement:
                                                false, // Optional value
                                            curveType: CurveType
                                                .decelerate, // Optional value
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.03,
                                              right: width * 0.01),
                                          child: Container(
                                            width: width * 0.7,
                                            height: height * 0.12,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Color(0xffffffff)),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: width * 0.2,
                                                    height: height * 0.15,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                _savedBooksModel!
                                                                    .data[index]
                                                                    .imagePath
                                                                    .toString()),
                                                            fit: BoxFit.cover),
                                                        color: Colors.green)),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        _savedBooksModel!
                                                            .data[index].title
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Alexandria",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 12.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          _savedBooksModel!
                                                              .data[index]
                                                              .username
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff676767),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "Lato",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 12.0),
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.03,
                                right: width * 0.01),
                            child: _likesBooksModel!.data.isEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.all(height * width * 0.0004),
                                    child: Center(
                                      child: Text(
                                        Languages.of(context)!.nodata,
                                        style: const TextStyle(
                                            fontFamily: Constants.fontfamily,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _likesBooksModel!.data.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Transitioner(
                                            context: context,
                                            child: BookDetail(
                                              bookID: _likesBooksModel!
                                                  .data[index].id
                                                  .toString(),
                                            ),
                                            animation: AnimationType
                                                .slideTop, // Optional value
                                            duration: const Duration(
                                                milliseconds:
                                                    1000), // Optional value
                                            replacement:
                                                false, // Optional value
                                            curveType: CurveType
                                                .decelerate, // Optional value
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.03,
                                              right: width * 0.01),
                                          child: Container(
                                            width: width * 0.7,
                                            height: height * 0.12,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Color(0xffffffff)),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      width: width * 0.2,
                                                      height: height * 0.15,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(10),
                                                          ),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  _likesBooksModel!
                                                                      .data[
                                                                          index]
                                                                      .imagePath
                                                                      .toString()),
                                                              fit:
                                                                  BoxFit.cover),
                                                          color: Colors.green)),
                                                ),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          _likesBooksModel!
                                                              .data[index].title
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff2a2a2a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Alexandria",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 12.0),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                            _likesBooksModel!
                                                                .data[index]
                                                                .username
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xff676767),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Lato",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 12.0),
                                                            textAlign: TextAlign
                                                                .left)),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                : Center(
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
                        GestureDetector(
                          child: Container(
                            width: width * 0.2,
                            height: height * 0.058,
                            decoration: const BoxDecoration(
                                color: Color(0xFF256D85),
                                shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.sync,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _checkInternetConnection();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  _widgetTextStyle() {
    return const TextStyle(
        color: Color(0xffffffff),
        fontWeight: FontWeight.w400,
        fontFamily: "Alexandria",
        fontStyle: FontStyle.normal,
        fontSize: 12.0);
  }

  Future SavedBooksApiCall() async {
    try {
      final rows = await SupabaseFavoriteRepository().getMyFavorites();
      final adapter = SupabaseLegacyApiAdapter();
      _savedBooksModel = saved_model.SavedBooksModel(
        status: 200,
        data: rows
            .map((row) => _savedBookDatum(row, adapter))
            .whereType<saved_model.Datum>()
            .toList(),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('supabase_saved_books_error $error');
      Constants.warning(context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future LikesBooksApiCall() async {
    _likesBooksModel = likes_model.LikesBooksModel(
      status: 200,
      data: <likes_model.Datum>[],
    );
    setState(() {
      _isLoading = false;
    });
  }

  saved_model.Datum? _savedBookDatum(
    Map<String, dynamic> row,
    SupabaseLegacyApiAdapter adapter,
  ) {
    final book = row['books'];
    if (book is! Map) return null;
    final bookMap = Map<String, dynamic>.from(book);
    final author = bookMap['author'];
    final authorMap = author is Map ? Map<String, dynamic>.from(author) : null;
    return saved_model.Datum(
      id: adapter.legacyBookIdFromUuid((bookMap['id'] ?? '').toString()),
      title: (bookMap['title_ar'] ?? bookMap['title_en'] ?? '').toString(),
      image: (bookMap['cover_url'] ?? '').toString(),
      username: (authorMap?['display_name'] ?? authorMap?['username'] ?? '')
          .toString(),
      paymentStatus: 1,
      imagePath: (bookMap['cover_url'] ?? '').toString(),
    );
  }

  Future _checkInternetConnection() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _isInternetConnected = true;
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
      SavedBooksApiCall();
    }
  }

  Future _checkInternetConnectionQ() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _isInternetConnected = true;
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
      LikesBooksApiCall();
    }
  }
}
