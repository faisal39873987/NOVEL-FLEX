import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/MixScreens/FaqScreen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:transitioner/transitioner.dart';
import 'MixScreens/Uploadscreens/UploadDataScreen.dart';
import 'MixScreens/Uploadscreens/upload_history_screen.dart';
import 'Models/StatusCheckModel.dart';
import 'Provider/UserProvider.dart';
import 'TabScreens/MyCorner.dart';
import 'Utils/Colors.dart';

import 'Utils/Constants.dart';
import 'data/services/supabase_mvp_service.dart';
import 'localization/Language/languages.dart';
import 'phone_ui/phone_design.dart';
import 'phone_ui/phone_explore_screen.dart';
import 'phone_ui/phone_featured_screen.dart';
import 'phone_ui/phone_profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  int pageIndex = 1;
  StatusCheckModel? _statusCheckModel;
  bool _isLoading = false;
  late AnimationController _addController;
  final Screen = const [
    MyCorner(),
    PhoneFeaturedScreen(),
    PhoneExploreScreen(),
    PhoneProfileScreen(),
  ];

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // CHECK_STATUSType();
    _addController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: AppColors.primaryColor,
      body: Screen[pageIndex],
      // drawer: DrawerCode(),
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Widget buildMyNavBar(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: PhoneUi.navHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9E9E9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.bookmark_border,
            label: 'Library',
            active: pageIndex == 0,
            onTap: () => setState(() => pageIndex = 0),
          ),
          _NavItem(
            icon: Icons.auto_awesome,
            label: 'Featured',
            active: pageIndex == 1,
            onTap: () => setState(() => pageIndex = 1),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isLoading = true;
              });
              CHECK_STATUS();
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.inactive, width: 2)),
                width: 74,
                height: 74,
                margin: EdgeInsets.only(bottom: height * 0.028),
                child: _isLoading
                    ? Lottie.asset(LottieFiles.$71721_loading_icon_for_website,
                        controller: _addController,
                        height: height * width * 0.0002,
                        width: height * width * 0.0002,
                        fit: BoxFit.cover)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: PhoneUi.searchGradient,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'N',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )),
          ),
          _NavItem(
            icon: Icons.explore_outlined,
            label: 'Explore',
            active: pageIndex == 2,
            onTap: () => setState(() => pageIndex = 2),
          ),
          _NavItem(
            icon: Icons.sentiment_satisfied_alt,
            label: 'Profile',
            active: pageIndex == 3,
            onTap: () => setState(() => pageIndex = 3),
          ),
        ],
      ),
    );
  }

  Future CHECK_STATUS() async {
    try {
      _statusCheckModel = await SupabaseMvpService().currentStatus();
      CHECK_STATUSType();
    } catch (error) {
      print('supabase_status_error $error');
      warning();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future CHECK_STATUSType() async {
    if (_statusCheckModel == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_statusCheckModel!.data.type == "Writer") {
      _statusCheckModel!.aggrement == false
          ? showTermsAndConditionAlert()
          : _showSimpleDialog();

      setState(() {
        _isLoading = false;
      });
    } else {
      warning();
      Transitioner(
        context: context,
        child: const FaqScreen(),
        animation: AnimationType.slideLeft,
        duration: const Duration(milliseconds: 1000),
        replacement: false,
        curveType: CurveType.decelerate,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void warning() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        animType: QuickAlertAnimType.slideInUp,
        text:
            "${Languages.of(context)!.dialogTitle} ${context.read<UserProvider>().UserName} ${Languages.of(context)!.dialogTitleN}",
        confirmBtnColor: const Color(0xFF256D85),
        confirmBtnText: Languages.of(context)!.okText);
  }

  showTermsAndConditionAlert() {
    bool agree = false;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.black54,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  backgroundColor: const Color(0xFFe4e6fb),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  title: Text(
                    Languages.of(context)!.terms,
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  content: SizedBox(
                    height: 400,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Languages.of(context)!.longTextTerms,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Material(
                            color: const Color(0xFFe4e6fb),
                            child: Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                            ),
                          ),
                          Text(
                            Languages.of(context)!.termsText_1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10.0),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: agree ? _doSomething : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF256D85),
                                // fixedSize: Size(250, 50),
                              ),
                              child: Text(
                                Languages.of(context)!.agree,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: height * 0.15,
                    left: width * 0.87,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: height * 0.08,
                        width: width * 0.08,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/quotes_data/cancel_icon.png"))),
                      ),
                    ))
              ],
            );
          });
        });
  }

  void _doSomething() {
    setState(() {
      _updateTermsAndConditions();
      Navigator.pop(context);
    });
  }

  Future _updateTermsAndConditions() async {
    try {
      await SupabaseMvpService().acceptWriterTerms();
      setState(() {
        _statusCheckModel!.aggrement = true;
      });
      Transitioner(
        context: context,
        child: const UploadDataScreen(),
        animation: AnimationType.slideLeft,
        duration: const Duration(milliseconds: 1000),
        replacement: false,
        curveType: CurveType.decelerate,
      );
    } catch (error) {
      print('supabase_agreement_error $error');
      Constants.showToastBlack(context, "Some things went wrong");
    }
  }

  Future<void> _showSimpleDialog() async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    await showDialog<void>(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            // <-- SEE HERE
            contentPadding: EdgeInsets.all(width * 0.1),
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Transitioner(
                    context: ctx,
                    child: UploadHistoryscreen(
                      route: 1,
                    ),
                    animation: AnimationType.slideLeft, // Optional value
                    duration:
                        const Duration(milliseconds: 1000), // Optional value
                    replacement: false, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.add_link_outlined,
                      color: Color(0xff3a6c83),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Transitioner(
                          context: ctx,
                          child: UploadHistoryscreen(
                            route: 1,
                          ),
                          animation: AnimationType.slideLeft, // Optional value
                          duration: const Duration(
                              milliseconds: 1000), // Optional value
                          replacement: false, // Optional value
                          curveType: CurveType.decelerate, // Optional value
                        );
                      },
                      child: Text(Languages.of(context)!.addEpisodes),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Transitioner(
                    context: ctx,
                    child: const UploadDataScreen(),
                    animation: AnimationType.slideLeft,
                    // Optional value
                    duration: const Duration(milliseconds: 1000),
                    // Optional value
                    replacement: false,
                    // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.menu_book_sharp,
                      color: Color(0xff3a6c83),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Transitioner(
                          context: ctx,
                          child: const UploadDataScreen(),
                          animation: AnimationType.slideLeft,
                          // Optional value
                          duration: const Duration(milliseconds: 1000),
                          // Optional value
                          replacement: false,
                          // Optional value
                          curveType: CurveType.decelerate, // Optional value
                        );
                      },
                      child: Text(Languages.of(context)!.publishNovel),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          );
        });
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.black : const Color(0xFF9E9E9E);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
