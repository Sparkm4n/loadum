class ProjectDetailsModel {
  ProjectDetailsModel({bool? status, String? message, ProjectDetails? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ProjectDetailsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? ProjectDetails.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  ProjectDetails? _data;

  bool? get status => _status;
  String? get message => _message;
  ProjectDetails? get data => _data;

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

class ProjectDetails {
  ProjectDetails({
    String? id,
    String? name,
    String? description,
    String? status,
    String? clientId,
    String? billingType,
    String? startDate,
    String? deadline,
    String? projectCreated,
    String? dateFinished,
    String? progress,
    String? progressFromTasks,
    String? projectCost,
    String? projectRatePerHour,
    String? estimatedHours,
    String? addedFrom,
    String? contactNotification,
    String? notifyContacts,
    List<Vault>? sharedVaultEntries,
    Settings? settings,
    ClientData? clientData,
    List<ProjectMembers>? projectMembers,
    String? totalLoggedTime,
    String? statusName,
    String? addedFromName,
    String? totalExpenses,
    String? billableExpenses,
    String? billedExpenses,
    String? unbilledExpenses,
    String? totalTasks,
    String? openTasks,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _status = status;
    _clientId = clientId;
    _billingType = billingType;
    _startDate = startDate;
    _deadline = deadline;
    _projectCreated = projectCreated;
    _dateFinished = dateFinished;
    _progress = progress;
    _progressFromTasks = progressFromTasks;
    _projectCost = projectCost;
    _projectRatePerHour = projectRatePerHour;
    _estimatedHours = estimatedHours;
    _addedFrom = addedFrom;
    _contactNotification = contactNotification;
    _notifyContacts = notifyContacts;
    _sharedVaultEntries = sharedVaultEntries;
    _settings = settings;
    _clientData = clientData;
    _projectMembers = projectMembers;
    _totalLoggedTime = totalLoggedTime;
    _statusName = statusName;
    _addedFromName = addedFromName;
    _totalExpenses = totalExpenses;
    _billableExpenses = billableExpenses;
    _billedExpenses = billedExpenses;
    _unbilledExpenses = unbilledExpenses;
    _totalTasks = totalTasks;
    _openTasks = openTasks;
  }
  ProjectDetails.fromJson(dynamic json) {
    _id = json['id'];
    _name = json["name"];
    _description = json["description"];
    _status = json["status"];
    _clientId = json["clientid"];
    _billingType = json["billing_type"];
    _startDate = json["start_date"];
    _deadline = json["deadline"];
    _projectCreated = json["project_created"];
    _dateFinished = json["date_finished"];
    _progress = json["progress"];
    _progressFromTasks = json["progress_from_tasks"];
    _projectCost = json["project_cost"];
    _projectRatePerHour = json["project_rate_per_hour"];
    _estimatedHours = json["estimated_hours"];
    _addedFrom = json["addedfrom"];
    _contactNotification = json["contact_notification"];
    _notifyContacts = json["notify_contacts"];
    if (json['shared_vault_entries'] != null) {
      _sharedVaultEntries = [];
      json['shared_vault_entries'].forEach((v) {
        _sharedVaultEntries?.add(Vault.fromJson(v));
      });
    }
    _settings = Settings.fromJson(json['settings']);
    _clientData = ClientData.fromJson(json['client_data']);
    if (json['project_members'] != null) {
      _projectMembers = [];
      json['project_members'].forEach((v) {
        _projectMembers?.add(ProjectMembers.fromJson(v));
      });
    }
    _totalLoggedTime = json["total_logged_time"];
    _statusName = json["status_name"];
    _addedFromName = json["addedfrom_name"];
    _totalExpenses = json["total_expenses"];
    _billableExpenses = json["billable_expenses"];
    _billedExpenses = json["billed_expenses"];
    _unbilledExpenses = json["unbilled_expenses"];
    _totalTasks = json["total_tasks"].toString();
    _openTasks = json["open_tasks"].toString();
  }

  String? _id;
  String? _name;
  String? _description;
  String? _status;
  String? _clientId;
  String? _billingType;
  String? _startDate;
  String? _deadline;
  String? _projectCreated;
  String? _dateFinished;
  String? _progress;
  String? _progressFromTasks;
  String? _projectCost;
  String? _projectRatePerHour;
  String? _estimatedHours;
  String? _addedFrom;
  String? _contactNotification;
  String? _notifyContacts;
  List<Vault>? _sharedVaultEntries;
  Settings? _settings;
  ClientData? _clientData;
  List<ProjectMembers>? _projectMembers;
  String? _totalLoggedTime;
  String? _statusName;
  String? _addedFromName;
  String? _totalExpenses;
  String? _billableExpenses;
  String? _billedExpenses;
  String? _unbilledExpenses;
  String? _totalTasks;
  String? _openTasks;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get status => _status;
  String? get clientId => _clientId;
  String? get billingType => _billingType;
  String? get startDate => _startDate;
  String? get deadline => _deadline;
  String? get projectCreated => _projectCreated;
  String? get dateFinished => _dateFinished;
  String? get progress => _progress;
  String? get progressFromTasks => _progressFromTasks;
  String? get projectCost => _projectCost;
  String? get projectRatePerHour => _projectRatePerHour;
  String? get estimatedHours => _estimatedHours;
  String? get addedFrom => _addedFrom;
  String? get contactNotification => _contactNotification;
  String? get notifyContacts => _notifyContacts;
  List<Vault>? get sharedVaultEntries => _sharedVaultEntries;
  Settings? get settings => _settings;
  ClientData? get clientData => _clientData;
  List<ProjectMembers>? get projectMembers => _projectMembers;
  String? get totalLoggedTime => _totalLoggedTime;
  String? get statusName => _statusName;
  String? get addedFromName => _addedFromName;
  String? get totalExpenses => _totalExpenses;
  String? get billableExpenses => _billableExpenses;
  String? get billedExpenses => _billedExpenses;
  String? get unbilledExpenses => _unbilledExpenses;
  String? get totalTasks => _totalTasks;
  String? get openTasks => _openTasks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['status'] = _status;
    map['clientid'] = _clientId;
    map['billing_type'] = _billingType;
    map['start_date'] = _startDate;
    map['deadline'] = _deadline;
    map['project_created'] = _projectCreated;
    map['date_finished'] = _dateFinished;
    map['progress'] = _progress;
    map['progress_from_tasks'] = _progressFromTasks;
    map['project_cost'] = _projectCost;
    map['project_rate_per_hour'] = _projectRatePerHour;
    map['estimated_hours'] = _estimatedHours;
    map['addedfrom'] = _addedFrom;
    map['contact_notification'] = _contactNotification;
    map['notify_contacts'] = _notifyContacts;
    if (_sharedVaultEntries != null) {
      map['shared_vault_entries'] = _sharedVaultEntries
          ?.map((v) => v.toJson())
          .toList();
    }
    if (_settings != null) {
      map['settings'] = _settings?.toJson();
    }
    if (_clientData != null) {
      map['client_data'] = _clientData?.toJson();
    }
    if (_projectMembers != null) {
      map['project_members'] = _projectMembers?.map((v) => v.toJson()).toList();
    }
    map['total_logged_time'] = _totalLoggedTime;
    map['status_name'] = _statusName;
    map['addedfrom_name'] = _addedFromName;
    map['total_expenses'] = _totalExpenses;
    map['billable_expenses'] = _billableExpenses;
    map['billed_expenses'] = _billedExpenses;
    map['unbilled_expenses'] = _unbilledExpenses;
    map['total_tasks'] = _totalTasks;
    map['open_tasks'] = _openTasks;
    return map;
  }
}

class ClientData {
  ClientData({
    String? userid,
    String? company,
    String? phoneNumber,
    String? country,
    String? city,
    String? zip,
    String? state,
    String? address,
    String? website,
    String? dateCreated,
    String? active,
    String? billingStreet,
    String? billingCity,
    String? billingState,
    String? billingZip,
    String? billingCountry,
    String? shippingStreet,
    String? shippingCity,
    String? shippingState,
    String? shippingZip,
    String? shippingCountry,
    String? defaultLanguage,
    String? defaultCurrency,
    String? showPrimaryContact,
    String? registrationConfirmed,
    String? addedFrom,
  }) {
    _userid = userid;
    _company = company;
    _phoneNumber = phoneNumber;
    _country = country;
    _city = city;
    _zip = zip;
    _state = state;
    _address = address;
    _website = website;
    _dateCreated = dateCreated;
    _active = active;
    _billingStreet = billingStreet;
    _billingCity = billingCity;
    _billingState = billingState;
    _billingZip = billingZip;
    _billingCountry = billingCountry;
    _shippingStreet = shippingStreet;
    _shippingCity = shippingCity;
    _shippingState = shippingState;
    _shippingZip = shippingZip;
    _shippingCountry = shippingCountry;
    _defaultLanguage = defaultLanguage;
    _defaultCurrency = defaultCurrency;
    _showPrimaryContact = showPrimaryContact;
    _registrationConfirmed = registrationConfirmed;
    _addedFrom = addedFrom;
  }

  ClientData.fromJson(dynamic json) {
    _userid = json['userid'];
    _company = json['company'];
    _phoneNumber = json['phonenumber'];
    _country = json['country'];
    _city = json['city'];
    _zip = json['zip'];
    _state = json['state'];
    _address = json['address'];
    _website = json['website'];
    _dateCreated = json['datecreated'];
    _active = json['active'];
    _billingStreet = json['billing_street'];
    _billingCity = json['billing_city'];
    _billingState = json['billing_state'];
    _billingZip = json['billing_zip'];
    _billingCountry = json['billing_country'];
    _shippingStreet = json['shipping_street'];
    _shippingCity = json['shipping_city'];
    _shippingState = json['shipping_state'];
    _shippingZip = json['shipping_zip'];
    _shippingCountry = json['shipping_country'];
    _defaultLanguage = json['default_language'];
    _defaultCurrency = json['default_currency'];
    _showPrimaryContact = json['show_primary_contact'];
    _registrationConfirmed = json['registration_confirmed'];
    _addedFrom = json['addedfrom'];
  }
  String? _userid;
  String? _company;
  String? _phoneNumber;
  String? _country;
  String? _city;
  String? _zip;
  String? _state;
  String? _address;
  String? _website;
  String? _dateCreated;
  String? _active;
  String? _billingStreet;
  String? _billingCity;
  String? _billingState;
  String? _billingZip;
  String? _billingCountry;
  String? _shippingStreet;
  String? _shippingCity;
  String? _shippingState;
  String? _shippingZip;
  String? _shippingCountry;
  String? _defaultLanguage;
  String? _defaultCurrency;
  String? _showPrimaryContact;
  String? _registrationConfirmed;
  String? _addedFrom;

  String? get userid => _userid;
  String? get company => _company;
  String? get phoneNumber => _phoneNumber;
  String? get country => _country;
  String? get city => _city;
  String? get zip => _zip;
  String? get state => _state;
  String? get address => _address;
  String? get website => _website;
  String? get dateCreated => _dateCreated;
  String? get active => _active;
  String? get billingStreet => _billingStreet;
  String? get billingCity => _billingCity;
  String? get billingState => _billingState;
  String? get billingZip => _billingZip;
  String? get billingCountry => _billingCountry;
  String? get shippingStreet => _shippingStreet;
  String? get shippingCity => _shippingCity;
  String? get shippingState => _shippingState;
  String? get shippingZip => _shippingZip;
  String? get shippingCountry => _shippingCountry;
  String? get defaultLanguage => _defaultLanguage;
  String? get defaultCurrency => _defaultCurrency;
  String? get showPrimaryContact => _showPrimaryContact;
  String? get registrationConfirmed => _registrationConfirmed;
  String? get addedFrom => _addedFrom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userid;
    map['company'] = _company;
    map['phonenumber'] = _phoneNumber;
    map['country'] = _country;
    map['city'] = _city;
    map['zip'] = _zip;
    map['state'] = _state;
    map['address'] = _address;
    map['website'] = _website;
    map['datecreated'] = _dateCreated;
    map['active'] = _active;
    map['billing_street'] = _billingStreet;
    map['billing_city'] = _billingCity;
    map['billing_state'] = _billingState;
    map['billing_zip'] = _billingZip;
    map['billing_country'] = _billingCountry;
    map['shipping_street'] = _shippingStreet;
    map['shipping_city'] = _shippingCity;
    map['shipping_state'] = _shippingState;
    map['shipping_zip'] = _shippingZip;
    map['shipping_country'] = _shippingCountry;
    map['default_language'] = _defaultLanguage;
    map['default_currency'] = _defaultCurrency;
    map['show_primary_contact'] = _showPrimaryContact;
    map['registration_confirmed'] = _registrationConfirmed;
    map['addedfrom'] = _addedFrom;
    return map;
  }
}

class Settings {
  Settings({
    AvailableFeatures? availableFeatures,
    String? viewTasks,
    String? createTasks,
    String? editTasks,
    String? commentOnTasks,
    String? viewTaskComments,
    String? viewTaskAttachments,
    String? viewTaskChecklistItems,
    String? uploadOnTasks,
    String? viewTaskTotalLoggedTime,
    String? viewFinanceOverview,
    String? uploadFiles,
    String? openDiscussions,
    String? viewMilestones,
    String? viewGantt,
    String? viewTimesheets,
    String? viewActivityLog,
    String? viewTeamMembers,
    String? hideTasksOnMainTasksTable,
  }) {
    _availableFeatures = availableFeatures;
    _viewTasks = viewTasks;
    _createTasks = createTasks;
    _editTasks = editTasks;
    _commentOnTasks = commentOnTasks;
    _viewTaskComments = viewTaskComments;
    _viewTaskAttachments = viewTaskAttachments;
    _viewTaskChecklistItems = viewTaskChecklistItems;
    _uploadOnTasks = uploadOnTasks;
    _viewTaskTotalLoggedTime = viewTaskTotalLoggedTime;
    _viewFinanceOverview = viewFinanceOverview;
    _uploadFiles = uploadFiles;
    _openDiscussions = openDiscussions;
    _viewMilestones = viewMilestones;
    _viewGantt = viewGantt;
    _viewTimesheets = viewTimesheets;
    _viewActivityLog = viewActivityLog;
    _viewTeamMembers = viewTeamMembers;
    _hideTasksOnMainTasksTable = hideTasksOnMainTasksTable;
  }

  Settings.fromJson(dynamic json) {
    _availableFeatures = json['available_features'] != null
        ? AvailableFeatures.fromJson(json['available_features'])
        : null;
    _viewTasks = json['view_tasks'];
    _createTasks = json['create_tasks'];
    _editTasks = json['edit_tasks'];
    _commentOnTasks = json['comment_on_tasks'];
    _viewTaskComments = json['view_task_comments'];
    _viewTaskAttachments = json['view_task_attachments'];
    _viewTaskChecklistItems = json['view_task_checklist_items'];
    _uploadOnTasks = json['upload_on_tasks'];
    _viewTaskTotalLoggedTime = json['view_task_total_logged_time'];
    _viewFinanceOverview = json['view_finance_overview'];
    _uploadFiles = json['upload_files'];
    _openDiscussions = json['open_discussions'];
    _viewMilestones = json['view_milestones'];
    _viewGantt = json['view_gantt'];
    _viewTimesheets = json['view_timesheets'];
    _viewActivityLog = json['view_activity_log'];
    _viewTeamMembers = json['view_team_members'];
    _hideTasksOnMainTasksTable = json['hide_tasks_on_main_tasks_table'];
  }
  AvailableFeatures? _availableFeatures;
  String? _viewTasks;
  String? _createTasks;
  String? _editTasks;
  String? _commentOnTasks;
  String? _viewTaskComments;
  String? _viewTaskAttachments;
  String? _viewTaskChecklistItems;
  String? _uploadOnTasks;
  String? _viewTaskTotalLoggedTime;
  String? _viewFinanceOverview;
  String? _uploadFiles;
  String? _openDiscussions;
  String? _viewMilestones;
  String? _viewGantt;
  String? _viewTimesheets;
  String? _viewActivityLog;
  String? _viewTeamMembers;
  String? _hideTasksOnMainTasksTable;

  AvailableFeatures? get availableFeatures => _availableFeatures;
  String? get viewTasks => _viewTasks;
  String? get createTasks => _createTasks;
  String? get editTasks => _editTasks;
  String? get commentOnTasks => _commentOnTasks;
  String? get viewTaskComments => _viewTaskComments;
  String? get viewTaskAttachments => _viewTaskAttachments;
  String? get viewTaskChecklistItems => _viewTaskChecklistItems;
  String? get uploadOnTasks => _uploadOnTasks;
  String? get viewTaskTotalLoggedTime => _viewTaskTotalLoggedTime;
  String? get viewFinanceOverview => _viewFinanceOverview;
  String? get uploadFiles => _uploadFiles;
  String? get openDiscussions => _openDiscussions;
  String? get viewMilestones => _viewMilestones;
  String? get viewGantt => _viewGantt;
  String? get viewTimesheets => _viewTimesheets;
  String? get viewActivityLog => _viewActivityLog;
  String? get viewTeamMembers => _viewTeamMembers;
  String? get hideTasksOnMainTasksTable => _hideTasksOnMainTasksTable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_availableFeatures != null) {
      map['available_features'] = _availableFeatures?.toJson();
    }
    map['view_tasks'] = _viewTasks;
    map['create_tasks'] = _createTasks;
    map['edit_tasks'] = _editTasks;
    map['comment_on_tasks'] = _commentOnTasks;
    map['view_task_comments'] = _viewTaskComments;
    map['view_task_attachments'] = _viewTaskAttachments;
    map['view_task_checklist_items'] = _viewTaskChecklistItems;
    map['upload_on_tasks'] = _uploadOnTasks;
    map['view_task_total_logged_time'] = _viewTaskTotalLoggedTime;
    map['view_finance_overview'] = _viewFinanceOverview;
    map['upload_files'] = _uploadFiles;
    map['open_discussions'] = _openDiscussions;
    map['view_milestones'] = _viewMilestones;
    map['view_gantt'] = _viewGantt;
    map['view_timesheets'] = _viewTimesheets;
    map['view_activity_log'] = _viewActivityLog;
    map['view_team_members'] = _viewTeamMembers;
    map['hide_tasks_on_main_tasks_table'] = _hideTasksOnMainTasksTable;
    return map;
  }
}

