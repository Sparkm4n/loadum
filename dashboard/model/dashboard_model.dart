class DashboardModel {
  DashboardModel({
    bool? status,
    String? message,
    Overview? overview,
    Data? data,
    Staff? staff,
    MenuItems? menuItems,
  }) {
    _status = status;
    _message = message;
    _overview = overview;
    _data = data;
    _staff = staff;
    _menuItems = menuItems;
  }

  DashboardModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _overview =
        json['overview'] != null ? Overview.fromJson(json['overview']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _staff = json['staff'] != null ? Staff.fromJson(json['staff']) : null;
    _menuItems = json['menu_items'] != null
        ? MenuItems.fromJson(json['menu_items'])
        : null;
  }
  bool? _status;
  String? _message;
  Overview? _overview;
  Data? _data;
  Staff? _staff;
  MenuItems? _menuItems;

  bool? get status => _status;
  String? get message => _message;
  Overview? get overview => _overview;
  Data? get data => _data;
  Staff? get staff => _staff;
  MenuItems? get menuItems => _menuItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_overview != null) {
      map['overview'] = _overview?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    if (_staff != null) {
      map['staff'] = _staff?.toJson();
    }
    if (_menuItems != null) {
      map['menu_items'] = _menuItems?.toJson();
    }
    return map;
  }
}

class Overview {
  Overview({
    String? perfexLogo,
    String? perfexLogoDark,
    String? totalInvoices,
    String? invoicesAwaitingPaymentTotal,
    String? invoicesAwaitingPaymentPercent,
    String? totalLeads,
    String? leadsConvertedTotal,
    String? leadsConvertedPercent,
    String? totalProjects,
    String? projectsInProgressTotal,
    String? inProgressProjectsPercent,
    String? totalTasks,
    String? notFinishedTasksTotal,
    String? notFinishedTasksPercent,
  }) {
    _perfexLogo = perfexLogo;
    _perfexLogoDark = perfexLogoDark;
    _totalInvoices = totalInvoices;
    _invoicesAwaitingPaymentTotal = invoicesAwaitingPaymentTotal;
    _invoicesAwaitingPaymentPercent = invoicesAwaitingPaymentPercent;
    _totalLeads = totalLeads;
    _leadsConvertedTotal = leadsConvertedTotal;
    _leadsConvertedPercent = leadsConvertedPercent;
    _totalProjects = totalProjects;
    _projectsInProgressTotal = projectsInProgressTotal;
    _inProgressProjectsPercent = inProgressProjectsPercent;
    _totalTasks = totalTasks;
    _notFinishedTasksTotal = notFinishedTasksTotal;
    _notFinishedTasksPercent = notFinishedTasksPercent;
  }

  Overview.fromJson(dynamic json) {
    _perfexLogo = json['perfex_logo'];
    _perfexLogoDark = json['perfex_logo_dark'];
    _totalInvoices = json['total_invoices'];
    _invoicesAwaitingPaymentTotal = json['invoices_awaiting_payment_total'];
    _invoicesAwaitingPaymentPercent = json['invoices_awaiting_payment_percent'];
    _totalLeads = json['total_leads'];
    _leadsConvertedTotal = json['leads_converted_total'];
    _leadsConvertedPercent = json['leads_converted_percent'];
    _totalProjects = json['total_projects'];
    _projectsInProgressTotal = json['projects_in_progress_total'];
    _inProgressProjectsPercent = json['projects_in_progress_percent'];
    _totalTasks = json['total_tasks'];
    _notFinishedTasksTotal = json['tasks_not_finished_total'];
    _notFinishedTasksPercent = json['tasks_not_finished_percent'];
  }
  String? _perfexLogo;
  String? _perfexLogoDark;
  String? _totalInvoices;
  String? _invoicesAwaitingPaymentTotal;
  String? _invoicesAwaitingPaymentPercent;
  String? _totalLeads;
  String? _leadsConvertedTotal;
  String? _leadsConvertedPercent;
  String? _totalProjects;
  String? _projectsInProgressTotal;
  String? _inProgressProjectsPercent;
  String? _totalTasks;
  String? _notFinishedTasksTotal;
  String? _notFinishedTasksPercent;

