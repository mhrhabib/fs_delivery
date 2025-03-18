// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../payments/controllers/payment_controller.dart';
import '../services/api_list.dart';
import 'keys.dart';

Map<String, dynamic>? intentPaymentData;

makeIntentforPayment(amount, currency) async {
  try {
    Map<String, dynamic>? paymentInfo = {
      'amount': (int.parse(amount)).toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
    };
    print(paymentInfo);
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: paymentInfo,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (kDebugMode) {
      print('response from api${response.statusCode}');
    }
    print('response from api${response.body}');

    return jsonDecode(response.body);
  } catch (errorMsg, s) {
    if (kDebugMode) {
      print(s);
    }
    print(errorMsg.toString());
  }
}

void stripePaymentInitialize({BuildContext? context, String? amount, String? currency, String? paymentid}) async {
  try {
    intentPaymentData = await makeIntentforPayment(amount, currency);
    print(">>>>>>>>S $intentPaymentData");

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: intentPaymentData!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: 'FS Courier',
      ),
    );

    showPaymentSheet(context!, paymentid!, intentPaymentData!['amount']);
  } catch (errorMsg, s) {
    if (kDebugMode) {
      print(s);
    }
    print(errorMsg.toString());
  }
}

void showPaymentSheet(BuildContext context, String id, int amount) async {
  try {
    // Present the payment sheet
    var data = await Stripe.instance.presentPaymentSheet();

    print(" >>>>>>>>>>>>>>>>>>  ${data}");

    final PaymentController paymentController = Get.put(PaymentController(), permanent: true);

    paymentController.makePayment(
      amount: amount.toString(),
      paymentId: id,
      paymentType: 'card',
      paymentMethod: 'card',
      url: '${APIList.server}payments/stripe',
    );

    // Payment successful
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful!')),
    );

    Get.back();

    // Clear the payment intent data
    intentPaymentData = null;
  } on StripeException catch (e) {
    // Handle Stripe-specific errors
    if (kDebugMode) {
      print('Stripe Exception: ${e.toString()}');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${e.error.localizedMessage}')),
    );
  } catch (e) {
    // Handle generic errors
    if (kDebugMode) {
      print('Error: ${e.toString()}');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${e.toString()}')),
    );
  }
}