class AvailableFeatures {
  AvailableFeatures({
    String? projectOverview,
    String? projectTasks,
    String? projectTimesheets,
    String? projectMilestones,
    String? projectFiles,
    String? projectDiscussions,
    String? projectGantt,
    String? projectTickets,
    String? projectContracts,
    String? projectProposals,
    String? projectEstimates,
    String? projectInvoices,
    String? projectSubscriptions,
    String? projectExpenses,
    String? projectCreditNotes,
    String? projectNotes,
    String? projectActivity,
  }) {
    _viewTasks = viewTasks;
    _projectOverview = projectOverview;
    _projectTasks = projectTasks;
    _projectTimesheets = projectTimesheets;
    _projectMilestones = projectMilestones;
    _projectFiles = projectFiles;
    _projectDiscussions = projectDiscussions;
    _projectGantt = projectGantt;
    _projectTickets = projectTickets;
    _projectContracts = projectContracts;
    _projectProposals = projectProposals;
    _projectEstimates = projectEstimates;
    _projectInvoices = projectInvoices;
    _projectSubscriptions = projectSubscriptions;
    _projectExpenses = projectExpenses;
    _projectCreditNotes = projectCreditNotes;
    _projectNotes = projectNotes;
    _projectActivity = projectActivity;
  }