  String? get perfexLogo => _perfexLogo;
  String? get perfexLogoDark => _perfexLogoDark;
  String? get totalInvoices => _totalInvoices;
  String? get invoicesAwaitingPaymentTotal => _invoicesAwaitingPaymentTotal;
  String? get invoicesAwaitingPaymentPercent => _invoicesAwaitingPaymentPercent;
  String? get totalLeads => _totalLeads;
  String? get leadsConvertedTotal => _leadsConvertedTotal;
  String? get leadsConvertedPercent => _leadsConvertedPercent;
  String? get totalProjects => _totalProjects;
  String? get projectsInProgressTotal => _projectsInProgressTotal;
  String? get inProgressProjectsPercent => _inProgressProjectsPercent;
  String? get totalTasks => _totalTasks;
  String? get notFinishedTasksTotal => _notFinishedTasksTotal;
  String? get notFinishedTasksPercent => _notFinishedTasksPercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['perfex_logo'] = _perfexLogo;
    map['perfex_logo_dark'] = _perfexLogoDark;
    map['total_invoices'] = _totalInvoices;
    map['invoices_awaiting_payment_total'] = _invoicesAwaitingPaymentTotal;
    map['invoices_awaiting_payment_percent'] = _invoicesAwaitingPaymentPercent;
    map['total_leads'] = _totalLeads;
    map['leads_converted_total'] = _leadsConvertedTotal;
    map['leads_converted_percent'] = _leadsConvertedPercent;
    map['total_projects'] = _totalProjects;
    map['projects_in_progress_total'] = _projectsInProgressTotal;
    map['projects_in_progress_percent'] = _inProgressProjectsPercent;
    map['total_tasks'] = _totalTasks;
    map['tasks_not_finished_total'] = _notFinishedTasksTotal;
    map['tasks_not_finished_percent'] = _notFinishedTasksPercent;
    return map;
  }
}

class Data {
  Data({
    List<DataField>? invoices,
    List<DataField>? estimates,
    List<DataField>? proposals,
    List<DataField>? projects,
    List<DataField>? tasks,
    List<DataField>? leads,
    List<DataField>? tickets,
    CustomerSummery? customers,
  }) {
    _invoices = invoices;
    _estimates = estimates;
    _proposals = proposals;
    _projects = projects;
    _tasks = tasks;
    _leads = leads;
    _tickets = tickets;
    _customers = customers;
  }

  Data.fromJson(dynamic json) {
    if (json['invoices'] != null) {
      _invoices = [];
      json['invoices'].forEach((v) {
        _invoices?.add(DataField.fromJson(v));
      });
    }
    if (json['estimates'] != null) {
      _estimates = [];
      json['estimates'].forEach((v) {
        _estimates?.add(DataField.fromJson(v));
      });
    }
    if (json['proposals'] != null) {
      _proposals = [];
      json['proposals'].forEach((v) {
        _proposals?.add(DataField.fromJson(v));
      });
    }
    if (json['projects'] != null) {
      _projects = [];
      json['projects'].forEach((v) {
        _projects?.add(DataField.fromJson(v));
      });
    }
    if (json['tasks'] != null) {
      _tasks = [];
      json['tasks'].forEach((v) {
        _tasks?.add(DataField.fromJson(v));
      });
    }
    if (json['leads'] != null) {
      _leads = [];
      json['leads'].forEach((v) {
        _leads?.add(DataField.fromJson(v));
      });
    }
    if (json['tickets'] != null) {
      _tickets = [];
      json['tickets'].forEach((v) {
        _tickets?.add(DataField.fromJson(v));
      });
    }
    _customers = json['customers'] != null
        ? CustomerSummery.fromJson(json['customers'])
        : null;
  }

  List<DataField>? _invoices;
  List<DataField>? _estimates;
  List<DataField>? _proposals;
  List<DataField>? _projects;
  List<DataField>? _tasks;
  List<DataField>? _leads;
  List<DataField>? _tickets;
  CustomerSummery? _customers;

  List<DataField>? get invoices => _invoices;
  List<DataField>? get estimates => _estimates;
  List<DataField>? get proposals => _proposals;
  List<DataField>? get projects => _projects;
  List<DataField>? get tasks => _tasks;
  List<DataField>? get leads => _leads;
  List<DataField>? get tickets => _tickets;
  CustomerSummery? get customers => _customers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_invoices != null) {
      map['invoices'] = _invoices?.map((v) => v.toJson()).toList();
    }
    if (_estimates != null) {
      map['estimates'] = _estimates?.map((v) => v.toJson()).toList();
    }
    if (_proposals != null) {
      map['proposals'] = _proposals?.map((v) => v.toJson()).toList();
    }
    if (_projects != null) {
      map['projects'] = _projects?.map((v) => v.toJson()).toList();
    }
    if (_tasks != null) {
      map['tasks'] = _tasks?.map((v) => v.toJson()).toList();
    }
    if (_leads != null) {
      map['leads'] = _leads?.map((v) => v.toJson()).toList();
    }
    if (_tickets != null) {
      map['tickets'] = _tickets?.map((v) => v.toJson()).toList();
    }
    if (_customers != null) {
      map['customers'] = _customers?.toJson();
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
    String? phoneNumber,
    String? profileImage,
  }) {
    _staffId = staffId;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _phoneNumber = phoneNumber;
    _profileImage = profileImage;
  }

  Staff.fromJson(dynamic json) {
    _staffId = json['staffid'];
    _email = json['email'];
    _firstName = json['firstname'];
    _lastName = json['lastname'];
    _phoneNumber = json['phonenumber'];
    _profileImage = json['profile_image'];
  }
  String? _staffId;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _profileImage;

  String? get staffId => _staffId;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phoneNumber => _phoneNumber;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['staffId'] = _staffId;
    map['email'] = _email;
    map['firstname'] = _firstName;
    map['lastname'] = _lastName;
    map['phonenumber'] = _phoneNumber;
    map['profile_image'] = _profileImage;
    return map;
  }
}

