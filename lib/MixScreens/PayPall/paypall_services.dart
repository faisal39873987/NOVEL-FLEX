import 'package:flutter/widgets.dart';

class PaypalServices {
  Future<String?> getAccessToken() async {
    throw UnsupportedError(
      'PayPal OAuth must run on a trusted backend or Supabase Edge Function.',
    );
  }

  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    throw UnsupportedError(
      'PayPal payment creation must run on a trusted backend or Supabase Edge Function.',
    );
  }

  Future<String?> executePayment(
      url, payerId, accessToken, BuildContext context) async {
    throw UnsupportedError(
      'PayPal payment execution must run on a trusted backend or Supabase Edge Function.',
    );
  }
}