  AvailableFeatures.fromJson(dynamic json) {
    _projectOverview = json['project_overview'].toString();
    _projectTasks = json['project_tasks'].toString();
    _projectTimesheets = json['project_timesheets'].toString();
    _projectMilestones = json['project_milestones'].toString();
    _projectFiles = json['project_files'].toString();
    _projectDiscussions = json['project_discussions'].toString();
    _projectGantt = json['project_gantt'].toString();
    _projectTickets = json['project_tickets'].toString();
    _projectContracts = json['project_contracts'].toString();
    _projectProposals = json['project_proposals'].toString();
    _projectEstimates = json['project_estimates'].toString();
    _projectInvoices = json['project_invoices'].toString();
    _projectSubscriptions = json['project_subscriptions'].toString();
    _projectExpenses = json['project_expenses'].toString();
    _projectCreditNotes = json['project_credit_notes'].toString();
    _projectNotes = json['project_notes'].toString();
    _projectActivity = json['project_activity'].toString();
  }
  String? _viewTasks;
  String? _projectOverview;
  String? _projectTasks;
  String? _projectTimesheets;
  String? _projectMilestones;
  String? _projectFiles;
  String? _projectDiscussions;
  String? _projectGantt;
  String? _projectTickets;
  String? _projectContracts;
  String? _projectProposals;
  String? _projectEstimates;
  String? _projectInvoices;
  String? _projectSubscriptions;
  String? _projectExpenses;
  String? _projectCreditNotes;
  String? _projectNotes;
  String? _projectActivity;

