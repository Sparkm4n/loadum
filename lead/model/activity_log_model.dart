class ActivityLogModel {
  ActivityLogModel({
    bool? status,
    String? message,
    List<ActivityLog>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  ActivityLogModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ActivityLog.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<ActivityLog>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<ActivityLog>? get data => _data;

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

class ActivityLog {
  ActivityLog({
    String? id,
    String? leadId,
    String? description,
    String? date,
    String? staffId,
    String? fullName,
    String? customActivity,
    String? additionalData,
  }) {
    _id = id;
    _leadId = leadId;
    _description = description;
    _date = date;
    _staffId = staffId;
    _fullName = fullName;
    _customActivity = customActivity;
    _additionalData = additionalData;
  }
  ActivityLog.fromJson(dynamic json) {
    _id = json['id'];
    _leadId = json['leadid'];
    _description = json['description'];
    _date = json['date'];
    _staffId = json['staffid'];
    _fullName = json['full_name'];
    _customActivity = json['custom_activity'];
    _additionalData = json['additional_data'];
  }

  String? _id;
  String? _leadId;
  String? _description;
  String? _date;
  String? _staffId;
  String? _fullName;
  String? _customActivity;
  String? _additionalData;

  String? get id => _id;
  String? get leadId => _leadId;
  String? get description => _description;
  String? get date => _date;
  String? get staffId => _staffId;
  String? get fullName => _fullName;
  String? get customActivity => _customActivity;
  String? get additionalData => _additionalData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['leadid'] = _leadId;
    map['description'] = _description;
    map['date'] = _date;
    map['staffid'] = _staffId;
    map['full_name'] = _fullName;
    map['custom_activity'] = _customActivity;
    map['additional_data'] = _additionalData;
    return map;
  }
}
