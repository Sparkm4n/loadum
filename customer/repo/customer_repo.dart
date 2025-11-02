import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/customer/model/contact_post_model.dart';
import 'package:flutex_admin/features/customer/model/customer_post_model.dart';

/// Repository für Kunden-bezogene API-Calls.
/// UX-Optimierung für Reinigungsunternehmen:
/// - "Shipping*" ist optional; wenn nicht gesetzt, wird automatisch die Billing-Adresse gespiegelt.
/// - Es werden nur nicht-leere Felder gesendet (saubere Payload).
class CustomerRepo {
  final ApiClient apiClient;
  CustomerRepo({required this.apiClient});

  /* ==========================
   *        READ
   * ========================== */

  Future<ResponseModel> getAllCustomers() async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> getCustomerDetails(String customerId) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}/id/$customerId";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> getCustomerContacts(String customerId) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.contactsUrl}/id/$customerId";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> getCustomerGroups() async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/client_groups";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> getCountries() async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/countries";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> getCurrencies() async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/currencies";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  /* ==========================
   *       CREATE / UPDATE
   * ========================== */

  /// [shippingSameAsBilling]
  ///  - true (Default): Falls keine Shipping-Felder gesetzt sind, werden Billing-Felder gespiegelt.
  ///  - false: Shipping-Felder werden nur gesendet, wenn sie befüllt sind.
  Future<ResponseModel> submitCustomer(
      CustomerPostModel customerModel, {
        String? customerId,
        bool isUpdate = false,
        bool shippingSameAsBilling = true,
      }) async {
    final baseUrl = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";

    /// Nur nicht-leere Werte setzen
    final Map<String, dynamic> params = {};
    void putIfNotEmpty(String key, dynamic val) {
      if (val == null) return;
      if (val is String && val.trim().isEmpty) return;
      params[key] = val;
    }

    // Basisfelder (Company-Feld kann bei Privatkunden den Vollnamen tragen – UI stellt das bereit)
    putIfNotEmpty("company", customerModel.company);
    putIfNotEmpty("vat", customerModel.vat);
    putIfNotEmpty("phonenumber", customerModel.phoneNumber);
    putIfNotEmpty("website", customerModel.website);
    // putIfNotEmpty("default_language", customerModel.defaultLanguage);
    putIfNotEmpty("default_currency", customerModel.defaultCurrency);

    // Adresse (Profil)
    putIfNotEmpty("address", customerModel.address);
    putIfNotEmpty("city", customerModel.city);
    putIfNotEmpty("state", customerModel.state);
    putIfNotEmpty("zip", customerModel.zip);
    putIfNotEmpty("country", customerModel.country);

    // Billing
    putIfNotEmpty("billing_street", customerModel.billingStreet);
    putIfNotEmpty("billing_city", customerModel.billingCity);
    putIfNotEmpty("billing_state", customerModel.billingState);
    putIfNotEmpty("billing_zip", customerModel.billingZip);
    putIfNotEmpty("billing_country", customerModel.billingCountry);

    // Shipping: optional – standardmäßig Billing spiegeln (Cleaning-spezifisch)
    final hasExplicitShipping =
        (customerModel.shippingStreet?.trim().isNotEmpty ?? false) ||
            (customerModel.shippingCity?.trim().isNotEmpty ?? false) ||
            (customerModel.shippingState?.trim().isNotEmpty ?? false) ||
            (customerModel.shippingZip?.trim().isNotEmpty ?? false) ||
            (customerModel.shippingCountry?.toString().trim().isNotEmpty ?? false);

    if (shippingSameAsBilling && !hasExplicitShipping) {
      // Spiegel Billing → Shipping
      if ((customerModel.billingStreet ?? '').isNotEmpty) {
        params["shipping_street"] = customerModel.billingStreet;
      }
      if ((customerModel.billingCity ?? '').isNotEmpty) {
        params["shipping_city"] = customerModel.billingCity;
      }
      if ((customerModel.billingState ?? '').isNotEmpty) {
        params["shipping_state"] = customerModel.billingState;
      }
      if ((customerModel.billingZip ?? '').isNotEmpty) {
        params["shipping_zip"] = customerModel.billingZip;
      }
      if ((customerModel.billingCountry?.toString() ?? '').isNotEmpty) {
        params["shipping_country"] = customerModel.billingCountry;
      }
    } else {
      // Nur setzen, wenn tatsächlich vorhanden
      putIfNotEmpty("shipping_street", customerModel.shippingStreet);
      putIfNotEmpty("shipping_city", customerModel.shippingCity);
      putIfNotEmpty("shipping_state", customerModel.shippingState);
      putIfNotEmpty("shipping_zip", customerModel.shippingZip);
      putIfNotEmpty("shipping_country", customerModel.shippingCountry);
    }

    // Gruppen
    if (customerModel.groupsIn != null && customerModel.groupsIn!.isNotEmpty) {
      for (int i = 0; i < customerModel.groupsIn!.length; i++) {
        params['groups_in[$i]'] = customerModel.groupsIn![i];
      }
    }

    final url = isUpdate ? '$baseUrl/id/$customerId' : baseUrl;
    final method = isUpdate ? Method.putMethod : Method.postMethod;

    return await apiClient.request(url, method, params, passHeader: true);
  }

  /* ==========================
   *        DELETE
   * ========================== */

  Future<ResponseModel> deleteCustomer(String customerId) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}/id/$customerId";
    return await apiClient.request(url, Method.deleteMethod, null, passHeader: true);
  }

  /* ==========================
   *        SEARCH
   * ========================== */

  Future<ResponseModel> searchCustomer(String keysearch) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}/search/$keysearch";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  /* ==========================
   *        CONTACTS
   * ========================== */

  Future<ResponseModel> createContact(ContactPostModel contactModel) async {
    final url =
        "${UrlContainer.baseUrl}${UrlContainer.contactsUrl}/id/${contactModel.customerId}";

    final Map<String, dynamic> params = {
      "firstname": contactModel.firstName,
      "lastname": contactModel.lastName,
      "email": contactModel.email,
      "title": contactModel.title,
      "phonenumber": contactModel.phone,
      "password": contactModel.password,
    };

    return await apiClient.request(url, Method.postMethod, params, passHeader: true);
  }
}