  String? get viewTasks => _viewTasks;
  String? get projectOverview => _projectOverview;
  String? get projectTasks => _projectTasks;
  String? get projectTimesheets => _projectTimesheets;
  String? get projectMilestones => _projectMilestones;
  String? get projectFiles => _projectFiles;
  String? get projectDiscussions => _projectDiscussions;
  String? get projectGantt => _projectGantt;
  String? get projectTickets => _projectTickets;
  String? get projectContracts => _projectContracts;
  String? get projectProposals => _projectProposals;
  String? get projectEstimates => _projectEstimates;
  String? get projectInvoices => _projectInvoices;
  String? get projectSubscriptions => _projectSubscriptions;
  String? get projectExpenses => _projectExpenses;
  String? get projectCreditNotes => _projectCreditNotes;
  String? get projectNotes => _projectNotes;
  String? get projectActivity => _projectActivity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['project_overview'] = _projectOverview;
    map['project_tasks'] = _projectTasks;
    map['project_timesheets'] = _projectTimesheets;
    map['project_milestones'] = _projectMilestones;
    map['project_files'] = _projectFiles;
    map['project_discussions'] = _projectDiscussions;
    map['project_gantt'] = _projectGantt;
    map['project_tickets'] = _projectTickets;
    map['project_contracts'] = _projectContracts;
    map['project_proposals'] = _projectProposals;
    map['project_estimates'] = _projectEstimates;
    map['project_invoices'] = _projectInvoices;
    map['project_subscriptions'] = _projectSubscriptions;
    map['project_expenses'] = _projectExpenses;
    map['project_credit_notes'] = _projectCreditNotes;
    map['project_notes'] = _projectNotes;
    map['project_activity'] = _projectActivity;
    return map;
  }
}

