class StatusesModel {
  StatusesModel({
    bool? status,
    String? message,
    List<Status>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  StatusesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Status.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Status>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Status>? get data => _data;

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

class Status {
  Status({
    String? id,
    String? name,
    String? statusOrder,
    String? color,
    String? isDefault,
  }) {
    _id = id;
    _name = name;
    _statusOrder = statusOrder;
    _color = color;
    _isDefault = isDefault;
  }

  Status.fromJson(dynamic json) {
    _id = json['id'].toString();
    _name = json['name'];
    _statusOrder = json['statusorder'];
    _color = json['color'];
    _isDefault = json['isdefault'];
  }
  String? _id;
  String? _name;
  String? _statusOrder;
  String? _color;
  String? _isDefault;

  String? get id => _id;
  String? get name => _name;
  String? get statusOrder => _statusOrder;
  String? get color => _color;
  String? get isDefault => _isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['statusorder'] = _statusOrder;
    map['color'] = _color;
    map['isdefault'] = _isDefault;
    return map;
  }
}
