import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/taxes_model.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/currencies_model.dart';
import 'package:flutex_admin/common/models/payment_modes_model.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/common/models/settings_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_details_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_item_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_post_model.dart';
import 'package:flutex_admin/features/invoice/model/payment_post_model.dart';
import 'package:flutex_admin/features/invoice/repo/invoice_repo.dart';
import 'package:flutex_admin/features/item/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class InvoiceController extends GetxController {
  InvoiceRepo invoiceRepo;
  InvoiceController({required this.invoiceRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  InvoicesModel invoicesModel = InvoicesModel();
  InvoiceDetailsModel invoiceDetailsModel = InvoiceDetailsModel();
  SettingsModel settingsModel = SettingsModel();
  CustomersModel customersModel = CustomersModel();
  CurrenciesModel currenciesModel = CurrenciesModel();
  TaxesModel taxesModel = TaxesModel();
  PaymentModesModel paymentModesModel = PaymentModesModel();
  ItemsModel itemsModel = ItemsModel();
  List<InvoiceItemModel> invoiceItemList = [];
  List<String> removedItemsList = [];
  List<String> allowedPaymentModesList = [];

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadInvoices();
    isLoading = false;
    update();
  }

  Future<void> loadInvoices() async {
    ResponseModel responseModel = await invoiceRepo.getAllInvoices();
    invoicesModel = InvoicesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
    isLoading = false;
    update();
  }

  Future<void> loadInvoiceDetails(invoiceId) async {
    ResponseModel responseModel = await invoiceRepo.getInvoiceDetails(
      invoiceId,
    );
    invoiceDetailsModel = InvoiceDetailsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );

    isLoading = false;
    update();
  }

  Future<void> loadInvoiceCreateData() async {
    ResponseModel responseModel = await invoiceRepo.getSettingsData();
    settingsModel = SettingsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
    numberController.text = settingsModel.data?.nextInvoiceNumber ?? '';
    clientNoteController.text =
        settingsModel.data?.predefinedClientnoteInvoice ?? '';
    termsController.text = settingsModel.data?.predefinedTermsInvoice ?? '';
    isLoading = false;
    update();
  }

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await invoiceRepo.getAllCustomers();
    return customersModel = CustomersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<PaymentModesModel> loadPaymentModes() async {
    ResponseModel responseModel = await invoiceRepo.getPaymentModes();
    return paymentModesModel = PaymentModesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<TaxesModel> loadTaxes() async {
    ResponseModel responseModel = await invoiceRepo.getTaxes();
    return taxesModel = TaxesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<CurrenciesModel> loadCurrencies() async {
    ResponseModel responseModel = await invoiceRepo.getCurrencies();
    return currenciesModel = CurrenciesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<ItemsModel> loadItems() async {
    ResponseModel responseModel = await invoiceRepo.getItems();
    return itemsModel = ItemsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadInvoiceUpdateData(invoiceId) async {
    ResponseModel responseModel = await invoiceRepo.getInvoiceDetails(
      invoiceId,
    );
    if (responseModel.status) {
      invoiceDetailsModel = InvoiceDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      ResponseModel settingsResponseModel = await invoiceRepo.getSettingsData();
      settingsModel = SettingsModel.fromJson(
        jsonDecode(settingsResponseModel.responseJson),
      );
      numberController.text = invoiceDetailsModel.data?.number ?? '';
      clientController.text = invoiceDetailsModel.data?.clientId ?? '';
      dateController.text = invoiceDetailsModel.data?.date ?? '';
      dueDateController.text = invoiceDetailsModel.data?.duedate ?? '';
      billingStreetController.text =
          invoiceDetailsModel.data?.billingStreet ?? '';
      currencyController.text = invoiceDetailsModel.data?.currency ?? '';
      clientNoteController.text = invoiceDetailsModel.data?.clientNote ?? '';
      termsController.text = invoiceDetailsModel.data?.terms ?? '';
      totalInvoiceAmount = invoiceDetailsModel.data?.total ?? '';
      // Items
      removedItemsList.clear();
      invoiceItemList.clear();
      allowedPaymentModesList.clear();
      if (invoiceDetailsModel.data!.items!.isNotEmpty) {
        for (var i = 0; i < invoiceDetailsModel.data!.items!.length; i++) {
          invoiceItemList.add(
            InvoiceItemModel(
              itemNameController: TextEditingController(
                text: invoiceDetailsModel.data!.items![i].description
                    .toString(),
              ),
              descriptionController: TextEditingController(
                text: invoiceDetailsModel.data!.items![i].longDescription
                    .toString(),
              ),
              qtyController: TextEditingController(
                text: invoiceDetailsModel.data!.items![i].qty.toString(),
              ),
              unitController: TextEditingController(
                text: invoiceDetailsModel.data!.items![i].unit.toString(),
              ),
              rateController: TextEditingController(
                text: invoiceDetailsModel.data!.items![i].rate.toString(),
              ),
            ),
          );
        }
      }
      for (var i = 0; i < invoiceDetailsModel.data!.items!.length; i++) {
        removedItemsList.add(invoiceDetailsModel.data!.items![i].id.toString());
      }
      if (invoiceDetailsModel.data!.allowedPaymentModes!.isNotEmpty) {
        for (
          var i = 0;
          i < invoiceDetailsModel.data!.allowedPaymentModes!.length;
          i++
        ) {
          allowedPaymentModesList.add(
            invoiceDetailsModel.data!.allowedPaymentModes![i].toString(),
          );
        }
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  TextEditingController numberController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController billingStreetController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  MultiSelectController<Object> paymentModeController = MultiSelectController();
  TextEditingController clientNoteController = TextEditingController();
  TextEditingController termsController = TextEditingController();

  TextEditingController itemController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController qtyController = TextEditingController(text: '1');
  TextEditingController unitController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  FocusNode numberFocusNode = FocusNode();
  FocusNode clientFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode dueDateFocusNode = FocusNode();
  FocusNode billingStreetFocusNode = FocusNode();
  FocusNode currencyFocusNode = FocusNode();
  FocusNode clientNoteFocusNode = FocusNode();
  FocusNode termsFocusNode = FocusNode();

  FocusNode itemFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode qtyFocusNode = FocusNode();
  FocusNode unitFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();

  void increaseItemField() {
    invoiceItemList.add(
      InvoiceItemModel(
        itemNameController: TextEditingController(text: itemController.text),
        descriptionController: TextEditingController(
          text: descriptionController.text,
        ),
        qtyController: TextEditingController(text: qtyController.text),
        unitController: TextEditingController(text: unitController.text),
        rateController: TextEditingController(text: rateController.text),
      ),
    );
    itemController.clear();
    descriptionController.clear();
    qtyController.clear();
    unitController.clear();
    rateController.clear();
    calculateInvoiceAmount();
    update();
  }

  void decreaseItemField(int index) {
    invoiceItemList.removeAt(index);
    calculateInvoiceAmount();
    update();
  }

  String totalInvoiceAmount = '';
  void calculateInvoiceAmount() {
    double totalAmount = 0;

    for (var invoice in invoiceItemList) {
      double invoiceAmount = double.tryParse(invoice.rateController.text) ?? 0;
      double invoiceQty = double.tryParse(invoice.qtyController.text) ?? 0;
      totalAmount = totalAmount + (invoiceAmount * invoiceQty);
    }

    totalInvoiceAmount = totalAmount.toString();

    update();
  }

  Future<void> submitInvoice({String? invoiceId, bool isUpdate = false}) async {
    String number = numberController.text.toString();
    String client = clientController.text.toString();
    String date = dateController.text.toString();
    String dueDate = dueDateController.text.toString();
    String billingStreet = billingStreetController.text.toString();
    String currency = currencyController.text.toString();
    String clientNote = clientNoteController.text.toString();
    String terms = termsController.text.toString();

    if (number.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterNumber.tr]);
      return;
    }

    if (client.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.selectClient.tr]);
      return;
    }

    if (date.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.invoiceDate.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }

    if (currency.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.selectCurrency.tr]);
      return;
    }

    if (invoiceItemList.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.pleaseAddItem.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    InvoicePostModel invoiceModel = InvoicePostModel(
      clientId: client,
      number: number,
      date: date,
      duedate: dueDate,
      currency: currency,
      newItems: invoiceItemList,
      subtotal: totalInvoiceAmount, //TODO: SUBTOTAL
      total: totalInvoiceAmount,
      billingStreet: billingStreet,
      allowedPaymentModes: allowedPaymentModesList,
      removedItems: removedItemsList,
      clientNote: clientNote,
      terms: terms,
    );

    ResponseModel responseModel = await invoiceRepo.createInvoice(
      invoiceModel,
      invoiceId: invoiceId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      Get.back();
      clearData();
      if (isUpdate) await loadInvoiceDetails(invoiceId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  TextEditingController amountReceivedController = TextEditingController();
  TextEditingController paymentDateController = TextEditingController();
  TextEditingController modeController = TextEditingController();
  TextEditingController transactionIDController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  FocusNode amountReceivedFocusNode = FocusNode();
  FocusNode paymentDateFocusNode = FocusNode();
  FocusNode modeFocusNode = FocusNode();
  FocusNode transactionIDFocusNode = FocusNode();
  FocusNode noteFocusNode = FocusNode();

  // Record Invoice Payment
  Future<void> recordInvoicePayment(invoiceId) async {
    String amountReceived = amountReceivedController.text.toString();
    String paymentDate = paymentDateController.text.toString();
    String mode = modeController.text.toString();

    if (amountReceived.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.amountReceived.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }

    if (paymentDate.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.paymentDate.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }

    if (mode.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.paymentMode.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }

    PaymentPostModel paymentPostModel = PaymentPostModel(
      amountReceived: amountReceived,
      paymentDate: paymentDate,
      paymentMode: mode,
      transactionID: transactionIDController.text,
      note: noteController.text,
    );

    ResponseModel responseModel = await invoiceRepo.recordInvoicePayment(
      invoiceId,
      paymentPostModel,
    );

    isSubmitLoading = true;
    update();

    if (responseModel.status) {
      Get.back();
      await loadInvoiceDetails(invoiceId);
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Invoice
  Future<void> deleteInvoice(invoiceId) async {
    ResponseModel responseModel = await invoiceRepo.deleteInvoice(invoiceId);

    isSubmitLoading = true;
    update();

    if (responseModel.status) {
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    isSubmitLoading = false;
    update();
  }

  // Search Invoices
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchInvoice() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await invoiceRepo.searchInvoice(keysearch);
    if (responseModel.status) {
      invoicesModel = InvoicesModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();

    if (!isSearch) {
      searchController.clear();
      initialData();
    }
  }

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    numberController.text = '';
    clientController.text = '';
    dateController.text = '';
    dueDateController.text = '';
    billingStreetController.text = '';
    currencyController.text = '';
    clientNoteController.text = '';
    termsController.text = '';

    itemController.text = '';
    descriptionController.text = '';
    qtyController.text = '';
    unitController.text = '';
    rateController.text = '';

    amountReceivedController.text = '';
    paymentDateController.text = '';
    modeController.text = '';
    transactionIDController.text = '';
    noteController.text = '';

    invoiceItemList.clear();
    allowedPaymentModesList.clear();
    paymentModeController.clearAll();
  }
}
