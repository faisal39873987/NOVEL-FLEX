import 'package:flutter/material.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  const PaypalPayment({super.key, required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        ),
      ),
      body: const Center(
        child: Text(
          'Payments are disabled in the free version.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
