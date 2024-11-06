import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/manager/stripe_payment_cubit/stripe_payment_cubit.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:checkout_payment_ui/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StripePaymentCubit, StripePaymentState>(
      listener: (context, state) {
        if (state is StripePaymentSuccess) {
          // Navigator.pop(context);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const ThankYouView();
          }));
        }

        if (state is StripePaymentFailure) {
          Navigator.pop(context);

          SnackBar snackBar = SnackBar(content: Text(state.errMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              PaymentIntentInputModel paymentIntentInputModel =
                  PaymentIntentInputModel(
                customerId: "cus_RAO3SoMvfmwCkK",
                amount: "100",
                currency: "usd",
                // paymentMethodTypes: ["card"],
              );
              BlocProvider.of<StripePaymentCubit>(context).makePayment(
                  paymentIntentInputModel: paymentIntentInputModel);
            },
            isLoading: state is StripePaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }
}
