class InitPaymentSheetInputModel {
  final String customerId;
  final String clientSecret;
  final String ephemeralKey;

  InitPaymentSheetInputModel(
      {required this.customerId,
      required this.clientSecret,
      required this.ephemeralKey});
}
