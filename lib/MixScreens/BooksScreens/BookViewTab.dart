import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../../Models/BoolAllPdfViewModelClass.dart';
import '../../Models/GetAudioBookModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/AudioCommon.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../../data/services/supabase_legacy_api_adapter.dart';
import '../../localization/Language/languages.dart';
import '../PdfScreens/pdf_main.dart';

class BookViewTab extends StatefulWidget {
  String bookId;
  String bookName;
  String readerId;
  String PaymentStatus;
  String cover_url;
  BookViewTab(
      {Key? key,
      required this.bookId,
      required this.bookName,
      required this.readerId,
      required this.PaymentStatus,
      required this.cover_url})
      : super(key: key);

  @override
  State<BookViewTab> createState() => _BookViewTabState();
}

class _BookViewTabState extends State<BookViewTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: FadeScrollAppBar(
        scrollController: _scrollController,
        elevation: 0.0,
        backgroundColor: const Color(0xffebf5f9),
        // elevation: 0.0,
        appBarLeading: Platform.isIOS
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
                ))
            : Container(),
        expandedHeight: height * 0.162,
        appBarShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        fadeWidget: Container(),
        bottomWidgetHeight: 10,
        bottomWidget: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xff1b4a6b),
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.menu_book,
                      color: Color(0xff1b4a6b),
                    ),
                    child: Text(
                      'PDF',
                      style: TextStyle(
                          color: Color(0xff1b4a6b),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Neckar",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.audiotrack_outlined,
                      color: Color(0xff1b4a6b),
                    ),
                    child: Text(
                      'Audio',
                      style: TextStyle(
                          color: Color(0xff1b4a6b),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Neckar",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.text_fields_outlined,
                      color: Color(0xff1b4a6b),
                    ),
                    child: Text(
                      'Text',
                      style: TextStyle(
                          color: Color(0xff1b4a6b),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Neckar",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            PdfTab(
              image_url: widget.cover_url,
              bookId: widget.bookId,
              bookName: widget.bookName,
              readerId: widget.readerId,
              PaymentStatus: widget.PaymentStatus,
            ),
            AudioTab(
              image_url: widget.cover_url,
              bookId: widget.bookId,
            ),
            TextTab(
              bookId: widget.bookId,
            ),
          ],
        ),
      ),
    );
  }
}

class PdfTab extends StatefulWidget {
  String bookId;
  String bookName;
  String readerId;
  String PaymentStatus;
  String image_url;
  PdfTab(
      {Key? key,
      required this.bookId,
      required this.bookName,
      required this.readerId,
      required this.PaymentStatus,
      required this.image_url})
      : super(key: key);

  @override
  State<PdfTab> createState() => _PdfTabState();
}

class _PdfTabState extends State<PdfTab> {
  BoolAllPdfViewModelClass? _boolAllPdfViewModelClass;

