class ResponseModel {
  final bool _status;
  final String _message;
  final String _responseJson;
  ResponseModel(this._status, this._message, this._responseJson);

  bool get status => _status;
  String get message => _message;
  String get responseJson => _responseJson;
}

class StatusModel {
  StatusModel({
    bool? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  StatusModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'].toString();
  }
  bool? _status;
  String? _message;

  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}
