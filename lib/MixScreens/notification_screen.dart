import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:transitioner/transitioner.dart';

import '../Models/NotificationsModel.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import '../data/services/supabase_mvp_service.dart';
import '../localization/Language/languages.dart';
import 'BooksScreens/BookDetail.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationsModel? _notificationsModel;
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        child: _notificationsModel!.data.isEmpty
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
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(bottom: height * 0.05),
                                child: ListView.builder(
                                    itemCount: _notificationsModel!.data.length,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext buildContext, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Transitioner(
                                            context: context,
                                            child: BookDetail(
                                              bookID: _notificationsModel!
                                                  .data[index].bookId
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
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.02,
                                                  bottom: height * 0.03),
                                              child: Opacity(
                                                opacity: 0.5,
                                                child: Container(
                                                    width: width,
                                                    height: 1,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xffbcbcbc))),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    height: height * 0.1,
                                                    width: width * 0.15,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: _notificationsModel!
                                                                        .data[
                                                                            index]
                                                                        .userImage ==
                                                                    " "
                                                                ? const AssetImage(
                                                                    "assets/Novelflex_main.png")
                                                                : NetworkImage(_notificationsModel!
                                                                        .data[index]
                                                                        .userImage
                                                                        .toString())
                                                                    as ImageProvider,
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.4,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${_notificationsModel!.data[index].bookTitle}",
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff2a2a2a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "Neckar",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 14.0),
                                                          textAlign:
                                                              TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                        Text(
                                                          _notificationsModel!
                                                              .data[index]
                                                              .bodyEn,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff2a2a2a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  "Neckar",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 12.0),
                                                          textAlign:
                                                              TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.09,
                                                    width: width * 0.2,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                _notificationsModel!
                                                                    .data[index]
                                                                    .bookImage
                                                                    .toString()),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(
                                            //       top: _height * 0.01,
                                            //       bottom: _height * 0.01),
                                            //   child: Opacity(
                                            //     opacity: 0.5,
                                            //     child: Container(
                                            //         width: _width,
                                            //         height: 1,
                                            //         decoration: BoxDecoration(
                                            //             color:
                                            //                 const Color(0xffbcbcbc))),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                      ),
                    )
              : const Center(
                  child: Text("No Internet Connection!"),
                ),
        ));
  }

  Future Notifications() async {
    try {
      final rows = await SupabaseMvpService().notifications();
      _notificationsModel = NotificationsModel(
        status: 200,
        message: 'success',
        data: rows.map(_notificationDatum).toList(),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      ToastConstant.showToast(context, error.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future NotificationsSeen() async {
    await SupabaseMvpService().markNotificationsRead();
    print("done_notification set to zero");
  }

  Datum _notificationDatum(Map<String, dynamic> row) {
    final bookId = (row['book_id'] ?? row['target_id'] ?? '').toString();
    return Datum(
      id: _stableIntId((row['id'] ?? '').toString()),
      bookId: int.tryParse(bookId) ?? _stableIntId(bookId),
      bookTitle: row['book_title'] ?? row['title'] ?? '',
      bookImage: row['book_image'] ?? row['bookImage'],
      userImage: row['user_image'] ?? row['avatar_url'] ?? ' ',
      titleEn: (row['title_en'] ?? row['title'] ?? '').toString(),
      titleAr: TitleAr.EMPTY,
      bodyEn: (row['body_en'] ?? row['body'] ?? '').toString(),
      bodyAr: (row['body_ar'] ?? row['body'] ?? '').toString(),
      seen: row['is_read'] == true || row['seen'] == true ? 1 : 0,
    );
  }

  int _stableIntId(String value) {
    var hash = 0;
    for (final code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
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
      Notifications();
      NotificationsSeen();
    }
  }
}
