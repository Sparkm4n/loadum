import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/expense/model/expense_category_model.dart';
import 'package:flutex_admin/features/expense/model/expense_details_model.dart';
import 'package:flutex_admin/features/expense/model/expense_model.dart';
import 'package:flutex_admin/features/expense/model/expense_post_model.dart';
import 'package:flutex_admin/features/expense/repo/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  ExpenseRepo expenseRepo;
  ExpenseController({required this.expenseRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  ExpenseModel expenseModel = ExpenseModel();
  ExpenseDetailsModel expenseDetailsModel = ExpenseDetailsModel();
  CustomersModel customersModel = CustomersModel();
  ExpenseCategoryModel expenseCategoryModel = ExpenseCategoryModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadExpenses();
    isLoading = false;
    update();
  }

  Future<void> loadExpenses() async {
    ResponseModel responseModel = await expenseRepo.getAllExpenses();
    if (responseModel.status) {
      expenseModel = ExpenseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadExpenseDetails(expenseId) async {
    ResponseModel responseModel = await expenseRepo.getExpenseDetails(
      expenseId,
    );
    if (responseModel.status) {
      expenseDetailsModel = ExpenseDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  // Search Expenses
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchExpense() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await expenseRepo.searchExpense(keysearch);
    if (responseModel.status) {
      expenseModel = ExpenseModel.fromJson(
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

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await expenseRepo.getAllCustomers();
    return customersModel = CustomersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<ExpenseCategoryModel> loadExpenseCategory() async {
    ResponseModel responseModel = await expenseRepo.getExpenseCategory();
    return expenseCategoryModel = ExpenseCategoryModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadExpenseUpdateData(expenseId) async {
    ResponseModel responseModel = await expenseRepo.getExpenseDetails(
      expenseId,
    );
    if (responseModel.status) {
      expenseDetailsModel = ExpenseDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      nameController.text = expenseDetailsModel.data?.expenseName ?? '';
      noteController.text = expenseDetailsModel.data?.note ?? '';
      categoryController.text = expenseDetailsModel.data?.category ?? '';
      dateController.text = expenseDetailsModel.data?.date ?? '';
      amountController.text = expenseDetailsModel.data?.amount ?? '';
      customerIdController.text = expenseDetailsModel.data?.clientid ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode noteFocusNode = FocusNode();
  FocusNode categoryFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode customerIdFocusNode = FocusNode();

  Future<void> submitExpense({String? expenseId, bool isUpdate = false}) async {
    String name = nameController.text.toString();
    String note = noteController.text.toString();
    String category = categoryController.text.toString();
    String date = dateController.text.toString();
    String amount = amountController.text.toString();
    String customerId = customerIdController.text.toString();

    if (category.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.expenseCategory.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }
    if (date.isEmpty) {
      CustomSnackBar.error(
        errorList: ['${LocalStrings.date.tr} ${LocalStrings.isRequired.tr}'],
      );
      return;
    }
    if (amount.isEmpty) {
      CustomSnackBar.error(
        errorList: ['${LocalStrings.amount.tr} ${LocalStrings.isRequired.tr}'],
      );
      return;
    }

    isSubmitLoading = true;
    update();

    ExpensePostModel expenseModel = ExpensePostModel(
      name: name,
      note: note,
      category: category,
      date: date,
      amount: amount,
      customerId: customerId,
    );

    ResponseModel responseModel = await expenseRepo.createExpense(
      expenseModel,
      expenseId: expenseId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      Get.back();
      if (isUpdate) await loadExpenseDetails(expenseId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
      return;
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Expense
  Future<void> deleteExpense(expenseId) async {
    ResponseModel responseModel = await expenseRepo.deleteExpense(expenseId);

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

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    nameController.text = '';
    noteController.text = '';
    categoryController.text = '';
    dateController.text = '';
    amountController.text = '';
    customerIdController.text = '';
  }
}
