class ReminderCreateModel {
  final String date;
  final String staff;
  final String description;
  final String emailReminder;

  ReminderCreateModel({
    required this.date,
    required this.staff,
    required this.description,
    required this.emailReminder,
  });
}
