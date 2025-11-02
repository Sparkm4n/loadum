import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/lead/model/kanban_lead_model.dart';
import 'package:flutex_admin/features/lead/model/lead_create_model.dart';
import 'package:flutex_admin/features/lead/model/lead_details_model.dart';
import 'package:flutex_admin/features/lead/model/lead_model.dart';
import 'package:flutex_admin/features/lead/model/sources_model.dart';
import 'package:flutex_admin/features/lead/model/statuses_model.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/staff/model/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class LeadController extends GetxController {
  LeadRepo leadRepo;
  LeadController({required this.leadRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  bool showFab = true;
  ScrollController scrollController = ScrollController();
  LeadsModel leadsModel = LeadsModel();
  final leads = <Lead>[].obs;
  int page = 0;
  String? sortBy;
  String? source;
  String? status;
  bool hasMoreData = true;
  LeadDetailsModel leadDetailsModel = LeadDetailsModel();
  KanbanLeadModel kanbanLeadModel = KanbanLeadModel();

  StatusesModel statusesModel = StatusesModel();
  SourcesModel sourcesModel = SourcesModel();
  StaffsModel staffsModel = StaffsModel();

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) {
          showFab = false;
          update();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) {
          showFab = true;
          update();
        }
      }
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        // Load more data when the user reaches the bottom of the list
        if (hasMoreData) {
          loadLeads(page: ++page);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();
    leads.clear();
    page = 0;
    hasMoreData = true;
    await loadLeads();
    isLoading = false;
    update();
  }

  Future<void> loadLeads({int page = 0}) async {
    ResponseModel responseModel = await leadRepo.getAllLeads(
      page: page,
      sort: sortBy,
      source: source,
      status: status,
    );
    leadsModel = LeadsModel.fromJson(jsonDecode(responseModel.responseJson));
    if (responseModel.status) {
      leads.addAll(leadsModel.data ?? []);
      if ((leadsModel.data?.length ?? 0) < int.parse(UrlContainer.limit)) {
        hasMoreData = false;
      }
    } else {
      hasMoreData = false;
    }
    isLoading = false;
    update();
  }

  Future<void> loadKanbanLeads() async {
    ResponseModel responseModel = await leadRepo.getKanbanLeads();
    if (responseModel.status) {
      kanbanLeadModel = KanbanLeadModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<StatusesModel> loadLeadStatuses() async {
    ResponseModel responseModel = await leadRepo.getLeadStatuses();
    return statusesModel = StatusesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<SourcesModel> loadLeadSources() async {
    ResponseModel responseModel = await leadRepo.getLeadSources();
    return sourcesModel = SourcesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<StaffsModel> loadStaff() async {
    ResponseModel responseModel = await leadRepo.getStaff();
    return staffsModel = StaffsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadLeadUpdateData(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadDetails(leadId);
    if (responseModel.status) {
      leadDetailsModel = LeadDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      sourceController.text = leadDetailsModel.data?.source ?? '';
      statusController.text = leadDetailsModel.data?.status ?? '';
      nameController.text = leadDetailsModel.data?.name ?? '';
      assignedController.text = leadDetailsModel.data?.assigned ?? '';
      valueController.text = leadDetailsModel.data?.leadValue ?? '';
      titleController.text = leadDetailsModel.data?.title ?? '';
      emailController.text = leadDetailsModel.data?.email ?? '';
      websiteController.text = leadDetailsModel.data?.website ?? '';
      phoneNumberController.text = leadDetailsModel.data?.phoneNumber ?? '';
      companyController.text = leadDetailsModel.data?.company ?? '';
      addressController.text = leadDetailsModel.data?.address ?? '';
      cityController.text = leadDetailsModel.data?.city ?? '';
      stateController.text = leadDetailsModel.data?.state ?? '';
      countryController.text = leadDetailsModel.data?.country ?? '';
      defaultLanguageController.text =
          leadDetailsModel.data?.defaultLanguage ?? '';
      descriptionController.text = leadDetailsModel.data?.description ?? '';
      //customContactDateController.text = leadDetailsModel.data?.lastContact ?? '';
      //contactedTodayController.text = leadDetailsModel.data?.lastContact ?? '';
      isPublicController.text = leadDetailsModel.data?.isPublic ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  TextEditingController sourceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController assignedController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController defaultLanguageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController isPublicController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode assignedFocusNode = FocusNode();
  FocusNode tagsFocusNode = FocusNode();
  FocusNode valueFocusNode = FocusNode();
  FocusNode titleFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode websiteFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode companyFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  FocusNode defaultLanguageFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode isPublicFocusNode = FocusNode();

  Future<void> submitLead({String? leadId, bool isUpdate = false}) async {
    String source = sourceController.text.toString();
    String status = statusController.text.toString();
    String name = nameController.text.toString();
    String assigned = assignedController.text.toString();
    String tags = tagsController.text.toString();
    String value = valueController.text.toString();
    String title = titleController.text.toString();
    String email = emailController.text.toString();
    String website = websiteController.text.toString();
    String phoneNumber = phoneNumberController.text.toString();
    String company = companyController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String state = stateController.text.toString();
    String country = countryController.text.toString();
    String defaultLanguage = defaultLanguageController.text.toString();
    String description = descriptionController.text.toString();
    String isPublic = isPublicController.text.toString();

    if (source.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.pleaseSelectSource.tr]);
      return;
    }
    if (status.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterStatus.tr]);
      return;
    }
    if (name.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterName.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    LeadCreateModel leadModel = LeadCreateModel(
      source: source,
      status: status,
      name: name,
      assigned: assigned,
      tags: tags,
      value: value,
      title: title,
      email: email,
      website: website,
      phoneNumber: phoneNumber,
      company: company,
      address: address,
      city: city,
      state: state,
      country: country,
      defaultLanguage: defaultLanguage,
      description: description,
      isPublic: isPublic,
    );

    ResponseModel responseModel = await leadRepo.createLead(
      leadModel,
      leadId: leadId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      clearData();
      Get.back();
      if (isUpdate) {
        await Get.find<LeadDetailsController>().loadLeadDetails(leadId);
      }
      await loadLeads();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  // Search Leads
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchLead() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await leadRepo.searchLead(keysearch);
    leadsModel = LeadsModel.fromJson(jsonDecode(responseModel.responseJson));
    leads.assignAll(leadsModel.data ?? []);
    hasMoreData = false;
    isLoading = false;
    update();
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();

    if (!isSearch) {
      searchController.clear();
      keysearch = "";
      initialData();
    }
  }

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    sourceController.text = '';
    statusController.text = '';
    nameController.text = '';
    assignedController.text = '';
    tagsController.text = '';
    valueController.text = '';
    titleController.text = '';
    emailController.text = '';
    websiteController.text = '';
    phoneNumberController.text = '';
    companyController.text = '';
    addressController.text = '';
    cityController.text = '';
    stateController.text = '';
    countryController.text = '';
    defaultLanguageController.text = '';
    descriptionController.text = '';
    isPublicController.text = '';
  }
}
