class NotificationsModel {
  NotificationsModel({
    bool? status,
    String? message,
    List<Notifications>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  NotificationsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Notifications.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Notifications>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Notifications>? get data => _data;

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

class Notifications {
  Notifications({
    String? id,
    String? isRead,
    String? isReadInline,
    String? date,
    String? description,
    String? fromUserId,
    String? fromClientId,
    String? fromFullName,
    String? toUserId,
    String? fromCompany,
    String? link,
    String? additionalData,
    String? profileImage,
    String? formattedDescription,
    String? fullDate,
  }) {
    _id = id;
    _isRead = isRead;
    _isReadInline = isReadInline;
    _date = date;
    _description = description;
    _fromUserId = fromUserId;
    _fromClientId = fromClientId;
    _fromFullName = fromFullName;
    _toUserId = toUserId;
    _fromCompany = fromCompany;
    _link = link;
    _additionalData = additionalData;
    _profileImage = profileImage;
    _formattedDescription = formattedDescription;
    _fullDate = fullDate;
  }
  Notifications.fromJson(dynamic json) {
    _id = json['id'];
    _isRead = json['isread'];
    _isReadInline = json['isread_inline'];
    _date = json['date'];
    _description = json['description'];
    _fromUserId = json['fromuserid'];
    _fromClientId = json['fromclientid'];
    _fromFullName = json['from_fullname'];
    _toUserId = json['touserid'];
    _fromCompany = json['fromcompany'];
    _link = json['link'];
    _additionalData = json['additional_data'];
    _profileImage = json['profile_image'];
    _formattedDescription = json['formatted_description'];
    _fullDate = json['full_date'];
  }

  String? _id;
  String? _isRead;
  String? _isReadInline;
  String? _date;
  String? _description;
  String? _fromUserId;
  String? _fromClientId;
  String? _fromFullName;
  String? _toUserId;
  String? _fromCompany;
  String? _link;
  String? _additionalData;
  String? _profileImage;
  String? _formattedDescription;
  String? _fullDate;

  String? get id => _id;
  String? get isRead => _isRead;
  String? get isReadInline => _isReadInline;
  String? get date => _date;
  String? get description => _description;
  String? get fromUserId => _fromUserId;
  String? get fromClientId => _fromClientId;
  String? get fromFullName => _fromFullName;
  String? get toUserId => _toUserId;
  String? get fromCompany => _fromCompany;
  String? get link => _link;
  String? get additionalData => _additionalData;
  String? get profileImage => _profileImage;
  String? get formattedDescription => _formattedDescription;
  String? get fullDate => _fullDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['isread'] = _isRead;
    map['isread_inline'] = _isReadInline;
    map['date'] = _date;
    map['description'] = _description;
    map['fromuserid'] = _fromUserId;
    map['fromclientid'] = _fromClientId;
    map['from_fullname'] = _fromFullName;
    map['touserid'] = _toUserId;
    map['fromcompany'] = _fromCompany;
    map['link'] = _link;
    map['additional_data'] = _additionalData;
    map['profile_image'] = _profileImage;
    map['formatted_description'] = _formattedDescription;
    map['full_date'] = _fullDate;
    return map;
  }
}
