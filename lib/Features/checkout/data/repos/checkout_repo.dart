import 'package:checkout_payment_ui/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../models/payment_intent_input_model.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel});
}
