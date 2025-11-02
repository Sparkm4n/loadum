class CustomersModel {
  CustomersModel({
    bool? status,
    String? message,
    CustomerSummery? overview,
    List<Customer>? data,
  }) {
    _status = status;
    _message = message;
    _overview = overview;
    _data = data;
  }

  CustomersModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _overview = json['overview'] != null
        ? CustomerSummery.fromJson(json['overview'])
        : null;
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Customer.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  CustomerSummery? _overview;
  List<Customer>? _data;

  bool? get status => _status;
  String? get message => _message;
  CustomerSummery? get overview => _overview;
  List<Customer>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_overview != null) {
      map['overview'] = _overview?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Customer {
  Customer({
    String? userId,
    String? company,
    String? vat,
    String? phoneNumber,
    String? country,
    String? city,
    String? zip,
    String? state,
    String? address,
    String? website,
    String? dateCreated,
    String? active,
    String? leadId,
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
    String? addedFrom,
  }) {
    _userId = userId;
    _company = company;
    _vat = vat;
    _phoneNumber = phoneNumber;
    _country = country;
    _city = city;
    _zip = zip;
    _state = state;
    _address = address;
    _website = website;
    _dateCreated = dateCreated;
    _active = active;
    _leadId = leadId;
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
    _addedFrom = addedFrom;
  }

  Customer.fromJson(dynamic json) {
    _userId = json['userid'];
    _company = json['company'];
    _vat = json['vat'];
    _phoneNumber = json['phonenumber'];
    _country = json['country'];
    _city = json['city'];
    _zip = json['zip'];
    _state = json['state'];
    _address = json['address'];
    _website = json['website'];
    _dateCreated = json['datecreated'];
    _active = json['active'];
    _leadId = json['leadid'];
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
    _addedFrom = json['addedfrom'];
  }

  String? _userId;
  String? _company;
  String? _vat;
  String? _phoneNumber;
  String? _country;
  String? _city;
  String? _zip;
  String? _state;
  String? _address;
  String? _website;
  String? _dateCreated;
  String? _active;
  String? _leadId;
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
  String? _addedFrom;

  String? get userId => _userId;
  String? get company => _company;
  String? get vat => _vat;
  String? get phoneNumber => _phoneNumber;
  String? get country => _country;
  String? get city => _city;
  String? get zip => _zip;
  String? get state => _state;
  String? get address => _address;
  String? get website => _website;
  String? get dateCreated => _dateCreated;
  String? get active => _active;
  String? get leadId => _leadId;
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
  String? get addedFrom => _addedFrom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userId;
    map['company'] = _company;
    map['vat'] = _vat;
    map['phonenumber'] = _phoneNumber;
    map['country'] = _country;
    map['city'] = _city;
    map['zip'] = _zip;
    map['state'] = _state;
    map['address'] = _address;
    map['website'] = _website;
    map['datecreated'] = _dateCreated;
    map['active'] = _active;
    map['leadid'] = _leadId;
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
    map['addedfrom'] = _addedFrom;
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
    _customersTotal = json['customers_total'].toString();
    _customersActive = json['customers_active'].toString();
    _customersInactive = json['customers_inactive'].toString();
    _contactsActive = json['contacts_active'].toString();
    _contactsInactive = json['contacts_inactive'].toString();
    _contactsLastLogin = json['contacts_last_login'].toString();
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
