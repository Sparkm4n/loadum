class ExpenseModel {
  ExpenseModel({bool? status, String? message, List<Expense>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ExpenseModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Expense.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Expense>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Expense>? get data => _data;

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

class Expense {
  Expense({
    String? id,
    String? category,
    String? currency,
    String? amount,
    String? tax,
    String? tax2,
    String? referenceNo,
    String? note,
    String? expenseName,
    String? clientid,
    String? projectId,
    String? billable,
    String? invoiceid,
    String? paymentmode,
    String? date,
    String? recurringType,
    String? repeatEvery,
    String? recurring,
    String? cycles,
    String? totalCycles,
    String? customRecurring,
    String? lastRecurringDate,
    String? createInvoiceBillable,
    String? sendInvoiceToCustomer,
    String? recurringFrom,
    String? dateadded,
    String? addedfrom,
    String? userid,
    String? company,
    String? vat,
    String? phonenumber,
    String? country,
    String? city,
    String? zip,
    String? state,
    String? address,
    String? website,
    String? datecreated,
    String? active,
    String? leadid,
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
    String? longitude,
    String? latitude,
    String? defaultLanguage,
    String? defaultCurrency,
    String? showPrimaryContact,
    String? stripeId,
    String? registrationConfirmed,
    String? name,
    String? description,
    String? showOnPdf,
    String? invoicesOnly,
    String? expensesOnly,
    String? selectedByDefault,
    String? taxRate,
    String? categoryName,
    String? paymentModeName,
    String? taxName,
    String? taxName2,
    String? taxrate2,
    String? expenseid,
  }) {
    _id = id;
    _category = category;
    _currency = currency;
    _amount = amount;
    _tax = tax;
    _tax2 = tax2;
    _referenceNo = referenceNo;
    _note = note;
    _expenseName = expenseName;
    _clientid = clientid;
    _projectId = projectId;
    _billable = billable;
    _invoiceid = invoiceid;
    _paymentmode = paymentmode;
    _date = date;
    _recurringType = recurringType;
    _repeatEvery = repeatEvery;
    _recurring = recurring;
    _cycles = cycles;
    _totalCycles = totalCycles;
    _customRecurring = customRecurring;
    _lastRecurringDate = lastRecurringDate;
    _createInvoiceBillable = createInvoiceBillable;
    _sendInvoiceToCustomer = sendInvoiceToCustomer;
    _recurringFrom = recurringFrom;
    _dateadded = dateadded;
    _addedfrom = addedfrom;
    _userid = userid;
    _company = company;
    _vat = vat;
    _phonenumber = phonenumber;
    _country = country;
    _city = city;
    _zip = zip;
    _state = state;
    _address = address;
    _website = website;
    _datecreated = datecreated;
    _active = active;
    _leadid = leadid;
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
    _longitude = longitude;
    _latitude = latitude;
    _defaultLanguage = defaultLanguage;
    _defaultCurrency = defaultCurrency;
    _showPrimaryContact = showPrimaryContact;
    _stripeId = stripeId;
    _registrationConfirmed = registrationConfirmed;
    _name = name;
    _description = description;
    _showOnPdf = showOnPdf;
    _invoicesOnly = invoicesOnly;
    _expensesOnly = expensesOnly;
    _selectedByDefault = selectedByDefault;
    _taxRate = taxRate;
    _categoryName = categoryName;
    _paymentModeName = paymentModeName;
    _taxName = taxName;
    _taxName2 = taxName2;
    _taxrate2 = taxrate2;
    _expenseid = expenseid;
  }
  Expense.fromJson(dynamic json) {
    _id = json['id'];
    _category = json['category'];
    _currency = json['currency'];
    _amount = json['amount'];
    _tax = json['tax'];
    _tax2 = json['tax2'];
    _referenceNo = json['reference_no'];
    _note = json['note'];
    _expenseName = json['expense_name'];
    _clientid = json['clientid'];
    _projectId = json['project_id'];
    _billable = json['billable'];
    _invoiceid = json['invoiceid'];
    _paymentmode = json['paymentmode'];
    _date = json['date'];
    _recurringType = json['recurring_type'];
    _repeatEvery = json['repeat_every'];
    _recurring = json['recurring'];
    _cycles = json['cycles'];
    _totalCycles = json['total_cycles'];
    _customRecurring = json['custom_recurring'];
    _lastRecurringDate = json['last_recurring_date'];
    _createInvoiceBillable = json['create_invoice_billable'];
    _sendInvoiceToCustomer = json['send_invoice_to_customer'];
    _recurringFrom = json['recurring_from'];
    _dateadded = json['dateadded'];
    _addedfrom = json['addedfrom'];
    _userid = json['userid'];
    _company = json['company'];
    _vat = json['vat'];
    _phonenumber = json['phonenumber'];
    _country = json['country'];
    _city = json['city'];
    _zip = json['zip'];
    _state = json['state'];
    _address = json['address'];
    _website = json['website'];
    _datecreated = json['datecreated'];
    _active = json['active'];
    _leadid = json['leadid'];
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
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _defaultLanguage = json['default_language'];
    _defaultCurrency = json['default_currency'];
    _showPrimaryContact = json['show_primary_contact'];
    _stripeId = json['stripe_id'];
    _registrationConfirmed = json['registration_confirmed'];
    _name = json['name'];
    _description = json['description'];
    _showOnPdf = json['show_on_pdf'];
    _invoicesOnly = json['invoices_only'];
    _expensesOnly = json['expenses_only'];
    _selectedByDefault = json['selected_by_default'];
    _taxRate = json['tax_rate'];
    _categoryName = json['category_name'];
    _paymentModeName = json['payment_mode_name'];
    _taxName = json['tax_name'];
    _taxName2 = json['tax_name2'];
    _taxrate2 = json['taxrate2'];
    _expenseid = json['expenseid'];
  }

  String? _id;
  String? _category;
  String? _currency;
  String? _amount;
  String? _tax;
  String? _tax2;
  String? _referenceNo;
  String? _note;
  String? _expenseName;
  String? _clientid;
  String? _projectId;
  String? _billable;
  String? _invoiceid;
  String? _paymentmode;
  String? _date;
  String? _recurringType;
  String? _repeatEvery;
  String? _recurring;
  String? _cycles;
  String? _totalCycles;
  String? _customRecurring;
  String? _lastRecurringDate;
  String? _createInvoiceBillable;
  String? _sendInvoiceToCustomer;
  String? _recurringFrom;
  String? _dateadded;
  String? _addedfrom;
  String? _userid;
  String? _company;
  String? _vat;
  String? _phonenumber;
  String? _country;
  String? _city;
  String? _zip;
  String? _state;
  String? _address;
  String? _website;
  String? _datecreated;
  String? _active;
  String? _leadid;
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
  String? _longitude;
  String? _latitude;
  String? _defaultLanguage;
  String? _defaultCurrency;
  String? _showPrimaryContact;
  String? _stripeId;
  String? _registrationConfirmed;
  String? _name;
  String? _description;
  String? _showOnPdf;
  String? _invoicesOnly;
  String? _expensesOnly;
  String? _selectedByDefault;
  String? _taxRate;
  String? _categoryName;
  String? _paymentModeName;
  String? _taxName;
  String? _taxName2;
  String? _taxrate2;
  String? _expenseid;

  String? get id => _id;
  String? get category => _category;
  String? get currency => _currency;
  String? get amount => _amount;
  String? get tax => _tax;
  String? get tax2 => _tax2;
  String? get referenceNo => _referenceNo;
  String? get note => _note;
  String? get expenseName => _expenseName;
  String? get clientid => _clientid;
  String? get projectId => _projectId;
  String? get billable => _billable;
  String? get invoiceid => _invoiceid;
  String? get paymentmode => _paymentmode;
  String? get date => _date;
  String? get recurringType => _recurringType;
  String? get repeatEvery => _repeatEvery;
  String? get recurring => _recurring;
  String? get cycles => _cycles;
  String? get totalCycles => _totalCycles;
  String? get customRecurring => _customRecurring;
  String? get lastRecurringDate => _lastRecurringDate;
  String? get createInvoiceBillable => _createInvoiceBillable;
  String? get sendInvoiceToCustomer => _sendInvoiceToCustomer;
  String? get recurringFrom => _recurringFrom;
  String? get dateadded => _dateadded;
  String? get addedfrom => _addedfrom;
  String? get userid => _userid;
  String? get company => _company;
  String? get vat => _vat;
  String? get phonenumber => _phonenumber;
  String? get country => _country;
  String? get city => _city;
  String? get zip => _zip;
  String? get state => _state;
  String? get address => _address;
  String? get website => _website;
  String? get datecreated => _datecreated;
  String? get active => _active;
  String? get leadid => _leadid;
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
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get defaultLanguage => _defaultLanguage;
  String? get defaultCurrency => _defaultCurrency;
  String? get showPrimaryContact => _showPrimaryContact;
  String? get stripeId => _stripeId;
  String? get registrationConfirmed => _registrationConfirmed;
  String? get name => _name;
  String? get description => _description;
  String? get showOnPdf => _showOnPdf;
  String? get invoicesOnly => _invoicesOnly;
  String? get expensesOnly => _expensesOnly;
  String? get selectedByDefault => _selectedByDefault;
  String? get taxRate => _taxRate;
  String? get categoryName => _categoryName;
  String? get paymentModeName => _paymentModeName;
  String? get taxName => _taxName;
  String? get taxName2 => _taxName2;
  String? get taxrate2 => _taxrate2;
  String? get expenseid => _expenseid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category'] = _category;
    map['currency'] = _currency;
    map['amount'] = _amount;
    map['tax'] = _tax;
    map['tax2'] = _tax2;
    map['reference_no'] = _referenceNo;
    map['note'] = _note;
    map['expense_name'] = _expenseName;
    map['clientid'] = _clientid;
    map['project_id'] = _projectId;
    map['billable'] = _billable;
    map['invoiceid'] = _invoiceid;
    map['paymentmode'] = _paymentmode;
    map['date'] = _date;
    map['recurring_type'] = _recurringType;
    map['repeat_every'] = _repeatEvery;
    map['recurring'] = _recurring;
    map['cycles'] = _cycles;
    map['total_cycles'] = _totalCycles;
    map['custom_recurring'] = _customRecurring;
    map['last_recurring_date'] = _lastRecurringDate;
    map['create_invoice_billable'] = _createInvoiceBillable;
    map['send_invoice_to_customer'] = _sendInvoiceToCustomer;
    map['recurring_from'] = _recurringFrom;
    map['dateadded'] = _dateadded;
    map['addedfrom'] = _addedfrom;
    map['userid'] = _userid;
    map['company'] = _company;
    map['vat'] = _vat;
    map['phonenumber'] = _phonenumber;
    map['country'] = _country;
    map['city'] = _city;
    map['zip'] = _zip;
    map['state'] = _state;
    map['address'] = _address;
    map['website'] = _website;
    map['datecreated'] = _datecreated;
    map['active'] = _active;
    map['leadid'] = _leadid;
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
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    map['default_language'] = _defaultLanguage;
    map['default_currency'] = _defaultCurrency;
    map['show_primary_contact'] = _showPrimaryContact;
    map['stripe_id'] = _stripeId;
    map['registration_confirmed'] = _registrationConfirmed;
    map['name'] = _name;
    map['description'] = _description;
    map['show_on_pdf'] = _showOnPdf;
    map['invoices_only'] = _invoicesOnly;
    map['expenses_only'] = _expensesOnly;
    map['selected_by_default'] = _selectedByDefault;
    map['tax_rate'] = _taxRate;
    map['category_name'] = _categoryName;
    map['payment_mode_name'] = _paymentModeName;
    map['tax_name'] = _taxName;
    map['tax_name2'] = _taxName2;
    map['taxrate2'] = _taxrate2;
    map['expenseid'] = _expenseid;
    return map;
  }
}
