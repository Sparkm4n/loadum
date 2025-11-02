class TasksModel {
  TasksModel({
    List<DataField>? overview,
    List<Task>? data,
  }) {
    _status = status;
    _message = message;
    _overview = overview;
    _data = data;
  }

  TasksModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['overview'] != null) {
      _overview = [];
      json['overview'].forEach((v) {
        _overview?.add(DataField.fromJson(v));
      });
    }
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Task.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<DataField>? _overview;
  List<Task>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<DataField>? get overview => _overview;
  List<Task>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_overview != null) {
      map['overview'] = _overview?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Task {
  Task({
    String? id,
    String? name,
    String? description,
    String? priority,
    String? dateAdded,
    String? startDate,
    String? dueDate,
    String? dateFinished,
    String? addedFrom,
    String? isAddedFromContact,
    String? status,
    String? recurringType,
    String? repeatEvery,
    String? recurring,
    String? isRecurringFrom,
    String? cycles,
    String? totalCycles,
    String? customRecurring,
    String? lastRecurringDate,
    String? relId,
    String? relType,
    String? isPublic,
    String? billable,
    String? billed,
    String? invoiceId,
    String? hourlyRate,
    String? milestone,
    String? kanbanOrder,
    String? milestoneOrder,
    String? visibleToClient,
    String? deadlineNotified,
    List<Comments>? comments,
    //String? followers,
    //String? followersIds,
    //String? timesheets,
    //String? checklistItems,
    String? milestoneName,
    List<Attachments>? attachments,
    ProjectData? projectData,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _priority = priority;
    _dateAdded = dateAdded;
    _startDate = startDate;
    _dueDate = dueDate;
    _dateFinished = dateFinished;
    _addedFrom = addedFrom;
    _isAddedFromContact = isAddedFromContact;
    _status = status;
    _recurringType = recurringType;
    _repeatEvery = repeatEvery;
    _recurring = recurring;
    _isRecurringFrom = isRecurringFrom;
    _cycles = cycles;
    _totalCycles = totalCycles;
    _customRecurring = customRecurring;
    _lastRecurringDate = lastRecurringDate;
    _relId = relId;
    _relType = relType;
    _isPublic = isPublic;
    _billable = billable;
    _billed = billed;
    _invoiceId = invoiceId;
    _hourlyRate = hourlyRate;
    _milestone = milestone;
    _kanbanOrder = kanbanOrder;
    _milestoneOrder = milestoneOrder;
    _visibleToClient = visibleToClient;
    _deadlineNotified = deadlineNotified;
    _comments = comments;
    //_followers = followers;
    //_followersIds = followersIds;
    //_timesheets = timesheets;
    //_checklistItems = checklistItems;
    _milestoneName = milestoneName;
    _attachments = attachments;
    _projectData = projectData;
  }
  Task.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _priority = json['priority'];
    _dateAdded = json['dateadded'];
    _startDate = json['startdate'];
    _dueDate = json['duedate'];
    _dateFinished = json['datefinished'];
    _addedFrom = json['addedfrom'];
    _isAddedFromContact = json['is_added_from_contact'];
    _status = json['status'];
    _recurringType = json['recurring_type'];
    _repeatEvery = json['repeat_every'];
    _recurring = json['recurring'];
    _isRecurringFrom = json['is_recurring_from'];
    _cycles = json['cycles'];
    _totalCycles = json['total_cycles'];
    _customRecurring = json['custom_recurring'];
    _lastRecurringDate = json['last_recurring_date'];
    _relId = json['rel_id'];
    _relType = json['rel_type'];
    _isPublic = json['is_public'];
    _billable = json['billable'];
    _billed = json['billed'];
    _invoiceId = json['invoice_id'];
    _hourlyRate = json['hourly_rate'];
    _milestone = json['milestone'];
    _kanbanOrder = json['kanban_order'];
    _milestoneOrder = json['milestone_order'];
    _visibleToClient = json['visible_to_client'];
    _deadlineNotified = json['deadline_notified'];
    if (json['comments'] != null) {
      _comments = [];
      json['comments'].forEach((v) {
        _comments?.add(Comments.fromJson(v));
      });
    }
    //_followers = json['followers'];
    //_followersIds = json['followers_ids'];
    //_timesheets = json['timesheets'];
    //_checklistItems = json['checklist_items'];
    _milestoneName = json['milestone_name'];
    if (json['attachments'] != null) {
      _attachments = [];
      json['attachments'].forEach((v) {
        _attachments?.add(Attachments.fromJson(v));
      });
    }
    if (json['project_data'] != null) {
      _projectData = ProjectData.fromJson(json['project_data']);
    }
  }

  String? _id;
  String? _name;
  String? _description;
  String? _priority;
  String? _dateAdded;
  String? _startDate;
  String? _dueDate;
  String? _dateFinished;
  String? _addedFrom;
  String? _isAddedFromContact;
  String? _status;
  String? _recurringType;
  String? _repeatEvery;
  String? _recurring;
  String? _isRecurringFrom;
  String? _cycles;
  String? _totalCycles;
  String? _customRecurring;
  String? _lastRecurringDate;
  String? _relId;
  String? _relType;
  String? _isPublic;
  String? _billable;
  String? _billed;
  String? _invoiceId;
  String? _hourlyRate;
  String? _milestone;
  String? _kanbanOrder;
  String? _milestoneOrder;
  String? _visibleToClient;
  String? _deadlineNotified;
  List<Comments>? _comments;
  //String? _followers;
  //String? _followersIds;
  //String? _timesheets;
  //String? _checklistItems;
  String? _milestoneName;
  List<Attachments>? _attachments;
  ProjectData? _projectData;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get priority => _priority;
  String? get dateAdded => _dateAdded;
  String? get startDate => _startDate;
  String? get dueDate => _dueDate;
  String? get dateFinished => _dateFinished;
  String? get addedFrom => _addedFrom;
  String? get isAddedFromContact => _isAddedFromContact;
  String? get status => _status;
  String? get recurringType => _recurringType;
  String? get repeatEvery => _repeatEvery;
  String? get recurring => _recurring;
  String? get isRecurringFrom => _isRecurringFrom;
  String? get cycles => _cycles;
  String? get totalCycles => _totalCycles;
  String? get customRecurring => _customRecurring;
  String? get lastRecurringDate => _lastRecurringDate;
  String? get relId => _relId;
  String? get relType => _relType;
  String? get isPublic => _isPublic;
  String? get billable => _billable;
  String? get billed => _billed;
  String? get invoiceId => _invoiceId;
  String? get hourlyRate => _hourlyRate;
  String? get milestone => _milestone;
  String? get kanbanOrder => _kanbanOrder;
  String? get milestoneOrder => _milestoneOrder;
  String? get visibleToClient => _visibleToClient;
  String? get deadlineNotified => _deadlineNotified;
  List<Comments>? get comments => _comments;
  //String? get followers => _followers;
  //String? get followersIds => _followersIds;
  //String? get timesheets => _timesheets;
  //String? get checklistItems => _checklistItems;
  String? get milestoneName => _milestoneName;
  List<Attachments>? get attachments => _attachments;
  ProjectData? get projectData => _projectData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['priority'] = _priority;
    map['dateadded'] = _dateAdded;
    map['startdate'] = _startDate;
    map['duedate'] = _dueDate;
    map['datefinished'] = _dateFinished;
    map['addedfrom'] = _addedFrom;
    map['is_added_from_contact'] = _isAddedFromContact;
    map['status'] = _status;
    map['recurring_type'] = _recurringType;
    map['repeat_every'] = _repeatEvery;
    map['recurring'] = _recurring;
    map['is_recurring_from'] = _isRecurringFrom;
    map['cycles'] = _cycles;
    map['total_cycles'] = _totalCycles;
    map['custom_recurring'] = _customRecurring;
    map['last_recurring_date'] = _lastRecurringDate;
    map['rel_id'] = _relId;
    map['rel_type'] = _relType;
    map['is_public'] = _isPublic;
    map['billable'] = _billable;
    map['billed'] = _billed;
    map['invoice_id'] = _invoiceId;
    map['hourly_rate'] = _hourlyRate;
    map['milestone'] = _milestone;
    map['kanban_order'] = _kanbanOrder;
    map['milestone_order'] = _milestoneOrder;
    map['visible_to_client'] = _visibleToClient;
    map['deadline_notified'] = _deadlineNotified;
    if (_comments != null) {
      map['comments'] = _comments?.map((v) => v.toJson()).toList();
    }
    //map['followers'] = _followers;
    //map['followers_ids'] = _followersIds;
    //map['timesheets'] = _timesheets;
    //map['checklist_items'] = _checklistItems;
    map['milestone_name'] = _milestoneName;
    if (_attachments != null) {
      map['attachments'] = _attachments?.map((v) => v.toJson()).toList();
    }
    if (_projectData != null) {
      map['project_data'] = _projectData?.toJson();
    }
    return map;
  }
}

