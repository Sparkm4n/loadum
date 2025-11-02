class TaxesModel {
  TaxesModel({
    bool? status,
    String? message,
    List<Tax>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  TaxesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Tax.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Tax>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Tax>? get data => _data;

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

class Tax {
  Tax({
    String? id,
    String? name,
    String? taxRate,
  }) {
    _id = id;
    _name = name;
    _taxRate = taxRate;
  }

  Tax.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _taxRate = json['taxrate'];
  }

  String? _id;
  String? _name;
  String? _taxRate;

  String? get id => _id;
  String? get name => _name;
  String? get taxRate => _taxRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['taxrate'] = _taxRate;
    return map;
  }
}
