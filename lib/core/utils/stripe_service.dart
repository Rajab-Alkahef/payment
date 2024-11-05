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
    var response = await apiService.post(
        body: paymentIntentInputModel.toJson(),
        url: "https://api.stripe.com/v1/payment_intents",
        token: ApiKeys.secretKey,
        contentType: Headers.formUrlEncodedContentType);

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
    return paymentIntentModel;
  }

  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Rajab"),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputmodel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputmodel);
    await initPaymentSheet(
        paymentIntentClientSecret: paymentIntentModel.clientSecret!);
    await displayPaymentSheet();
  }
}
