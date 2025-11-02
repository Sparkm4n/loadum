class PrivacyResponseModel {
  PrivacyResponseModel({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  PrivacyResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
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
    String? slug,
    String? articleId,
    String? articleGroup,
    String? subject,
    String? description,
    String? activeArticle,
    String? activeGroup,
    String? groupName,
    String? staffArticle,
  }) {
    _slug = slug;
    _articleId = articleId;
    _articleGroup = articleGroup;
    _subject = subject;
    _description = description;
    _activeArticle = activeArticle;
    _activeGroup = activeGroup;
    _groupName = groupName;
    _staffArticle = staffArticle;
  }

  Data.fromJson(dynamic json) {
    _slug = json['slug'];
    _articleId = json['article_id'];
    _articleGroup = json['article_group'];
    _subject = json['subject'];
    _description = json['description'];
    _activeArticle = json['active_article'];
    _activeGroup = json['active_group'];
    _groupName = json['group_name'];
  }
  String? _slug;
  String? _articleId;
  String? _articleGroup;
  String? _subject;
  String? _description;
  String? _activeArticle;
  String? _activeGroup;
  String? _groupName;
  String? _staffArticle;

  String? get slug => _slug;
  String? get articleId => _articleId;
  String? get articleGroup => _articleGroup;
  String? get subject => _subject;
  String? get description => _description;
  String? get activeArticle => _activeArticle;
  String? get activeGroup => _activeGroup;
  String? get groupName => _groupName;
  String? get staffArticle => _staffArticle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['slug'] = _slug;
    map['articleid'] = _articleId;
    map['articlegroup'] = _articleGroup;
    map['subject'] = _subject;
    map['description'] = _description;
    map['active_article'] = _activeArticle;
    map['active_group'] = _activeGroup;
    map['group_name'] = _groupName;
    map['staff_article'] = _staffArticle;
    return map;
  }
}

class PolicyPages {
  PolicyPages({
    int? id,
    String? dataKeys,
    DataValues? dataValues,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _dataKeys = dataKeys;
    _dataValues = dataValues;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  PolicyPages.fromJson(dynamic json) {
    _id = json['id'];
    _dataKeys = json['data_keys'];
    _dataValues = json['data_values'] != null
        ? DataValues.fromJson(json['data_values'])
        : null;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _dataKeys;
  DataValues? _dataValues;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get dataKeys => _dataKeys;
  DataValues? get dataValues => _dataValues;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['data_keys'] = _dataKeys;
    if (_dataValues != null) {
      map['data_values'] = _dataValues?.toJson();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class DataValues {
  DataValues({String? title, String? details}) {
    _title = title;
    _details = details;
  }

  DataValues.fromJson(dynamic json) {
    _title = json['title'];
    _details = json['details'];
  }
  String? _title;
  String? _details;

  String? get title => _title;
  String? get details => _details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['details'] = _details;
    return map;
  }
}

class Message {
  Message({List<String>? success}) {
    _success = success;
  }

  Message.fromJson(dynamic json) {
    _success = json['success'] != null ? json['success'].cast<String>() : [];
  }
  List<String>? _success;

  List<String>? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    return map;
  }
}
