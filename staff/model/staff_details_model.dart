class StaffDetailsModel {
  StaffDetailsModel({bool? status, String? message, StaffDetails? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  StaffDetailsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? StaffDetails.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  StaffDetails? _data;

  bool? get status => _status;
  String? get message => _message;
  StaffDetails? get data => _data;

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

class StaffDetails {
  StaffDetails({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? facebook,
    String? linkedin,
    String? phoneNumber,
    String? skype,
    String? dateCreated,
    String? profileImage,
    String? lastIp,
    String? lastLogin,
    String? lastActivity,
    String? lastPasswordChange,
    String? admin,
    String? role,
    String? active,
    String? defaultLanguage,
    String? direction,
    String? mediaPathSlug,
    String? isNotStaff,
    String? hourlyRate,
    String? emailSignature,
    String? fullName,
    List<Permission>? permissions,
  }) {
    _id = id;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _facebook = facebook;
    _linkedin = linkedin;
    _phoneNumber = phoneNumber;
    _skype = skype;
    _dateCreated = dateCreated;
    _profileImage = profileImage;
    _lastIp = lastIp;
    _lastLogin = lastLogin;
    _lastActivity = lastActivity;
    _lastPasswordChange = lastPasswordChange;
    _admin = admin;
    _role = role;
    _active = active;
    _defaultLanguage = defaultLanguage;
    _direction = direction;
    _mediaPathSlug = mediaPathSlug;
    _isNotStaff = isNotStaff;
    _hourlyRate = hourlyRate;
    _emailSignature = emailSignature;
    _fullName = fullName;
    _permissions = permissions;
  }
  StaffDetails.fromJson(dynamic json) {
    _id = json["staffid"];
    _email = json["email"];
    _firstName = json["firstname"];
    _lastName = json["lastname"];
    _facebook = json["facebook"];
    _linkedin = json["linkedin"];
    _phoneNumber = json["phonenumber"];
    _skype = json["skype"];
    _dateCreated = json["datecreated"];
    _profileImage = json["profile_image"];
    _lastIp = json["last_ip"];
    _lastLogin = json["last_login"];
    _lastActivity = json["last_activity"];
    _lastPasswordChange = json["last_password_change"];
    _admin = json["admin"];
    _role = json["role"];
    _active = json["active"];
    _defaultLanguage = json["default_language"];
    _direction = json["direction"];
    _mediaPathSlug = json["media_path_slug"];
    _isNotStaff = json["is_not_staff"];
    _hourlyRate = json["hourly_rate"];
    _emailSignature = json["email_signature"];
    _fullName = json["full_name"];
    if (json['permissions'] != null) {
      _permissions = [];
      json['permissions'].forEach((v) {
        _permissions?.add(Permission.fromJson(v));
      });
    }
  }

  String? _id;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _facebook;
  String? _linkedin;
  String? _phoneNumber;
  String? _skype;
  String? _dateCreated;
  String? _profileImage;
  String? _lastIp;
  String? _lastLogin;
  String? _lastActivity;
  String? _lastPasswordChange;
  String? _admin;
  String? _role;
  String? _active;
  String? _defaultLanguage;
  String? _direction;
  String? _mediaPathSlug;
  String? _isNotStaff;
  String? _hourlyRate;
  String? _emailSignature;
  String? _fullName;
  List<Permission>? _permissions;

  String? get id => _id;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get facebook => _facebook;
  String? get linkedin => _linkedin;
  String? get phoneNumber => _phoneNumber;
  String? get skype => _skype;
  String? get dateCreated => _dateCreated;
  String? get profileImage => _profileImage;
  String? get lastIp => _lastIp;
  String? get lastLogin => _lastLogin;
  String? get lastActivity => _lastActivity;
  String? get lastPasswordChange => _lastPasswordChange;
  String? get admin => _admin;
  String? get role => _role;
  String? get active => _active;
  String? get defaultLanguage => _defaultLanguage;
  String? get direction => _direction;
  String? get mediaPathSlug => _mediaPathSlug;
  String? get isNotStaff => _isNotStaff;
  String? get hourlyRate => _hourlyRate;
  String? get emailSignature => _emailSignature;
  String? get fullName => _fullName;
  List<Permission>? get permissions => _permissions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['staffid'] = _id;
    map['email'] = _email;
    map['firstname'] = _firstName;
    map['lastname'] = _lastName;
    map['facebook'] = _facebook;
    map['linkedin'] = _linkedin;
    map['phonenumber'] = _phoneNumber;
    map['skype'] = _skype;
    map['datecreated'] = _dateCreated;
    map['profile_image'] = _profileImage;
    map['last_ip'] = _lastIp;
    map['last_login'] = _lastLogin;
    map['last_activity'] = _lastActivity;
    map['last_password_change'] = _lastPasswordChange;
    map['admin'] = _admin;
    map['role'] = _role;
    map['active'] = _active;
    map['default_language'] = _defaultLanguage;
    map['direction'] = _direction;
    map['media_path_slug'] = _mediaPathSlug;
    map['is_not_staff'] = _isNotStaff;
    map['hourly_rate'] = _hourlyRate;
    map['email_signature'] = _emailSignature;
    map['full_name'] = _fullName;
    if (_permissions != null) {
      map['permissions'] = _permissions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Permission {
  Permission({String? staffId, String? feature, String? capability}) {
    staffId = staffId;
    feature = feature;
    capability = capability;
  }

  Permission.fromJson(dynamic json) {
    _staffId = json['staff_id'];
    _feature = json['feature'];
    _capability = json['capability'];
  }

  String? _staffId;
  String? _feature;
  String? _capability;

  String? get staffId => _staffId;
  String? get feature => _feature;
  String? get capability => _capability;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['staff_id'] = staffId;
    map['feature'] = feature;
    map['capability'] = capability;
    return map;
  }
}
