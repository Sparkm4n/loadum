import 'package:flutex_admin/features/lead/model/lead_model.dart';

class KanbanLeadModel {
  KanbanLeadModel({
    bool? status,
    String? message,
    List<KanbanLead>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  KanbanLeadModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(KanbanLead.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<KanbanLead>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<KanbanLead>? get data => _data;

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

class KanbanLead {
  KanbanLead({
    String? id,
    String? status,
    String? color,
    String? total,
    List<Lead>? leads,
  }) {
    _id = id;
    _status = status;
    _color = color;
    _total = total;
    _leads = leads;
  }
  KanbanLead.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _color = json['color'];
    _total = json['total'];
    if (json['leads'] != null) {
      _leads = [];
      json['leads'].forEach((v) {
        _leads?.add(Lead.fromJson(v));
      });
    }
  }

  String? _id;
  String? _status;
  String? _color;
  String? _total;
  List<Lead>? _leads;

  String? get id => _id;
  String? get status => _status;
  String? get color => _color;
  String? get total => _total;
  List<Lead>? get leads => _leads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['color'] = _color;
    map['total'] = _total;
    if (_leads != null) {
      map['leads'] = _leads?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
