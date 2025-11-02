import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/item/model/item_details_model.dart';
import 'package:flutex_admin/features/item/model/item_model.dart';
import 'package:flutex_admin/features/item/repo/item_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  ItemRepo itemRepo;
  ItemController({required this.itemRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  ItemsModel itemsModel = ItemsModel();
  ItemDetailsModel itemDetailsModel = ItemDetailsModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadItems();
    isLoading = false;
    update();
  }

  Future<void> loadItems() async {
    ResponseModel responseModel = await itemRepo.getAllItems();
    if (responseModel.status) {
      itemsModel = ItemsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadItemDetails(itemId) async {
    ResponseModel responseModel = await itemRepo.getItemDetails(itemId);
    if (responseModel.status) {
      itemDetailsModel =
          ItemDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  // Search Items
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchItem() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await itemRepo.searchItem(keysearch);
    if (responseModel.status) {
      itemsModel = ItemsModel.fromJson(jsonDecode(responseModel.responseJson));
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
}
