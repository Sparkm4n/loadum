class ProfileModel {
  ProfileModel({
    bool? status,
    String? message,
    Staff? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  ProfileModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Staff.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Staff? _data;

  bool? get status => _status;
  String? get message => _message;
  Staff? get data => _data;

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

class Staff {
  Staff({
    String? staffId,
    String? email,
    String? firstName,
    String? lastName,
    String? facebook,
    String? linkedin,
    String? phoneNumber,
    String? skype,
    String? dateCreated,
    String? profileImage,
    String? admin,
    String? role,
    String? active,
    String? defaultLanguage,
    String? direction,
    String? mediaPathSlug,
    String? isNotStaff,
    String? hourlyRate,
  }) {
    _staffId = staffId;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _facebook = facebook;
    _linkedin = linkedin;
    _phoneNumber = phoneNumber;
    _skype = skype;
    _dateCreated = dateCreated;
    _profileImage = profileImage;
    _admin = admin;
    _role = role;
    _active = active;
    _defaultLanguage = defaultLanguage;
    _direction = direction;
    _mediaPathSlug = mediaPathSlug;
    _isNotStaff = isNotStaff;
    _hourlyRate = hourlyRate;
  }

  Staff.fromJson(dynamic json) {
    _staffId = json['staffid'];
    _email = json['email'];
    _firstName = json['firstname'];
    _lastName = json['lastname'];
    _facebook = json['facebook'];
    _linkedin = json['linkedin'];
    _phoneNumber = json['phonenumber'];
    _skype = json['skype'];
    _dateCreated = json['datecreated'];
    _profileImage = json['profile_image'];
    _admin = json['admin'];
    _role = json['role'];
    _active = json['active'];
    _defaultLanguage = json['default_language'];
    _direction = json['direction'];
    _mediaPathSlug = json['media_path_slug'];
    _isNotStaff = json['is_not_staff'];
    _hourlyRate = json['hourly_rate'];
  }
  String? _staffId;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _facebook;
  String? _linkedin;
  String? _phoneNumber;
  String? _skype;
  String? _dateCreated;
  String? _profileImage;
  String? _admin;
  String? _role;
  String? _active;
  String? _defaultLanguage;
  String? _direction;
  String? _mediaPathSlug;
  String? _isNotStaff;
  String? _hourlyRate;

  String? get staffId => _staffId;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get facebook => _facebook;
  String? get linkedin => _linkedin;
  String? get phoneNumber => _phoneNumber;
  String? get skype => _skype;
  String? get dateCreated => _dateCreated;
  String? get profileImage => _profileImage;
  String? get admin => _admin;
  String? get role => _role;
  String? get active => _active;
  String? get defaultLanguage => _defaultLanguage;
  String? get direction => _direction;
  String? get mediaPathSlug => _mediaPathSlug;
  String? get isNotStaff => _isNotStaff;
  String? get hourlyRate => _hourlyRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['staffId'] = _staffId;
    map['email'] = _email;
    map['firstname'] = _firstName;
    map['lastname'] = _lastName;
    map['facebook'] = _facebook;
    map['linkedin'] = _linkedin;
    map['phonenumber'] = _phoneNumber;
    map['skype'] = _skype;
    map['datecreated'] = _dateCreated;
    map['profile_image'] = _profileImage;
    map['admin'] = _admin;
    map['role'] = _role;
    map['active'] = _active;
    map['default_language'] = _defaultLanguage;
    map['direction'] = _direction;
    map['media_path_slug'] = _mediaPathSlug;
    map['is_not_staff'] = _isNotStaff;
    map['hourly_rate'] = _hourlyRate;
    return map;
  }
}
