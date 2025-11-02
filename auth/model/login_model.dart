class LoginModel {
  LoginModel({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  LoginModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'].toString();
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

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

class Data {
  Data({
    String? staffId,
    String? staffEmail,
    String? accessToken,
  }) {
    _staffId = staffId;
    _staffEmail = staffEmail;
    _accessToken = accessToken;
  }

  Data.fromJson(dynamic json) {
    _staffId = json['staff_id'];
    _staffEmail = json['staff_email'];
    _accessToken = json['token'];
  }
  String? _staffId;
  String? _staffEmail;
  String? _accessToken;

  String? get staffId => _staffId;
  String? get staffEmail => _staffEmail;
  String? get accessToken => _accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['staff_id'] = _staffId;
    map['staff_email'] = _staffEmail;
    map['token'] = _accessToken;
    return map;
  }
}