class Comments {
  Comments({
    String? id,
    String? content,
    String? contactId,
    String? staffId,
    String? dateAdded,
    String? firstName,
    String? lastName,
    String? fileId,
    String? staffFullName,
    List<Attachments>? attachments,
  }) {
    _id = id;
    _content = content;
    _contactId = contactId;
    _staffId = staffId;
    _dateAdded = dateAdded;
    _firstName = firstName;
    _lastName = lastName;
    _fileId = fileId;
    _staffFullName = staffFullName;
    _attachments = attachments;
  }

  Comments.fromJson(dynamic json) {
    _id = json['id'];
    _content = json['content'];
    _contactId = json['contact_id'];
    _staffId = json['staffid'];
    _dateAdded = json['dateadded'];
    _firstName = json['firstname'];
    _lastName = json['lastname'];
    _fileId = json['file_id'];
    _staffFullName = json['staff_full_name'];
    if (json['attachments'] != null) {
      _attachments = [];
      json['attachments'].forEach((v) {
        _attachments?.add(Attachments.fromJson(v));
      });
    }
  }
  String? _id;
  String? _content;
  String? _contactId;
  String? _staffId;
  String? _dateAdded;
  String? _firstName;
  String? _lastName;
  String? _fileId;
  String? _staffFullName;
  List<Attachments>? _attachments;

