import 'package:flutter/material.dart';

import '../TabScreens/home_screen.dart';

void safeBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen(route: "tab")),
  );
}

class SafeBackButton extends StatelessWidget {
  final Color color;
  final Color? backgroundColor;

  const SafeBackButton({
    Key? key,
    this.color = Colors.black54,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: () => safeBack(context),
      icon: Icon(Icons.arrow_back_ios, color: color),
    );

    if (backgroundColor == null) {
      return button;
    }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: button,
    );
  }
}
