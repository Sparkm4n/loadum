import 'package:flutex_admin/common/models/currencies_model.dart';

class SettingsModel {
  SettingsModel({bool? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SettingsModel.fromJson(dynamic json) {
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
    String? invoicePrefix,
    String? nextInvoiceNumber,
    String? invoiceDueAfter,
    String? invoiceNumberFormat,
    String? predefinedClientnoteInvoice,
    String? predefinedTermsInvoice,
    String? estimatePrefix,
    String? nextEstimateNumber,
    String? estimateDueAfter,
    String? estimateNumberFormat,
    String? predefinedClientnoteEstimate,
    String? predefinedTermsEstimate,
    String? proposalNumberPrefix,
    String? proposalDueAfter,
    Currency? currency,
  }) {
    _invoicePrefix = invoicePrefix;
    _nextInvoiceNumber = nextInvoiceNumber;
    _invoiceDueAfter = invoiceDueAfter;
    _invoiceNumberFormat = invoiceNumberFormat;
    _predefinedClientnoteInvoice = predefinedClientnoteInvoice;
    _predefinedTermsInvoice = predefinedTermsInvoice;
    _estimatePrefix = estimatePrefix;
    _nextEstimateNumber = nextEstimateNumber;
    _estimateDueAfter = estimateDueAfter;
    _estimateNumberFormat = estimateNumberFormat;
    _predefinedClientnoteEstimate = predefinedClientnoteEstimate;
    _predefinedTermsEstimate = predefinedTermsEstimate;
    _proposalNumberPrefix = proposalNumberPrefix;
    _proposalDueAfter = proposalDueAfter;
    _currency = currency;
  }

  Data.fromJson(dynamic json) {
    _invoicePrefix = json['invoice_prefix'];
    _nextInvoiceNumber = json['next_invoice_number'];
    _invoiceDueAfter = json['invoice_due_after'];
    _invoiceNumberFormat = json['invoice_number_format'];
    _predefinedClientnoteInvoice = json['predefined_clientnote_invoice'];
    _predefinedTermsInvoice = json['predefined_terms_invoice'];
    _estimatePrefix = json['estimate_prefix'];
    _nextEstimateNumber = json['next_estimate_number'];
    _estimateDueAfter = json['estimate_due_after'];
    _estimateNumberFormat = json['estimate_number_format'];
    _predefinedClientnoteEstimate = json['predefined_clientnote_estimate'];
    _predefinedTermsEstimate = json['predefined_terms_estimate'];
    _proposalNumberPrefix = json['proposal_number_prefix'];
    _proposalDueAfter = json['proposal_due_after'];
    _currency = json['base_currency'] != null
        ? Currency.fromJson(json['base_currency'])
        : null;
  }

  String? _invoicePrefix;
  String? _nextInvoiceNumber;
  String? _invoiceDueAfter;
  String? _invoiceNumberFormat;
  String? _predefinedClientnoteInvoice;
  String? _predefinedTermsInvoice;
  String? _estimatePrefix;
  String? _nextEstimateNumber;
  String? _estimateDueAfter;
  String? _estimateNumberFormat;
  String? _predefinedClientnoteEstimate;
  String? _predefinedTermsEstimate;
  String? _proposalNumberPrefix;
  String? _proposalDueAfter;
  Currency? _currency;

  String? get invoicePrefix => _invoicePrefix;
  String? get nextInvoiceNumber => _nextInvoiceNumber;
  String? get invoiceDueAfter => _invoiceDueAfter;
  String? get invoiceNumberFormat => _invoiceNumberFormat;
  String? get predefinedClientnoteInvoice => _predefinedClientnoteInvoice;
  String? get predefinedTermsInvoice => _predefinedTermsInvoice;
  String? get estimatePrefix => _estimatePrefix;
  String? get nextEstimateNumber => _nextEstimateNumber;
  String? get estimateDueAfter => _estimateDueAfter;
  String? get estimateNumberFormat => _estimateNumberFormat;
  String? get predefinedClientnoteEstimate => _predefinedClientnoteEstimate;
  String? get predefinedTermsEstimate => _predefinedTermsEstimate;
  String? get proposalNumberPrefix => _proposalNumberPrefix;
  String? get proposalDueAfter => _proposalDueAfter;
  Currency? get currency => _currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['invoice_prefix'] = _invoicePrefix;
    map['next_invoice_number'] = _nextInvoiceNumber;
    map['invoice_due_after'] = _invoiceDueAfter;
    map['invoice_number_format'] = _invoiceNumberFormat;
    map['predefined_clientnote_invoice'] = _predefinedClientnoteInvoice;
    map['predefined_terms_invoice'] = _predefinedTermsInvoice;
    map['estimate_prefix'] = _estimatePrefix;
    map['next_estimate_number'] = _nextEstimateNumber;
    map['estimate_due_after'] = _estimateDueAfter;
    map['estimate_number_format'] = _estimateNumberFormat;
    map['predefined_clientnote_estimate'] = _predefinedClientnoteEstimate;
    map['predefined_terms_estimate'] = _predefinedTermsEstimate;
    map['proposal_number_prefix'] = _proposalNumberPrefix;
    map['proposal_due_after'] = _proposalDueAfter;
    if (_currency != null) {
      map['base_currency'] = _currency?.toJson();
    }
    return map;
  }
}
