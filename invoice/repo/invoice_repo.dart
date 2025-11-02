import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_post_model.dart';
import 'package:flutex_admin/features/invoice/model/payment_post_model.dart';

class InvoiceRepo {
  ApiClient apiClient;
  InvoiceRepo({required this.apiClient});

  Future<ResponseModel> getAllInvoices() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getInvoiceDetails(invoiceId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}/id/$invoiceId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getSettingsData() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/general";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllCustomers() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getCurrencies() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/currencies";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getTaxes() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/tax_data";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getPaymentModes() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/payment_modes";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getItems() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.itemsUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> createInvoice(
    InvoicePostModel invoiceModel, {
    String? invoiceId,
    bool isUpdate = false,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}";

    Map<String, dynamic> params = {
      "clientid": invoiceModel.clientId,
      "number": invoiceModel.number,
      "date": invoiceModel.date,
      "duedate": invoiceModel.duedate,
      "currency": invoiceModel.currency,
      "subtotal": invoiceModel.subtotal,
      "total": invoiceModel.total,
      "billing_street": invoiceModel.billingStreet,
      //"billing_city": invoiceModel.billingCity,
      //"billing_state": invoiceModel.billingState,
      //"billing_zip": invoiceModel.billingZip,
      //"billing_country": invoiceModel.billingCountry,
      //"include_shipping": invoiceModel.includeShipping,
      //"show_shipping_on_invoice": invoiceModel.showShippingOnInvoice,
      //"shipping_street": invoiceModel.shippingStreet,
      //"shipping_city": invoiceModel.shippingCity,
      //"shipping_state": invoiceModel.shippingState,
      //"shipping_zip": invoiceModel.shippingZip,
      //"shipping_country": invoiceModel.shippingCountry,
      //"cancel_overdue_reminders": invoiceModel.cancelOverdueReminders,
      //"tags": invoiceModel.tags,
      //"sale_agent": invoiceModel.saleAgent,
      //"recurring": invoiceModel.recurring,
      //"discount_type": invoiceModel.discountType,
      //"repeat_every_custom": invoiceModel.repeatEveryCustom,
      //"repeat_type_custom": invoiceModel.repeatTypeCustom,
      //"cycles": invoiceModel.cycles,
      //"adminnote": invoiceModel.adminNote,
      "clientnote": invoiceModel.clientNote,
      "terms": invoiceModel.terms,
    };

    int i = 0;
    for (var invoice in invoiceModel.newItems) {
      String invoiceItemName = invoice.itemNameController.text;
      String invoiceItemRate = invoice.rateController.text;

      if (invoiceItemName.isNotEmpty && invoiceItemRate.isNotEmpty) {
        params['newitems[$i][description]'] = invoiceItemName;
        params['newitems[$i][long_description]'] =
            invoice.descriptionController.text;
        params['newitems[$i][qty]'] = invoice.qtyController.text;
        params['newitems[$i][rate]'] = invoiceItemRate;
        params['newitems[$i][unit]'] = invoice.unitController.text;
        i++;
        //params['newitems[$i][order]'] = '1';
        //params['newitems[0][taxname][]'] = 'CGST|9.00';
        //params['newitems[0][taxname][]'] = 'SGST|9.00';
      }
    }

    if (invoiceModel.removedItems != null) {
      int r = 0;
      for (var removedItems in invoiceModel.removedItems!) {
        params['removed_items[$r]'] = removedItems;
        r++;
      }
    }

    int p = 0;
    for (var paymentModes in invoiceModel.allowedPaymentModes) {
      params['allowed_payment_modes[$p]'] = paymentModes;
      p++;
    }

    ResponseModel responseModel = await apiClient.request(
      isUpdate ? '$url/id/$invoiceId' : url,
      isUpdate ? Method.putMethod : Method.postMethod,
      params,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> deleteInvoice(invoiceId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}/id/$invoiceId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.deleteMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> searchInvoice(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}/search/$keysearch";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> recordInvoicePayment(
    String invoiceId,
    PaymentPostModel paymentPostModel,
  ) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}/payment";

    Map<String, dynamic> params = {
      "invoiceid": invoiceId,
      "amount": paymentPostModel.amountReceived,
      "date": paymentPostModel.paymentDate,
      "paymentmode": paymentPostModel.paymentMode,
      "transactionid": paymentPostModel.transactionID,
      "note": paymentPostModel.note,
    };

    ResponseModel responseModel = await apiClient.request(
      url,
      Method.postMethod,
      params,
      passHeader: true,
    );
    return responseModel;
  }
}
