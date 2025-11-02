class PriorityModel {
  PriorityModel({
    bool? status,
    String? message,
    List<Priority>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  PriorityModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Priority.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Priority>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Priority>? get data => _data;

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

class Priority {
  Priority({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Priority.fromJson(dynamic json) {
    _id = json['priorityid'].toString();
    _name = json['name'];
  }
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['priorityid'] = _id;
    map['name'] = _name;
    return map;
  }
}
