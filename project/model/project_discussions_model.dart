class ProjectDiscussionsModel {
  ProjectDiscussionsModel({
    bool? status,
    String? message,
    List<Discussion>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  ProjectDiscussionsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Discussion.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Discussion>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Discussion>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Discussion {
  Discussion({
    String? id,
    String? projectId,
    String? subject,
    String? description,
    String? showToCustomer,
    String? datecreated,
    String? lastActivity,
    String? staffId,
    String? contactId,
    String? totalComments,
  }) {
    _id = id;
    _projectId = projectId;
    _subject = subject;
    _description = description;
    _showToCustomer = showToCustomer;
    _datecreated = datecreated;
    _lastActivity = lastActivity;
    _staffId = staffId;
    _contactId = contactId;
    _totalComments = totalComments;
  }

  Discussion.fromJson(dynamic json) {
    _id = json['id'];
    _projectId = json['project_id'];
    _subject = json['subject'];
    _description = json['description'];
    _showToCustomer = json['show_to_customer'];
    _datecreated = json['datecreated'];
    _lastActivity = json['last_activity'];
    _staffId = json['staff_id'];
    _contactId = json['contact_id'];
    _totalComments = json['total_comments'].toString();
  }

  String? _id;
  String? _projectId;
  String? _subject;
  String? _description;
  String? _showToCustomer;
  String? _datecreated;
  String? _lastActivity;
  String? _staffId;
  String? _contactId;
  String? _totalComments;

  String? get id => _id;
  String? get projectId => _projectId;
  String? get subject => _subject;
  String? get description => _description;
  String? get showToCustomer => _showToCustomer;
  String? get datecreated => _datecreated;
  String? get lastActivity => _lastActivity;
  String? get staffId => _staffId;
  String? get contactId => _contactId;
  String? get totalComments => _totalComments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['project_id'] = _projectId;
    map['subject'] = _subject;
    map['description'] = _description;
    map['show_to_customer'] = _showToCustomer;
    map['datecreated'] = _datecreated;
    map['last_activity'] = _lastActivity;
    map['staff_id'] = _staffId;
    map['contact_id'] = _contactId;
    map['total_comments'] = _totalComments;

    return map;
  }
}