  String? get id => _id;
  String? get content => _content;
  String? get contactId => _contactId;
  String? get staffId => _staffId;
  String? get dateAdded => _dateAdded;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fileId => _fileId;
  String? get staffFullName => _staffFullName;
  List<Attachments>? get attachments => _attachments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['content'] = _content;
    map['contact_id'] = _contactId;
    map['staffid'] = _staffId;
    map['dateadded'] = _dateAdded;
    map['firstname'] = _firstName;
    map['lastname'] = _lastName;
    map['file_id'] = _fileId;
    map['staff_full_name'] = _staffFullName;
    if (_attachments != null) {
      map['attachments'] = _attachments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Attachments {
  Attachments({
    String? id,
    String? relId,
    String? relType,
    String? fileName,
    String? fileType,
    String? visibleToCustomer,
    String? attachmentKey,
    String? external,
    String? externalLink,
    String? thumbnailLink,
    String? staffId,
    String? contactId,
    String? taskCommentId,
    String? dateAdded,
  }) {
    _id = id;
    _relId = relId;
    _relType = relType;
    _fileName = fileName;
    _fileType = fileType;
    _visibleToCustomer = visibleToCustomer;
    _attachmentKey = attachmentKey;
    _external = external;
    _externalLink = externalLink;
    _thumbnailLink = thumbnailLink;
    _staffId = staffId;
    _contactId = contactId;
    _taskCommentId = taskCommentId;
    _dateAdded = dateAdded;
  }

  Attachments.fromJson(dynamic json) {
    _id = json['id'];
    _relId = json['rel_id'];
    _relType = json['rel_type'];
    _fileName = json['file_name'];
    _fileType = json['filetype'];
    _visibleToCustomer = json['visible_to_customer'];
    _attachmentKey = json['attachment_key'];
    _external = json['external'];
    _externalLink = json['external_link'];
    _thumbnailLink = json['thumbnail_link'];
    _staffId = json['staffid'];
    _contactId = json['contact_id'];
    _taskCommentId = json['task_comment_id'];
    _dateAdded = json['dateadded'];
  }

  String? _id;
  String? _relId;
  String? _relType;
  String? _fileName;
  String? _fileType;
  String? _visibleToCustomer;
  String? _attachmentKey;
  String? _external;
  String? _externalLink;
  String? _thumbnailLink;
  String? _staffId;
  String? _contactId;
  String? _taskCommentId;
  String? _dateAdded;

  String? get id => _id;
  String? get relId => _relId;
  String? get relType => _relType;
  String? get fileName => _fileName;
  String? get fileType => _fileType;
  String? get visibleToCustomer => _visibleToCustomer;
  String? get attachmentKey => _attachmentKey;
  String? get external => _external;
  String? get externalLink => _externalLink;
  String? get thumbnailLink => _thumbnailLink;
  String? get staffId => _staffId;
  String? get contactId => _contactId;
  String? get taskCommentId => _taskCommentId;
  String? get dateAdded => _dateAdded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['rel_id'] = _relId;
    map['rel_type'] = _relType;
    map['file_name'] = _fileName;
    map['filetype'] = _fileType;
    map['visible_to_customer'] = _visibleToCustomer;
    map['attachment_key'] = _attachmentKey;
    map['external'] = _external;
    map['external_link'] = _externalLink;
    map['thumbnail_link'] = _thumbnailLink;
    map['staffid'] = _staffId;
    map['contact_id'] = _contactId;
    map['task_comment_id'] = _taskCommentId;
    map['dateadded'] = _dateAdded;
    return map;
  }
}

class ProjectData {
  ProjectData({
    String? id,
    String? name,
    String? description,
    String? status,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _status = status;
  }

  ProjectData.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _status = json['status'];
  }

  String? _id;
  String? _name;
  String? _description;
  String? _status;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['status'] = _status;
    return map;
  }
}

class DataField {
  DataField({
    String? status,
    String? total,
    String? percent,
  }) {
    _status = status;
    _total = total;
    _percent = percent;
  }

  DataField.fromJson(dynamic json) {
    _status = json['status'];
    _total = json['total'];
    _percent = json['percent'];
  }

  String? _status;
  String? _total;
  String? _percent;

  String? get status => _status;
  String? get total => _total;
  String? get percent => _percent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['total'] = _total;
    map['percent'] = _percent;
    return map;
  }
}
