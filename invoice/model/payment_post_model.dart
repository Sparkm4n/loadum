class PaymentPostModel {
  final String amountReceived;
  final String paymentDate;
  final String paymentMode;
  final String? transactionID;
  final String? note;

  PaymentPostModel({
    required this.amountReceived,
    required this.paymentDate,
    required this.paymentMode,
    this.transactionID,
    this.note,
  });
}
