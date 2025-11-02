class PaymentModesModel {
  PaymentModesModel({
    bool? status,
    String? message,
    List<PaymentMode>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  PaymentModesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(PaymentMode.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<PaymentMode>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<PaymentMode>? get data => _data;

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

class PaymentMode {
  PaymentMode({
    String? id,
    String? name,
    String? description,
    String? showOnPdf,
    String? invoicesOnly,
    String? expensesOnly,
    String? selectedByDefault,
    String? active,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _showOnPdf = showOnPdf;
    _invoicesOnly = invoicesOnly;
    _expensesOnly = expensesOnly;
    _selectedByDefault = selectedByDefault;
    _active = active;
  }

  PaymentMode.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _showOnPdf = json['show_on_pdf'];
    _invoicesOnly = json['invoices_only'];
    _expensesOnly = json['expenses_only'];
    _selectedByDefault = json['selected_by_default'];
    _active = json['active'];
  }

  String? _id;
  String? _name;
  String? _description;
  String? _showOnPdf;
  String? _invoicesOnly;
  String? _expensesOnly;
  String? _selectedByDefault;
  String? _active;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get showOnPdf => _showOnPdf;
  String? get invoicesOnly => _invoicesOnly;
  String? get expensesOnly => _expensesOnly;
  String? get selectedByDefault => _selectedByDefault;
  String? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['show_on_pdf'] = _showOnPdf;
    map['invoices_only'] = _invoicesOnly;
    map['expenses_only'] = _expensesOnly;
    map['selected_by_default'] = _selectedByDefault;
    map['active'] = _active;
    return map;
  }
}
