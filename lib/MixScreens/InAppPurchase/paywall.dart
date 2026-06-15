import 'package:flutter/material.dart';

import '../../Utils/Constants.dart';
import '../../localization/Language/languages.dart';

class Paywall extends StatelessWidget {
  final dynamic offering;

  const Paywall({Key? key, this.offering}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            Languages.of(context)?.free1 ?? 'Read Free',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: Constants.fontfamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
