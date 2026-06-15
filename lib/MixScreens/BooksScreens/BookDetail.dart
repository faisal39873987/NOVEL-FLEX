import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/Models/LikeDislikeModel.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/BookDetailsModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Provider/VariableProvider.dart';
import '../../Utils/Constants.dart';
import '../../Utils/navigation_utils.dart';
import '../../Widgets/loading_widgets.dart';
import '../../data/services/supabase_legacy_api_adapter.dart';
import '../../localization/Language/languages.dart';
import 'BookViewTab.dart';
import 'AuthorViewByUserScreen.dart';
import 'BookReviewScreen.dart';

class BookDetail extends StatefulWidget {
  String bookID;
  BookDetail({super.key, required this.bookID});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  bool _isLoading = false;
  bool _isInternetConnected = true;
  BookDetailsModel? _bookDetailsModel;
  LikeDislikeModel? _likeDislikeModel;
  var token;
  bool? _isLike;
  bool? _isDisLike;
  bool _isSaved = false;
  Stream? stream;
  dynamic chatCount;
  bool _hasReadableChapters = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  _listener() {
    chatCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    VariableProvider userProvider =
        Provider.of<VariableProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0,
          leading: const SafeBackButton(),
        ),
        body: _isInternetConnected == false
            ? Center(
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
              )
            : _isLoading
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.4,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Positioned(
                              child: Container(
                                height: height * 0.3,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: <Color>[
                                        Color(0xff2b5876),
                                        Color(0xff4e4376)
                                      ]),
                                ),
                              ),
                            ),
                            Positioned(
                              top: height * 0.08,
                              left: width * 0.25,
                              right: width * 0.25,
                              child: InkWell(
                                onTap: () {
                                  _openReader();
                                },
                                child: SizedBox(
                                  height: height * 0.33,
                                  width: width,
                                  child: Container(
                                    height: height * 0.33,
                                    width: width * 0.3,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: <Color>[
                                            Color(0xffaa076b),
                                            Color(0xff61045f)
                                          ]),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(_bookDetailsModel!
                                              .data.imagePath
                                              .toString())),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.39,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            paidWidget(),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(_bookDetailsModel!.data.bookTitle),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            GestureDetector(
                              onTap: () {
                                Transitioner(
                                  context: context,
                                  child: AuthorViewByUserScreen(
                                    user_id: _bookDetailsModel!.data.userId
                                        .toString(),
                                  ),
                                  animation:
                                      AnimationType.slideTop, // Optional value
                                  duration: const Duration(
                                      milliseconds: 1000), // Optional value
                                  replacement: false, // Optional value
                                  curveType:
                                      CurveType.decelerate, // Optional value
                                );
                              },
                              child: buildRow(
                                  width,
                                  _bookDetailsModel!.data.authorName.toString(),
                                  _bookDetailsModel!.data.userimage.toString()),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _bookDetailsModel!.data.subscription
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Languages.of(context)!.followers,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _bookDetailsModel!.data.publication
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Languages.of(context)!.published,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _bookDetailsModel!.data.gifts
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          Languages.of(context)!.gift,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          _bookDetailsModel!.data.bookView
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_isLike!) {
                                                _LikesDisLikesAPI("0");
                                                userProvider.setLikes(
                                                    userProvider.getLikes - 1);
                                                print("0");
                                              } else {
                                                _LikesDisLikesAPI("1");
                                                userProvider.setLikes(
                                                    userProvider.getLikes + 1);
                                                print("1");
                                              }

                                              _isLike = !_isLike!;
                                            });
                                          },
                                          child: Icon(
                                              _isLike!
                                                  ? Icons
                                                      .thumb_up_off_alt_rounded
                                                  : Icons.thumb_up_alt_outlined,
                                              color: _isLike!
                                                  ? const Color(0xff00bb23)
                                                  : Colors.black38),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          context
                                              .read<VariableProvider>()
                                              .getLikes
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Transitioner(
                                              context: context,
                                              child: ShowAllReviewScreen(
                                                bookId: _bookDetailsModel!
                                                    .data.bookId
                                                    .toString(),
                                                bookName: _bookDetailsModel!
                                                    .data.bookTitle
                                                    .toString(),
                                                bookImage: _bookDetailsModel!
                                                    .data.userimage
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
                                          child: const Icon(
                                            Icons.insert_comment,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          chatCount.toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  _openReader();
                                },
                                child: readWidget(width, height))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.3,
                            height: 1,
                            color: Colors.black12,
                          ),
                          Text(Languages.of(context)!.advertisement),
                          Container(
                            width: width * 0.3,
                            height: 1,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_bookDetailsModel!
                              .data.advertismentLinks.isEmpty) {
                            print("No Ads");
                          } else {
                            _launchProfileUrls(_bookDetailsModel!
                                .data.advertismentLinks[0].link
                                .toString());
                          }
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              child: Container(
                                margin: const EdgeInsets.all(16.0),
                                height: height * 0.14,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(_bookDetailsModel!
                                              .data.advertismentLinks.isEmpty
                                          ? ""
                                          : _bookDetailsModel!.data
                                              .advertismentLinks[0].imagePath
                                              .toString()),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(),
                              ),
                            ),
                            Positioned(
                              top: height * 0.022,
                              left: width * 0.046,
                              child: Container(
                                height: height * 0.03,
                                width: width * 0.075,
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                                child: const Center(
                                  child: Text(
                                    "Ad",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Alexandria",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ));
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
      _callBookDetailsAPI();
    }
  }

  Future _callBookDetailsAPI() async {
    setState(() {
      _isInternetConnected = true;
    });

    try {
      final jsonData = await SupabaseLegacyApiAdapter()
          .bookDetails(int.parse(widget.bookID));
      if (jsonData['status'] == 200) {
        _bookDetailsModel = BookDetailsModel.fromJson(jsonData);
        _hasReadableChapters = await SupabaseLegacyApiAdapter()
            .hasReadableBook(_bookDetailsModel!.data.bookId);
        print("status_likes${_bookDetailsModel!.data.status.status}");

        _isSaved = _bookDetailsModel!.data.bookSaved;
        VariableProvider userProvider =
            Provider.of<VariableProvider>(context, listen: false);

        userProvider.setLikes(_bookDetailsModel!.data.bookLike);

        if (_bookDetailsModel!.data.status.status == 1) {
          _isLike = true;
        } else {
          _isLike = false;
        }
        _listener();
        print(
            "likes_provider${context.read<VariableProvider>().getLikes.toString()}");
        setState(() {
          _isLoading = false;
        });
      } else {
        // Constants.showToastBlack(context, "Some things went wrong");
        Constants.warning(context);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      // Constants.showToastBlack(context, "Some things went wrong");
      Constants.warning(context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _LikesDisLikesAPI(String status) async {
    try {
      await SupabaseLegacyApiAdapter().setBookReaction(
        bookId: int.parse(widget.bookID),
        reaction: status == '1' ? 1 : -1,
      );
      _likeDislikeModel = LikeDislikeModel.fromJson(<String, dynamic>{
        'status': 200,
        'success': 'Reaction saved',
        'data': <String, dynamic>{
          'book_id': widget.bookID,
          'reader_id': context.read<UserProvider>().UserID.toString(),
          'status': status,
        },
      });
    } catch (_) {
      Constants.showToastBlack(context, "Some things went wrong");
    }
  }

  Future _SaveBookAPI() async {
    try {
      await SupabaseLegacyApiAdapter().saveBook(int.parse(widget.bookID));
      Constants.showToastBlack(context, "Book saved");
    } catch (_) {
      Constants.showToastBlack(context, "Some things went wrong");
    }
  }

  void _openReader() {
    if (_bookDetailsModel == null) {
      return;
    }

    if (!_hasReadableChapters) {
      Constants.showToastBlack(context, _noReadableChaptersMessage());
      return;
    }

    Transitioner(
      context: context,
      child: BookViewTab(
        bookId: _bookDetailsModel!.data.bookId.toString(),
        bookName: _bookDetailsModel!.data.bookTitle.toString(),
        readerId: _bookDetailsModel!.data.userId.toString(),
        PaymentStatus: _bookDetailsModel!.data.paymentStatus.toString(),
        cover_url: _bookDetailsModel!.data.imagePath.toString(),
      ),
      animation: AnimationType.slideTop,
      duration: const Duration(milliseconds: 1000),
      replacement: false,
      curveType: CurveType.decelerate,
    );
  }

  String _noReadableChaptersMessage() {
    final language = context.read<UserProvider>().SelectedLanguage;
    return language == 'Arabic'
        ? 'لا توجد فصول قابلة للقراءة حالياً'
        : 'No readable chapters are available yet';
  }

  Widget paidWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.free_breakfast_outlined,
          color: Color(0xff00bb23),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(Languages.of(context)!.freeStory),
        )
      ],
    );
  }

  Widget readWidget(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.7,
          height: height * 0.05,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x24000000),
                  offset: Offset(0, 7),
                  blurRadius: 14,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin:
                    const Alignment(-0.01018629550933838, -0.01894212305545807),
                end: const Alignment(1.6960868120193481, 1.3281718730926514),
                colors: _hasReadableChapters
                    ? const [
                        Color(0xff246897),
                        Color(0xff1b4a6b),
                      ]
                    : const [
                        Color(0xff9aa4ad),
                        Color(0xff717b84),
                      ]),
          ),
          child: Center(
            child: Text(
                _hasReadableChapters
                    ? Languages.of(context)!.read
                    : _noReadableChaptersMessage(),
                style: const TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.center),

            // Text(
            //     _bookDetailsModel!.data!.paymentStatus
            //                     .toString() ==
            //                 "1" ||
            //             _bookDetailsModel!.data!.userId
            //                     .toString() ==
            //                 context
            //                     .read<UserProvider>()
            //                     .UserID
            //                     .toString()
            //         ? Languages.of(context)!.read
            //         : _subscriptionModelClass!.success == true
            //             ? Languages.of(context)!.read
            //             : Languages.of(context)!.subscribeTxt,
            //     style: const TextStyle(
            //         color: const Color(0xffffffff),
            //         fontWeight: FontWeight.w700,
            //         fontFamily: "Lato",
            //         fontStyle: FontStyle.normal,
            //         fontSize: 14.0),
            //     textAlign: TextAlign.center),
          ),
        ),
        SizedBox(
          width: width * 0.05,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isSaved = !_isSaved;
              _SaveBookAPI();
            });
          },
          child: Container(
            width: width * 0.13,
            height: height * 0.12,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff3a6c83), width: 1),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x12000000),
                      offset: Offset(0, 7),
                      blurRadius: 14,
                      spreadRadius: 0),
                ],
                color: _isSaved
                    ? const Color(0xff3a6c83)
                    : const Color(0xfffafcfd)),
            child: _isSaved
                ? const Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.black,
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildRow(double width, String name, String path) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(path),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Text(name)
      ],
    );
  }

  _launchProfileUrls(var link) async {
    var url = Uri.parse(link.toString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