class Vault {
  Vault({
    String? id,
    String? customerId,
    String? serverAddress,
    String? port,
    String? username,
    String? password,
    String? description,
    String? creator,
    String? creatorName,
    String? visibility,
    String? shareInProjects,
    String? lastUpdated,
    String? lastUpdatedFrom,
    String? dateCreated,
  }) {
    _id = id;
    _customerId = customerId;
    _serverAddress = serverAddress;
    _port = port;
    _username = username;
    _password = password;
    _description = description;
    _creator = creator;
    _creatorName = creatorName;
    _visibility = visibility;
    _shareInProjects = shareInProjects;
    _lastUpdated = lastUpdated;
    _lastUpdatedFrom = lastUpdatedFrom;
    _dateCreated = dateCreated;
  }

  Vault.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _serverAddress = json['server_address'];
    _port = json['port'];
    _username = json['username'];
    _password = json['password'];
    _description = json['description'];
    _creator = json['creator'];
    _creatorName = json['creator_name'];
    _visibility = json['visibility'];
    _shareInProjects = json['share_in_projects'];
    _lastUpdated = json['last_updated'];
    _lastUpdatedFrom = json['last_updated_from'];
    _dateCreated = json['date_created'];
  }

  String? _id;
  String? _customerId;
  String? _serverAddress;
  String? _port;
  String? _username;
  String? _password;
  String? _description;
  String? _creator;
  String? _creatorName;
  String? _visibility;
  String? _shareInProjects;
  String? _lastUpdated;
  String? _lastUpdatedFrom;
  String? _dateCreated;

  String? get id => _id;
  String? get customerId => _customerId;
  String? get serverAddress => _serverAddress;
  String? get port => _port;
  String? get username => _username;
  String? get password => _password;
  String? get description => _description;
  String? get creator => _creator;
  String? get creatorName => _creatorName;
  String? get visibility => _visibility;
  String? get shareInProjects => _shareInProjects;
  String? get lastUpdated => _lastUpdated;
  String? get lastUpdatedFrom => _lastUpdatedFrom;
  String? get dateCreated => _dateCreated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['server_address'] = _serverAddress;
    map['port'] = _port;
    map['username'] = _username;
    map['password'] = _password;
    map['description'] = _description;
    map['creator'] = _creator;
    map['creator_name'] = _creatorName;
    map['visibility'] = _visibility;
    map['share_in_projects'] = _shareInProjects;
    map['last_updated'] = _lastUpdated;
    map['last_updated_from'] = _lastUpdatedFrom;
    map['date_created'] = _dateCreated;
    return map;
  }
}

class ProjectMembers {
  ProjectMembers({String? staffId, String? staffName, String? email}) {
    _staffId = staffId;
    _staffName = staffName;
    _email = email;
  }

  ProjectMembers.fromJson(dynamic json) {
    _staffId = json['staff_id'];
    _staffName = json['staff_name'];
    _email = json['email'];
  }

  String? _staffId;
  String? _staffName;
  String? _email;

  String? get staffId => _staffId;
  String? get staffName => _staffName;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['staff_id'] = _staffId;
    map['staff_name'] = _staffName;
    map['email'] = _email;
    return map;
  }
}
