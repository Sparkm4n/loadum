class ItemDetailsModel {
  ItemDetailsModel({
    bool? status,
    String? message,
    ItemDetails? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  ItemDetailsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? ItemDetails.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  ItemDetails? _data;

  bool? get status => _status;
  String? get message => _message;
  ItemDetails? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class ItemDetails {
  ItemDetails({
    String? itemId,
    String? rate,
    String? taxRate,
    String? taxId,
    String? taxName,
    String? taxRateTwo,
    String? taxIdTwo,
    String? taxNameTwo,
    String? description,
    String? longDescription,
    String? groupId,
    String? groupName,
    String? unit,
  }) {
    _itemId = itemId;
    _rate = rate;
    _taxRate = taxRate;
    _taxId = taxId;
    _taxName = taxName;
    _taxRateTwo = taxRateTwo;
    _taxIdTwo = taxIdTwo;
    _taxNameTwo = taxNameTwo;
    _description = description;
    _longDescription = longDescription;
    _groupId = groupId;
    _groupName = groupName;
    _unit = unit;
  }
  ItemDetails.fromJson(dynamic json) {
    _itemId = json['itemid'];
    _rate = json['rate'];
    _taxRate = json['taxrate'];
    _taxId = json['taxid'];
    _taxName = json['taxname'];
    _taxRateTwo = json['taxrate_2'];
    _taxIdTwo = json['taxid_2'];
    _taxNameTwo = json['taxname_2'];
    _description = json['description'];
    _longDescription = json['long_description'];
    _groupId = json['group_id'];
    _groupName = json['group_name'];
    _unit = json['unit'];
  }

  String? _itemId;
  String? _rate;
  String? _taxRate;
  String? _taxId;
  String? _taxName;
  String? _taxRateTwo;
  String? _taxIdTwo;
  String? _taxNameTwo;
  String? _description;
  String? _longDescription;
  String? _groupId;
  String? _groupName;
  String? _unit;

  String? get itemId => _itemId;
  String? get rate => _rate;
  String? get taxRate => _taxRate;
  String? get taxId => _taxId;
  String? get taxName => _taxName;
  String? get taxRateTwo => _taxRateTwo;
  String? get taxIdTwo => _taxIdTwo;
  String? get taxNameTwo => _taxNameTwo;
  String? get description => _description;
  String? get longDescription => _longDescription;
  String? get groupId => _groupId;
  String? get groupName => _groupName;
  String? get unit => _unit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['itemid'] = _itemId;
    map['rate'] = _rate;
    map['taxrate'] = _taxRate;
    map['taxid'] = _taxId;
    map['taxname'] = _taxName;
    map['taxrate_2'] = _taxRateTwo;
    map['taxid_2'] = _taxIdTwo;
    map['taxname_2'] = _taxNameTwo;
    map['description'] = _description;
    map['long_description'] = _longDescription;
    map['group_id'] = _groupId;
    map['group_name'] = _groupName;
    map['unit'] = _unit;
    return map;
  }
}
