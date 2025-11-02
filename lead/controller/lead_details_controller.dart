import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/file_download_dialog/download_dialog.dart';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/lead/controller/lead_controller.dart';
import 'package:flutex_admin/features/lead/model/activity_log_model.dart';
import 'package:flutex_admin/features/lead/model/lead_details_model.dart';
import 'package:flutex_admin/features/lead/model/notes_model.dart';
import 'package:flutex_admin/features/lead/model/reminder_create_model.dart';
import 'package:flutex_admin/features/lead/model/reminders_model.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/staff/model/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetailsController extends GetxController {
  LeadRepo leadRepo;
  LeadDetailsController({required this.leadRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  LeadDetailsModel leadDetailsModel = LeadDetailsModel();
  StaffsModel staffsModel = StaffsModel();
  ActivityLogModel activityLogModel = ActivityLogModel();
  NotesModel notesModel = NotesModel();
  RemindersModel remindersModel = RemindersModel();
  bool sendEmailReminder = false;
  bool leadContacted = false;

  Future<void> loadLeadDetails(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadDetails(leadId);
    if (responseModel.status) {
      leadDetailsModel = LeadDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  Future<StaffsModel> loadStaff() async {
    ResponseModel responseModel = await leadRepo.getStaff();
    return staffsModel = StaffsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadLeadNotes(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadNotes(leadId);
    notesModel = NotesModel.fromJson(jsonDecode(responseModel.responseJson));

    isLoading = false;
    update();
  }

  Future<void> loadLeadReminders(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadReminders(leadId);
    remindersModel = RemindersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );

    isLoading = false;
    update();
  }

  TextEditingController dateController = TextEditingController();
  TextEditingController staffController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode dateFocusNode = FocusNode();
  FocusNode staffFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  Future<void> addLeadReminder(leadId) async {
    String date = dateController.text.toString();
    String staff = staffController.text.toString();
    String description = descriptionController.text.toString();
    String emailReminder = sendEmailReminder ? '1' : '0';

    if (date.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.pleaseEnterDate.tr]);
      return;
    }
    if (staff.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.selectStaff.tr]);
      return;
    }
    if (description.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterDescription.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    ReminderCreateModel reminderCreateModel = ReminderCreateModel(
      date: date,
      staff: staff,
      description: description,
      emailReminder: emailReminder,
    );

    ResponseModel responseModel = await leadRepo.postLeadReminder(
      leadId,
      reminderCreateModel,
    );
    if (responseModel.status) {
      Get.back();
      await loadLeadReminders(leadId);
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  changeEmailReminder() {
    sendEmailReminder = !sendEmailReminder;
    update();
  }

  TextEditingController noteController = TextEditingController();
  TextEditingController dateContactedController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  FocusNode dateContactedFocusNode = FocusNode();

  Future<void> addLeadNote(leadId) async {
    String note = noteController.text.toString();
    String dateContacted = dateContactedController.text.toString();

    if (note.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.pleaseEnterNote.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    ResponseModel responseModel = await leadRepo.postLeadNote(
      leadId,
      note,
      dateContacted,
    );
    if (responseModel.status) {
      Get.back();
      await loadLeadNotes(leadId);
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  changeLeadContacted() {
    leadContacted = !leadContacted;
    update();
  }

  Future<void> loadLeadActivityLog(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadActivityLog(leadId);
    if (responseModel.status) {
      activityLogModel = ActivityLogModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  // Delete Lead
  Future<void> deleteLead(leadId) async {
    ResponseModel responseModel = await leadRepo.deleteLead(leadId);

    isSubmitLoading = true;
    update();

    if (responseModel.status) {
      await Get.find<LeadController>().loadLeads();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    isSubmitLoading = false;
    update();
  }

  bool downloadLoading = false;
  Future<void> downloadAttachment(
    String attachmentType,
    String attachmentKey,
  ) async {
    downloadLoading = true;
    update();

    ResponseModel responseModel = await leadRepo.attachmentDownload(
      attachmentKey,
    );
    if (responseModel.status) {
      showDialog(
        context: Get.context!,
        builder: (context) => DownloadingDialog(
          isImage: true,
          isPdf: false,
          url: attachmentType,
          fileName: attachmentKey,
        ),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    downloadLoading = false;
    update();
  }

  clearData() {
    dateController.text = '';
    staffController.text = '';
    descriptionController.text = '';
    sendEmailReminder = false;
    noteController.text = '';
    leadContacted = false;
  }
}
