import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:transitioner/transitioner.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/toast.dart';

class PaymentDoneScreen extends StatefulWidget {
  const PaymentDoneScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDoneScreen> createState() => _PaymentDoneScreenState();
}

class _PaymentDoneScreenState extends State<PaymentDoneScreen> {
  @override
  void initState() {
    Subscribe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0,
        leading: const SafeBackButton(),
      ),
      body: const SizedBox(
        height: double.infinity,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  Future Subscribe() async {
    ToastConstant.showToast(
        context, "Subscriptions are not available in this MVP.");
    Transitioner(
      context: context,
      child: const TabScreen(),
      animation: AnimationType.slideLeft,
      duration: const Duration(milliseconds: 1000),
      replacement: true,
      curveType: CurveType.decelerate,
    );
  }
}
