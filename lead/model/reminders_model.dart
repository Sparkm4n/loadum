class RemindersModel {
  RemindersModel({
    bool? status,
    String? message,
    List<Reminder>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  RemindersModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Reminder.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Reminder>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Reminder>? get data => _data;

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

class Reminder {
  Reminder({
    String? id,
    String? description,
    String? relId,
    String? relType,
    String? date,
    String? isNotified,
    String? staffId,
    String? creator,
  }) {
    _id = id;
    _description = description;
    _relId = relId;
    _relType = relType;
    _date = date;
    _isNotified = isNotified;
    _staffId = staffId;
    _creator = creator;
  }
  Reminder.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _relId = json['rel_id'];
    _relType = json['rel_type'];
    _date = json['date'];
    _isNotified = json['isnotified'];
    _staffId = json['staffid'];
    _creator = json['creator'];
  }

  String? _id;
  String? _description;
  String? _relId;
  String? _relType;
  String? _date;
  String? _isNotified;
  String? _staffId;
  String? _creator;

  String? get id => _id;
  String? get description => _description;
  String? get relId => _relId;
  String? get relType => _relType;
  String? get date => _date;
  String? get isNotified => _isNotified;
  String? get staffId => _staffId;
  String? get creator => _creator;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['rel_id'] = _relId;
    map['rel_type'] = _relType;
    map['date'] = _date;
    map['isnotified'] = _isNotified;
    map['staffid'] = _staffId;
    map['creator'] = _creator;
    return map;
  }
}
