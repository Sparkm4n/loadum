class DepartmentModel {
  DepartmentModel({
    bool? status,
    String? message,
    List<Department>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  DepartmentModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Department.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Department>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Department>? get data => _data;

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

class Department {
  Department({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Department.fromJson(dynamic json) {
    _id = json['departmentid'].toString();
    _name = json['name'];
  }
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['departmentid'] = _id;
    map['name'] = _name;
    return map;
  }
}
