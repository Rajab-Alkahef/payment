import 'dart:developer';

import 'package:checkout_payment_ui/Features/checkout/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/init_payment_sheet_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent/payment_intent.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    log("create payment intent called");

    var response = await apiService.post(
        body: paymentIntentInputModel.toJson(),
        url: "https://api.stripe.com/v1/payment_intents",
        token: ApiKeys.secretKey,
        contentType: Headers.formUrlEncodedContentType);

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
    // log("message");
    return paymentIntentModel;
  }

  Future initPaymentSheet(
      {required InitPaymentSheetInputModel initPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: initPaymentSheetInputModel.clientSecret,
          customerEphemeralKeySecret: initPaymentSheetInputModel.ephemeralKey,
          customerId: initPaymentSheetInputModel.customerId,
          merchantDisplayName: "Rajab"),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputmodel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputmodel);
    var ephemeralKey = await createEphemearlKey(
        customerId: paymentIntentInputmodel.customerId);
    var initpaymentSheetInputModel = InitPaymentSheetInputModel(
        clientSecret: paymentIntentModel.clientSecret!,
        customerId: paymentIntentInputmodel.customerId,
        ephemeralKey: ephemeralKey.secret!);

    await initPaymentSheet(
        initPaymentSheetInputModel: initpaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemearlKey(
      {required String customerId}) async {
    var response = await apiService.post(
      body: {"customer": customerId},
      url: "https://api.stripe.com/v1/ephemeral_keys",
      token: ApiKeys.secretKey,
      contentType: Headers.formUrlEncodedContentType,
      headers: {
        'Stripe-Version': '2024-10-28.acacia',
        'Content-Type': Headers.formUrlEncodedContentType,
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
      },
    );

    var ephemeralKey = EphemeralKeyModel.fromJson(response.data);
    return ephemeralKey;
  }
}
