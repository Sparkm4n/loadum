class SourcesModel {
  SourcesModel({
    bool? status,
    String? message,
    List<Source>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  SourcesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Source.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Source>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Source>? get data => _data;

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

class Source {
  Source({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Source.fromJson(dynamic json) {
    _id = json['id'].toString();
    _name = json['name'];
  }
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}