  bool _isLoading = false;

  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection();
    BookViewApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
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
                : _boolAllPdfViewModelClass!.data.isEmpty
                    ? Center(
                        child: Text(
                          Languages.of(context)!.nodata,
                          style: const TextStyle(
                              fontFamily: Constants.fontfamily,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.1),
                                child: ClipRRect(
                                  child: Container(
                                    width: width * 0.35,
                                    height: height * 0.2,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0)),
                                        color: const Color(0xffebf5f9),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                widget.image_url))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(height * 0.05),
                                child: Center(
                                  child: Text(
                                    "${widget.bookName.toString()} ${Languages.of(context)!.episodes}",
                                    style: const TextStyle(
                                        color: Color(0xff2a2a2a),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Neckar",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    _boolAllPdfViewModelClass!.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Transitioner(
                                        context: context,
                                        child: PinchPage(
                                          url: _boolAllPdfViewModelClass!
                                              .data[index].lessonPath,
                                          name: _boolAllPdfViewModelClass!
                                              .data[index].lesson
                                              .toString(),
                                        ),
                                        animation: AnimationType.slideLeft,
                                        duration: const Duration(milliseconds: 1000),
                                        replacement: false,
                                        curveType: CurveType.decelerate,
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(height * 0.008),
                                      child: Column(
                                        children: [
                                          Opacity(
                                            opacity: 0.20000000298023224,
                                            child: Container(
                                                width: 368,
                                                height: 0.5,
                                                decoration: const BoxDecoration(
                                                    color: Color(
                                                        0xff3a6c83))),
                                          ),
                                          ListTile(
                                            title: _boolAllPdfViewModelClass!
                                                        .data[index].lesson ==
                                                    null
                                                ? Text(
                                                    "${index + 1}. ${widget.bookName}",
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Alexandria",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                  )
                                                : Text(
                                                    "${index + 1}. ${_boolAllPdfViewModelClass!.data[index].lesson.toString()}",
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Alexandria",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                  ),
                                            subtitle: Text(
                                              DateFormat.yMd('en-IN').format(
                                                  _boolAllPdfViewModelClass!
                                                      .data[index].createdAt),
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    Icons
                                                        .label_important_outlined,
                                                    color: Colors.red),
                                                Text(
                                                  Languages.of(context)!.free1,
                                                  style:
                                                      const TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 0.20000000298023224,
                                            child: Container(
                                                width: 368,
                                                height: 0.5,
                                                decoration: const BoxDecoration(
                                                    color: Color(
                                                        0xff3a6c83))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
            : const Center(
                child: Text("No Internet Connection!"),
              ));
  }

  Future AllChaptersApiCall() async {
    try {
      final jsonData1 = await SupabaseLegacyApiAdapter()
          .bookPdfFiles(int.parse(widget.bookId.toString()));
      if (jsonData1['status'] == 200) {
        final jsonData = json.encode(jsonData1);
        _boolAllPdfViewModelClass = boolAllPdfViewModelClassFromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      ToastConstant.showToast(context, "Unable to load PDF chapters");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future BookViewApi() async {
    var map = <String, dynamic>{};
    map['book_id'] = widget.bookId.toString();
    map['reader_id'] = context.read<UserProvider>().UserID.toString();
    final response = await http.post(Uri.parse(ApiUtils.BOOK_VIEW_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        print("This user already view this book");
      } else {
        print("book_view_by_user");
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
      AllChaptersApiCall();
      BookViewApi();
    }
  }
}

class AudioTab extends StatefulWidget {
  String image_url;
  String bookId;
  AudioTab({Key? key, required this.image_url, required this.bookId})
      : super(key: key);

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  bool loading = true;
  bool _isInternetConnected = true;
  GetAudioBookModel? _getAudioBookModel;
  String? text = "";

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  Future<void> _init(var url) async {
    // https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: SafeArea(
        child: _isInternetConnected
            ? loading
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
                : text!.isEmpty
                    ? Center(
                        child: Text(
                          Languages.of(context)!.nodata,
                          style: const TextStyle(
                              color: Color(0xff3a6c83),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            child: Container(
                              width: width * 0.35,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5)),
                                  color: const Color(0xffebf5f9),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.image_url))),
                            ),
                          ),
                          // Display seek bar. Using StreamBuilder, this widget rebuilds
                          // each time the position, buffered position or duration changes.
                          StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SeekBar(
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                bufferedPosition:
                                    positionData?.bufferedPosition ??
                                        Duration.zero,
                                onChangeEnd: _player.seek,
                              );
                            },
                          ),
                          // Display play/pause button and volume/speed sliders.
                          loading
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : ControlButtons(_player),
                        ],
                      )
            : const Center(
                child: Text("No Internet Connection!"),
              ),
      ),
    );
  }

  Future AUDIO_LINK() async {
    var map = <String, dynamic>{};
    map['bookId'] = widget.bookId.toString();
    final response = await http.post(Uri.parse(ApiUtils.GET_AUDIO_BOOK),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('AudioLink${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        _getAudioBookModel = GetAudioBookModel.fromJson(jsonData);
        print(
          "Audio_link ${_getAudioBookModel!.data.audio.toString()}",
        );
        _init(_getAudioBookModel!.data.audio.toString());
        setState(() {
          text = "NoNull";
          loading = false;
        });
      } else if (jsonData['status'] == 401) {
        setState(() {
          text = "";
          loading = false;
        });
      } else {
        ToastConstant.showToast(context, "Audio does not Exits for this book");
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
    if (mounted) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi)) {
        Constants.showToastBlack(context, "Internet not connected");
        if (mounted) {
          setState(() {
            _isInternetConnected = false;
          });
        }
      } else {
        AUDIO_LINK();
      }
    }
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: Icon(
            Icons.volume_up,
            color: const Color(0xff1b4a6b),
            size: height * width * 0.00012,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CupertinoActivityIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: height * width * 0.00015,
                color: const Color(0xff1b4a6b),
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: height * width * 0.00015,
                onPressed: player.pause,
                color: const Color(0xff1b4a6b),
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: height * width * 0.00015,
                color: const Color(0xff1b4a6b),
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b4a6b),
                    fontSize: 15)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class TextTab extends StatefulWidget {
  final bookId;
  const TextTab({Key? key, required this.bookId}) : super(key: key);

  @override
  State<TextTab> createState() => _TextTabState();
}

class _TextTabState extends State<TextTab> {
  bool loading = true;
  bool _isInternetConnected = true;
  String? text = "notNull";

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: loading
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
          : text!.isEmpty
              ? Center(
                  child: Text(
                    Languages.of(context)!.nodata,
                    style: const TextStyle(
                        color: Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.01),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          text
                              .toString()
                              .replaceAll("</p>", "")
                              .replaceAll("<p>", ""),
                          style: const TextStyle(
                            // color: const Color(0xff002333),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontFamily: "Lato",
                            height: 2,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future TEXT_LINK() async {
    var map = <String, dynamic>{};
    map['bookId'] = widget.bookId.toString();
    final response = await http.post(Uri.parse(ApiUtils.GET_TEXT_BOOK),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('Text_book${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        setState(() {
          if (jsonData['data'].toString() == "[]") {
            text = "";
          } else {
            text = jsonData['data'][0];
          }

          loading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData['message'].toString());
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
    if (mounted) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi)) {
        Constants.showToastBlack(context, "Internet not connected");
        if (mounted) {
          setState(() {
            _isInternetConnected = false;
          });
        }
      } else {
        TEXT_LINK();
      }
    }
  }
}
