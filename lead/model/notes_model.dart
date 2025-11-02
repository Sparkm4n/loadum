class NotesModel {
  NotesModel({
    bool? status,
    String? message,
    List<Note>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  NotesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Note.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Note>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Note>? get data => _data;

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

class Note {
  Note({
    String? id,
    String? description,
    String? dateContacted,
    String? dateAdded,
    String? addedFrom,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? active,
    String? profileImage,
  }) {
    _id = id;
    _description = description;
    _dateContacted = dateContacted;
    _dateAdded = dateAdded;
    _addedFrom = addedFrom;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _active = active;
    _profileImage = profileImage;
  }
  Note.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _dateContacted = json['date_contacted'];
    _dateAdded = json['dateadded'];
    _addedFrom = json['addedfrom'];
    _userId = json['userid'];
    _firstName = json['firstname'];
    _lastName = json['lastname'];
    _email = json['email'];
    _phoneNumber = json['phonenumber'];
    _active = json['active'];
    _profileImage = json['profile_image'];
  }

  String? _id;
  String? _description;
  String? _dateContacted;
  String? _dateAdded;
  String? _addedFrom;
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _active;
  String? _profileImage;

  String? get id => _id;
  String? get description => _description;
  String? get dateContacted => _dateContacted;
  String? get dateAdded => _dateAdded;
  String? get addedFrom => _addedFrom;
  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get active => _active;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['date_contacted'] = _dateContacted;
    map['dateadded'] = _dateAdded;
    map['addedfrom'] = _addedFrom;
    map['userid'] = _userId;
    map['firstname'] = _firstName;
    map['lastname'] = _lastName;
    map['email'] = _email;
    map['phonenumber'] = _phoneNumber;
    map['active'] = _active;
    map['profile_image'] = _profileImage;
    return map;
  }
}
