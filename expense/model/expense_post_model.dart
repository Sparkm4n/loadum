class ExpensePostModel {
  final String? name;
  final String? note;
  final String category;
  final String date;
  final String amount;
  final String? customerId;

  ExpensePostModel({
    this.name,
    this.note,
    required this.category,
    required this.date,
    required this.amount,
    this.customerId,
  });
}
