class ExpenseCategoryModel {
  ExpenseCategoryModel({
    bool? status,
    String? message,
    List<ExpenseCategory>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  ExpenseCategoryModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ExpenseCategory.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<ExpenseCategory>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<ExpenseCategory>? get data => _data;

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

class ExpenseCategory {
  ExpenseCategory({String? id, String? name}) {
    _id = id;
    _name = name;
    _description = description;
  }

  ExpenseCategory.fromJson(dynamic json) {
    _id = json['id'].toString();
    _name = json['name'];
    _description = json['description'];
  }
  String? _id;
  String? _name;
  String? _description;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    return map;
  }
}
