import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/estimate/model/estimate_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_model.dart';
import 'package:flutex_admin/features/project/model/project_details_model.dart';
import 'package:flutex_admin/features/project/model/project_discussions_model.dart';
import 'package:flutex_admin/features/project/model/project_model.dart';
import 'package:flutex_admin/features/project/model/project_post_model.dart';
import 'package:flutex_admin/features/project/repo/project_repo.dart';
import 'package:flutex_admin/features/proposal/model/proposal_model.dart';
import 'package:flutex_admin/features/task/model/tasks_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  ProjectRepo projectRepo;
  ProjectController({required this.projectRepo});

  bool isLoading = true;
  bool submitLoading = false;

  bool projectOverviewEnable = true;
  bool projectTasksEnable = false;
  bool projectInvoicesEnable = false;
  bool projectEstimatesEnable = false;
  bool projectProposalsEnable = false;
  bool projectDiscussionsEnable = false;
  //bool projectTimesheets = false;
  //bool projectMilestones = false;
  //bool projectFiles = false;
  //bool projectGantt = false;
  //bool projectTickets = false;
  //bool projectContracts = false;
  //bool projectSubscriptions = false;
  //bool projectExpenses = false;
  //bool projectCreditNotes = false;
  //bool projectNotes = false;
  //bool projectActivity = false;

  bool createTaskEnable = true;
  bool editTaskEnable = true;
  ProjectsModel projectsModel = ProjectsModel();
  ProjectDetailsModel projectDetailsModel = ProjectDetailsModel();
  TasksModel tasksModel = TasksModel();
  InvoicesModel invoicesModel = InvoicesModel();
  EstimatesModel estimatesModel = EstimatesModel();
  ProposalsModel proposalsModel = ProposalsModel();
  ProjectDiscussionsModel projectDiscussionsModel = ProjectDiscussionsModel();
  CustomersModel customersModel = CustomersModel();

  final Map<String, String> billingType = {
    '1': LocalStrings.fixedRate.tr,
    '2': LocalStrings.projectHours.tr,
    '3': LocalStrings.taskHours.tr,
  };

  final Map<String, String> projectStatus = {
    '1': LocalStrings.notStarted.tr,
    '2': LocalStrings.inProgress.tr,
    '3': LocalStrings.onHold.tr,
    '4': LocalStrings.finished.tr,
    '5': LocalStrings.cancelled.tr,
  };

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadProjects();
    isLoading = false;
    update();
  }

  Future<void> loadProjects() async {
    ResponseModel responseModel = await projectRepo.getAllProjects();
    if (responseModel.status) {
      projectsModel = ProjectsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadProjectDetails(projectId) async {
    ResponseModel responseModel = await projectRepo.getProjectDetails(
      projectId,
    );
    if (responseModel.status) {
      projectDetailsModel = ProjectDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      AvailableFeatures availableFeatures =
          projectDetailsModel.data?.settings?.availableFeatures ??
          AvailableFeatures();

      projectOverviewEnable =
          availableFeatures.projectOverview.toString() == '1' ? true : false;
      projectTasksEnable = availableFeatures.projectTasks.toString() == '1'
          ? true
          : false;
      projectInvoicesEnable =
          availableFeatures.projectInvoices.toString() == '1' ? true : false;
      projectEstimatesEnable =
          availableFeatures.projectEstimates.toString() == '1' ? true : false;
      projectProposalsEnable =
          availableFeatures.projectProposals.toString() == '1' ? true : false;
      projectDiscussionsEnable =
          availableFeatures.projectDiscussions.toString() == '1' ? true : false;
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  Future<void> loadProjectGroup(projectId, group) async {
    ResponseModel responseModel = await projectRepo.getProjectGroup(
      projectId,
      group,
    );
    switch (group) {
      case 'tasks':
        tasksModel = TasksModel.fromJson(
          jsonDecode(responseModel.responseJson),
        );
        break;
      case 'invoices':
        invoicesModel = InvoicesModel.fromJson(
          jsonDecode(responseModel.responseJson),
        );
        break;
      case 'estimates':
        estimatesModel = EstimatesModel.fromJson(
          jsonDecode(responseModel.responseJson),
        );
        break;
      case 'proposals':
        proposalsModel = ProposalsModel.fromJson(
          jsonDecode(responseModel.responseJson),
        );
        break;
      case 'discussions':
        projectDiscussionsModel = ProjectDiscussionsModel.fromJson(
          jsonDecode(responseModel.responseJson),
        );
        break;
    }

    isLoading = false;
    update();
  }

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await projectRepo.getAllCustomers();
    return customersModel = CustomersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadProjectUpdateData(projectId) async {
    ResponseModel responseModel = await projectRepo.getProjectDetails(
      projectId,
    );
    if (responseModel.status) {
      projectDetailsModel = ProjectDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      nameController.text = projectDetailsModel.data?.name ?? '';
      clientController.text = projectDetailsModel.data?.clientId ?? '';
      billingTypeController.text = projectDetailsModel.data?.billingType ?? '';
      startDateController.text = projectDetailsModel.data?.startDate ?? '';
      statusController.text = projectDetailsModel.data?.status ?? '';
      progressFromTasksController.text =
          projectDetailsModel.data?.progressFromTasks ?? '';
      projectCostController.text = projectDetailsModel.data?.projectCost ?? '';
      progressController.text = projectDetailsModel.data?.progress ?? '';
      projectRatePerHourController.text =
          projectDetailsModel.data?.projectRatePerHour ?? '';
      estimatedHoursController.text =
          projectDetailsModel.data?.estimatedHours ?? '';
      deadlineController.text = projectDetailsModel.data?.deadline ?? '';
      descriptionController.text = projectDetailsModel.data?.description ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController billingTypeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController progressFromTasksController = TextEditingController();
  TextEditingController projectCostController = TextEditingController();
  TextEditingController progressController = TextEditingController();
  TextEditingController projectRatePerHourController = TextEditingController();
  TextEditingController estimatedHoursController = TextEditingController();
  TextEditingController projectMembersController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode clientIdFocusNode = FocusNode();
  FocusNode billingTypeFocusNode = FocusNode();
  FocusNode startDateFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode progressFromTasksFocusNode = FocusNode();
  FocusNode projectCostFocusNode = FocusNode();
  FocusNode progressFocusNode = FocusNode();
  FocusNode projectRatePerHourFocusNode = FocusNode();
  FocusNode estimatedHoursFocusNode = FocusNode();
  FocusNode projectMembersFocusNode = FocusNode();
  FocusNode deadlineFocusNode = FocusNode();
  FocusNode tagsFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  Future<void> submitProject({String? projectId, bool isUpdate = false}) async {
    String name = nameController.text.toString();
    String clientId = clientController.text.toString();
    String billingType = billingTypeController.text.toString();
    String startDate = startDateController.text.toString();
    String status = statusController.text.toString();
    String progressFromTasks = progressFromTasksController.text.toString();
    String projectCost = projectCostController.text.toString();
    String progress = progressController.text.toString();
    String projectRatePerHour = projectRatePerHourController.text.toString();
    String estimatedHours = estimatedHoursController.text.toString();
    String projectMembers = projectMembersController.text.toString();
    String deadline = deadlineController.text.toString();
    String tags = tagsController.text.toString();
    String description = descriptionController.text.toString();

    if (name.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterSubject.tr]);
      return;
    }
    if (billingType.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.billingType.tr]);
      return;
    }
    if (clientId.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.customer.tr]);
      return;
    }

    submitLoading = true;
    update();

    ProjectPostModel projectModel = ProjectPostModel(
      name: name,
      clientId: clientId,
      billingType: billingType,
      startDate: startDate,
      status: status,
      progressFromTasks: progressFromTasks,
      projectCost: projectCost,
      progress: progress,
      projectRatePerHour: projectRatePerHour,
      estimatedHours: estimatedHours,
      projectMembers: projectMembers,
      deadline: deadline,
      tags: tags,
      description: description,
    );

    ResponseModel responseModel = await projectRepo.createProject(
      projectModel,
      projectId: projectId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      Get.back();
      if (isUpdate) await loadProjectDetails(projectId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
      return;
    }

    submitLoading = false;
    update();
  }

  // Delete Project
  Future<void> deleteProject(projectId) async {
    ResponseModel responseModel = await projectRepo.deleteProject(projectId);

    submitLoading = true;
    update();

    if (responseModel.status) {
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    submitLoading = false;
    update();
  }

  // Search Projects
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchProject() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await projectRepo.searchProject(keysearch);
    if (responseModel.status) {
      projectsModel = ProjectsModel.fromJson(
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
    submitLoading = false;
    nameController.text = '';
    clientController.text = '';
    billingTypeController.text = '';
    startDateController.text = '';
    statusController.text = '';
    progressFromTasksController.text = '';
    projectCostController.text = '';
    progressController.text = '';
    projectRatePerHourController.text = '';
    estimatedHoursController.text = '';
    projectMembersController.text = '';
    deadlineController.text = '';
    tagsController.text = '';
    descriptionController.text = '';
  }
}
