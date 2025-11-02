import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/currencies_model.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/countries_model.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/customer/model/contact_model.dart';
import 'package:flutex_admin/features/customer/model/contact_post_model.dart';
import 'package:flutex_admin/features/customer/model/customer_details_model.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/customer/model/customer_post_model.dart';
import 'package:flutex_admin/features/customer/model/groups_model.dart';
import 'package:flutex_admin/features/customer/repo/customer_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomerController extends GetxController {
  CustomerRepo customerRepo;
  CustomerController({required this.customerRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  CustomersModel customersModel = CustomersModel();
  CustomerDetailsModel customerDetailsModel = CustomerDetailsModel();
  ContactsModel customerContactsModel = ContactsModel();
  GroupsModel groupsModel = GroupsModel();
  CountriesModel countriesModel = CountriesModel();
  CurrenciesModel currenciesModel = CurrenciesModel();
  List<String> groupsList = [];

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadCustomers();
    isLoading = false;
    update();
  }

  Future<void> loadCustomers() async {
    ResponseModel responseModel = await customerRepo.getAllCustomers();
    customersModel = CustomersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
    isLoading = false;
    update();
  }

  Future<void> loadCustomerDetails(customerId) async {
    ResponseModel responseModel = await customerRepo.getCustomerDetails(
      customerId,
    );
    if (responseModel.status) {
      customerDetailsModel = CustomerDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<GroupsModel> loadCustomerGroups() async {
    ResponseModel responseModel = await customerRepo.getCustomerGroups();
    return groupsModel = GroupsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<CountriesModel> loadCountries() async {
    ResponseModel responseModel = await customerRepo.getCountries();
    return countriesModel = CountriesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<CurrenciesModel> loadCurrencies() async {
    ResponseModel responseModel = await customerRepo.getCurrencies();
    return currenciesModel = CurrenciesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadCustomerUpdateData(customerId) async {
    ResponseModel responseModel = await customerRepo.getCustomerDetails(
      customerId,
    );
    if (responseModel.status) {
      customerDetailsModel = CustomerDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      companyController.text = customerDetailsModel.data?.company ?? '';
      vatController.text = customerDetailsModel.data?.vat ?? '';
      phoneNumberController.text = customerDetailsModel.data?.phoneNumber ?? '';
      websiteController.text = customerDetailsModel.data?.website ?? '';
      currencyController.text =
          customerDetailsModel.data?.defaultCurrency ?? '';
      addressController.text = customerDetailsModel.data?.address ?? '';
      cityController.text = customerDetailsModel.data?.city ?? '';
      stateController.text = customerDetailsModel.data?.state ?? '';
      zipController.text = customerDetailsModel.data?.zip ?? '';
      countryController.text = customerDetailsModel.data?.country ?? '';

      billingStreetController.text =
          customerDetailsModel.data?.billingStreet ?? '';
      billingCityController.text = customerDetailsModel.data?.billingCity ?? '';
      billingStateController.text =
          customerDetailsModel.data?.billingState ?? '';
      billingZipController.text = customerDetailsModel.data?.billingZip ?? '';
      billingCountryController.text =
          customerDetailsModel.data?.billingCountry ?? '';
      shippingStreetController.text =
          customerDetailsModel.data?.shippingStreet ?? '';
      shippingCityController.text =
          customerDetailsModel.data?.shippingCity ?? '';
      shippingStateController.text =
          customerDetailsModel.data?.shippingState ?? '';
      shippingZipController.text = customerDetailsModel.data?.shippingZip ?? '';
      shippingCountryController.text =
          customerDetailsModel.data?.shippingCountry ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  TextEditingController companyController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  MultiSelectController<Object> groupController = MultiSelectController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  TextEditingController billingStreetController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();
  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingZipController = TextEditingController();
  TextEditingController billingCountryController = TextEditingController();
  TextEditingController shippingStreetController = TextEditingController();
  TextEditingController shippingCityController = TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  TextEditingController shippingZipController = TextEditingController();
  TextEditingController shippingCountryController = TextEditingController();

  FocusNode companyFocusNode = FocusNode();
  FocusNode vatFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode websiteFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode groupFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  FocusNode billingStreetFocusNode = FocusNode();
  FocusNode billingCityFocusNode = FocusNode();
  FocusNode billingStateFocusNode = FocusNode();
  FocusNode billingZipFocusNode = FocusNode();
  FocusNode billingCountryFocusNode = FocusNode();
  FocusNode shippingStreetFocusNode = FocusNode();
  FocusNode shippingCityFocusNode = FocusNode();
  FocusNode shippingStateFocusNode = FocusNode();
  FocusNode shippingZipFocusNode = FocusNode();
  FocusNode shippingCountryFocusNode = FocusNode();

  Future<void> submitCustomer({
    String? customerId,
    bool isUpdate = false,
  }) async {
    String company = companyController.text.toString();
    String vat = vatController.text.toString();
    String phoneNumber = phoneNumberController.text.toString();
    String website = websiteController.text.toString();
    String currency = currencyController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String state = stateController.text.toString();
    String zip = zipController.text.toString();
    String country = countryController.text.toString();

    String billingStreet = billingStreetController.text.toString();
    String billingCity = billingCityController.text.toString();
    String billingState = billingStateController.text.toString();
    String billingZip = billingZipController.text.toString();
    String billingCountry = billingCountryController.text.toString();
    String shippingStreet = shippingStreetController.text.toString();
    String shippingCity = shippingCityController.text.toString();
    String shippingState = shippingStateController.text.toString();
    String shippingZip = shippingZipController.text.toString();
    String shippingCountry = shippingCountryController.text.toString();

    if (company.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterCompanyName.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    CustomerPostModel customerModel = CustomerPostModel(
      company: company,
      vat: vat,
      phoneNumber: phoneNumber,
      website: website,
      address: address,
      groupsIn: groupsList,
      defaultCurrency: currency,
      city: city,
      state: state,
      zip: zip,
      country: country,
      billingStreet: billingStreet,
      billingCity: billingCity,
      billingState: billingState,
      billingZip: billingZip,
      billingCountry: billingCountry,
      shippingStreet: shippingStreet,
      shippingCity: shippingCity,
      shippingState: shippingState,
      shippingZip: shippingZip,
      shippingCountry: shippingCountry,
    );

    ResponseModel responseModel = await customerRepo.submitCustomer(
      customerModel,
      customerId: customerId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      clearCustomerData();
      Get.back();
      if (isUpdate) await loadCustomerDetails(customerId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Customer
  Future<void> deleteCustomer(customerId) async {
    ResponseModel responseModel = await customerRepo.deleteCustomer(customerId);

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

  // Search Customers
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchCustomer() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await customerRepo.searchCustomer(keysearch);
    if (responseModel.status) {
      customersModel = CustomersModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
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

  Future<void> loadCustomerContacts(customerId) async {
    ResponseModel responseModel = await customerRepo.getCustomerContacts(
      customerId,
    );
    customerContactsModel = ContactsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );

    isLoading = false;
    update();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode titleFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  Future<void> submitContact(String customerId) async {
    String firstName = firstNameController.text.toString();
    String lastName = lastNameController.text.toString();
    String email = emailController.text.toString();
    String title = titleController.text.toString();
    String phone = phoneController.text.toString();
    String password = passwordController.text.toString();

    if (firstName.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterSubject.tr]);
      return;
    }
    if (lastName.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.billingType.tr]);
      return;
    }
    if (email.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.customer.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    ContactPostModel contactModel = ContactPostModel(
      customerId: customerId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      title: title,
      phone: phone,
      password: password,
    );

    ResponseModel responseModel = await customerRepo.createContact(
      contactModel,
    );
    if (responseModel.status) {
      Get.back();
      clearData();
      await loadCustomerContacts(customerId);
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  void clearCustomerData() {
    isLoading = false;
    isSubmitLoading = false;
    groupsList = [];
    companyController.text = '';
    vatController.text = '';
    phoneNumberController.text = '';
    websiteController.text = '';
    groupController.clearAll();
    addressController.text = '';
    currencyController.text = '';
    countryController.text = '';
    cityController.text = '';
    stateController.text = '';
    zipController.text = '';
    billingStreetController.text = '';
    billingCityController.text = '';
    billingStateController.text = '';
    billingZipController.text = '';
    billingCountryController.text = '';
    shippingStreetController.text = '';
    shippingCityController.text = '';
    shippingStateController.text = '';
    shippingZipController.text = '';
    shippingCountryController.text = '';
  }

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    firstNameController.text = '';
    lastNameController.text = '';
    emailController.text = '';
    titleController.text = '';
    phoneController.text = '';
  }
}
