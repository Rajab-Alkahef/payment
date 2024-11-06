import 'dart:developer';

import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/repos/checkout_repo.dart';
import 'package:checkout_payment_ui/core/errors/failure.dart';
import 'package:checkout_payment_ui/core/utils/stripe_service.dart';
import 'package:dartz/dartz.dart';

class CheckoutRepoImpl extends CheckoutRepo {
  final StripeService stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(
          paymentIntentInputmodel: paymentIntentInputModel);
      return right(null);
    } catch (e) {
      log("message: ${e.toString()}");
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