class MenuItems {
  MenuItems({
    bool? customers,
    bool? proposals,
    bool? estimates,
    bool? invoices,
    bool? payments,
    bool? creditNotes,
    bool? items,
    bool? subscriptions,
    bool? expenses,
    bool? contracts,
    bool? projects,
    bool? tasks,
    bool? tickets,
    bool? leads,
    bool? staff,
  }) {
    _customers = customers;
    _proposals = proposals;
    _estimates = estimates;
    _invoices = invoices;
    _payments = payments;
    _creditNotes = creditNotes;
    _items = items;
    _subscriptions = subscriptions;
    _expenses = expenses;
    _contracts = contracts;
    _projects = projects;
    _tasks = tasks;
    _tickets = tickets;
    _leads = leads;
    _staff = staff;
  }

  MenuItems.fromJson(dynamic json) {
    _customers = json['customers'];
    _proposals = json['proposals'];
    _estimates = json['estimates'];
    _invoices = json['invoices'];
    _payments = json['payments'];
    _creditNotes = json['credit_notes'];
    _items = json['items'];
    _subscriptions = json['subscriptions'];
    _expenses = json['expenses'];
    _contracts = json['contracts'];
    _projects = json['projects'];
    _tasks = json['tasks'];
    _tickets = json['tickets'];
    _leads = json['leads'];
    _staff = json['staff'];
  }
  bool? _customers;
  bool? _proposals;
  bool? _estimates;
  bool? _invoices;
  bool? _payments;
  bool? _creditNotes;
  bool? _items;
  bool? _subscriptions;
  bool? _expenses;
  bool? _contracts;
  bool? _projects;
  bool? _tasks;
  bool? _tickets;
  bool? _leads;
  bool? _staff;

  bool? get customers => _customers;
  bool? get proposals => _proposals;
  bool? get estimates => _estimates;
  bool? get invoices => _invoices;
  bool? get payments => _payments;
  bool? get creditNotes => _creditNotes;
  bool? get items => _items;
  bool? get subscriptions => _subscriptions;
  bool? get expenses => _expenses;
  bool? get contracts => _contracts;
  bool? get projects => _projects;
  bool? get tasks => _tasks;
  bool? get tickets => _tickets;
  bool? get leads => _leads;
  bool? get staff => _staff;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customers'] = _customers;
    map['proposals'] = _proposals;
    map['estimates'] = _estimates;
    map['invoices'] = _invoices;
    map['payments'] = _payments;
    map['credit_notes'] = _creditNotes;
    map['items'] = _items;
    map['subscriptions'] = _subscriptions;
    map['expenses'] = _expenses;
    map['contracts'] = _contracts;
    map['projects'] = _projects;
    map['tasks'] = _tasks;
    map['tickets'] = _tickets;
    map['leads'] = _leads;
    map['staff'] = _staff;
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

class CustomerSummery {
  CustomerSummery({
    String? customersTotal,
    String? customersActive,
    String? customersInactive,
    String? contactsActive,
    String? contactsInactive,
    String? contactsLastLogin,
  }) {
    _customersTotal = customersTotal;
    _customersActive = customersActive;
    _customersInactive = customersInactive;
    _contactsActive = contactsActive;
    _contactsInactive = contactsInactive;
    _contactsLastLogin = contactsLastLogin;
  }

  CustomerSummery.fromJson(dynamic json) {
    _customersTotal = json['customers_total'];
    _customersActive = json['customers_active'];
    _customersInactive = json['customers_inactive'];
    _contactsActive = json['contacts_active'];
    _contactsInactive = json['contacts_inactive'];
    _contactsLastLogin = json['contacts_last_login'];
  }
  String? _userid;
  String? _customersTotal;
  String? _customersActive;
  String? _customersInactive;
  String? _contactsActive;
  String? _contactsInactive;
  String? _contactsLastLogin;

  String? get userid => _userid;
  String? get customersTotal => _customersTotal;
  String? get customersActive => _customersActive;
  String? get customersInactive => _customersInactive;
  String? get contactsActive => _contactsActive;
  String? get contactsInactive => _contactsInactive;
  String? get contactsLastLogin => _contactsLastLogin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userid;
    map['customers_total'] = _customersTotal;
    map['customers_active'] = _customersActive;
    map['customers_inactive'] = _customersInactive;
    map['contacts_active'] = _contactsActive;
    map['contacts_inactive'] = _contactsInactive;
    map['contacts_last_login'] = _contactsLastLogin;
    return map;
  }
}
