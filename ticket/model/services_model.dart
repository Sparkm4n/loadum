class ServiceModel {
  ServiceModel({
    bool? status,
    String? message,
    List<Service>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  ServiceModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Service.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Service>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Service>? get data => _data;

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

class Service {
  Service({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Service.fromJson(dynamic json) {
    _id = json['serviceid'].toString();
    _name = json['name'];
  }
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceid'] = _id;
    map['name'] = _name;
    return map;
  }
}
