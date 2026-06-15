import 'package:flutter/material.dart';

import '../../localization/Language/languages.dart';
import 'forgetPasswordEmailScreen.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        title: Text(
          Languages.of(context)?.verifyPhone ?? 'Verify phone',
          style: const TextStyle(
            color: Color(0xff002333),
            fontWeight: FontWeight.w700,
            fontFamily: "Lato",
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.phoneNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordEmailScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(Languages.of(context)?.continuebtn ?? 'Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
