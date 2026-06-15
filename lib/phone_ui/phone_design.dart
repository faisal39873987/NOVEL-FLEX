import 'package:flutter/material.dart';

class PhoneUiColors {
  const PhoneUiColors._();

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const ink = Color(0xFF070707);
  static const muted = Color(0xFF8B8B8B);
  static const soft = Color(0xFFF1F1F1);
  static const line = Color(0xFFE6E6E6);
  static const cyan = Color(0xFF74F5EA);
  static const blue = Color(0xFF5B58FF);
  static const lime = Color(0xFFD9F957);
  static const lavender = Color(0xFFE9DBFF);
}

class PhoneUi {
  const PhoneUi._();

  static const double screenPadding = 18;
  static const double panelRadius = 34;
  static const double pillRadius = 22;
  static const double navHeight = 86;

  static const LinearGradient searchGradient = LinearGradient(
    colors: <Color>[PhoneUiColors.cyan, PhoneUiColors.blue],
  );

  static const LinearGradient fantasyGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFFE8FAFF), Color(0xFFAED1FF)],
  );

  static const LinearGradient romanceGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFFFFECEA), Color(0xFFFFC5CD)],
  );

  static const LinearGradient discussionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFEBCFFF), Color(0xFFCBEAFF)],
  );

  static TextStyle title(BuildContext context,
      {Color color = PhoneUiColors.ink}) {
    return TextStyle(
      color: color,
      fontSize: 31,
      height: 1.05,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    return const TextStyle(
      color: PhoneUiColors.ink,
      fontSize: 24,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
  }

  static TextStyle body(BuildContext context,
      {Color color = PhoneUiColors.ink}) {
    return TextStyle(
      color: color,
      fontSize: 15,
      height: 1.35,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
  }

  static TextStyle meta(BuildContext context) {
    return const TextStyle(
      color: PhoneUiColors.muted,
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
  }
}
