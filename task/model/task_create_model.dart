class TaskCreateModel {
  final String subject;
  final String startDate;
  final String relType;
  final String? isPublic;
  final String? billable;
  final String? hourlyRate;
  final String? milestone;
  final String? dueDate;
  final String? priority;
  final String? repeatEvery;
  final String? repeatEveryCustom;
  final String? repeatTypeCustom;
  final String? cycles;
  final String? relId;
  final String? tags;
  final String? description;

  TaskCreateModel({
    required this.subject,
    required this.startDate,
    required this.relType,
    this.isPublic,
    this.billable,
    this.hourlyRate,
    this.milestone,
    this.dueDate,
    this.priority,
    this.repeatEvery,
    this.repeatEveryCustom,
    this.repeatTypeCustom,
    this.cycles,
    this.relId,
    this.tags,
    this.description,
  });
}
