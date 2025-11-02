class CurrenciesModel {
  CurrenciesModel({
    bool? status,
    String? message,
    List<Currency>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  CurrenciesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Currency.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Currency>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Currency>? get data => _data;

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

class Currency {
  Currency({
    String? id,
    String? symbol,
    String? name,
    String? decimalSeparator,
    String? thousandSeparator,
    String? placement,
    String? isDefault,
  }) {
    _id = id;
    _symbol = symbol;
    _name = name;
    _decimalSeparator = decimalSeparator;
    _thousandSeparator = thousandSeparator;
    _placement = placement;
    _isDefault = isDefault;
  }

  Currency.fromJson(dynamic json) {
    _id = json['id'];
    _symbol = json['symbol'];
    _name = json['name'];
    _decimalSeparator = json['decimal_separator'];
    _thousandSeparator = json['thousand_separator'];
    _placement = json['placement'];
    _isDefault = json['isdefault'];
  }

  String? _id;
  String? _symbol;
  String? _name;
  String? _decimalSeparator;
  String? _thousandSeparator;
  String? _placement;
  String? _isDefault;

  String? get id => _id;
  String? get symbol => _symbol;
  String? get name => _name;
  String? get decimalSeparator => _decimalSeparator;
  String? get thousandSeparator => _thousandSeparator;
  String? get placement => _placement;
  String? get isDefault => _isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['symbol'] = _symbol;
    map['name'] = _name;
    map['decimal_separator'] = _decimalSeparator;
    map['thousand_separator'] = _thousandSeparator;
    map['placement'] = _placement;
    map['isdefault'] = _isDefault;
    return map;
  }
}
