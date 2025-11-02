import 'package:flutex_admin/features/invoice/model/invoice_item_model.dart';

class InvoicePostModel {
  final String clientId;
  final String number;
  final String date;
  final String currency;
  final List<InvoiceItemModel> newItems;
  final String subtotal;
  final String total;
  final String billingStreet;
  final List<String> allowedPaymentModes;
  final String? billingCity;
  final String? billingState;
  final String? billingZip;
  final String? billingCountry;
  final String? includeShipping;
  final String? showShippingOnInvoice;
  final String? shippingStreet;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingZip;
  final String? shippingCountry;
  final String? duedate;
  final String? cancelOverdueReminders;
  final String? tags;
  final String? saleAgent;
  final String? recurring;
  final String? discountType;
  final String? repeatEveryCustom;
  final String? repeatTypeCustom;
  final String? cycles;
  final String? adminNote;
  final List<String>? removedItems;
  final String? clientNote;
  final String? terms;

  InvoicePostModel({
    required this.clientId,
    required this.number,
    required this.date,
    required this.currency,
    required this.newItems,
    required this.subtotal,
    required this.total,
    required this.billingStreet,
    required this.allowedPaymentModes,
    this.billingCity,
    this.billingState,
    this.billingZip,
    this.billingCountry,
    this.includeShipping,
    this.showShippingOnInvoice,
    this.shippingStreet,
    this.shippingCity,
    this.shippingState,
    this.shippingZip,
    this.shippingCountry,
    this.duedate,
    this.cancelOverdueReminders,
    this.tags,
    this.saleAgent,
    this.recurring,
    this.discountType,
    this.repeatEveryCustom,
    this.repeatTypeCustom,
    this.cycles,
    this.adminNote,
    this.removedItems,
    this.clientNote,
    this.terms,
  });
}
