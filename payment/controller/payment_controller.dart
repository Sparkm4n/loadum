import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/payment/model/payment_details_model.dart';
import 'package:flutex_admin/features/payment/model/payment_model.dart';
import 'package:flutex_admin/features/payment/repo/payment_repo.dart';

class PaymentController extends GetxController {
  final PaymentRepo paymentRepo;
  PaymentController({required this.paymentRepo});

  /// UI-States
  bool isLoading = true;        // für Listenansicht
  bool detailsLoading = false;  // für Detailansicht
  bool isSearch = false;

  /// Daten
  PaymentsModel paymentsModel = PaymentsModel();
  PaymentDetailsModel paymentDetailsModel = PaymentDetailsModel();

  /// Suche
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // ===================== Lifecycle =====================

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad;
    update();
    await loadPayments(showSpinner: false);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // ===================== API Calls =====================

  Future<void> loadPayments({bool showSpinner = true}) async {
    if (showSpinner) {
      isLoading = true;
      update();
    }

    final ResponseModel res = await paymentRepo.getAllPayments();

    if (res.status) {
      final map = _decodeJsonMap(res.responseJson);
      if (map != null) {
        try {
          paymentsModel = PaymentsModel.fromJson(map);
        } catch (e) {
          CustomSnackBar.error(errorList: ['Payments parsing failed: $e']);
        }
      } else {
        CustomSnackBar.error(errorList: ['Payments: unexpected response format.']);
      }
    } else {
      _showApiError(res);
    }

    isLoading = false;
    update();
  }

  Future<void> loadPaymentDetails(String paymentId) async {
    detailsLoading = true;
    update();

    final ResponseModel res = await paymentRepo.getPaymentDetails(paymentId);

    if (res.status) {
      final map = _decodeJsonMap(res.responseJson);
      if (map != null) {
        try {
          paymentDetailsModel = PaymentDetailsModel.fromJson(map);
        } catch (e) {
          CustomSnackBar.error(errorList: ['Payment details parsing failed: $e']);
        }
      } else {
        CustomSnackBar.error(errorList: ['Payment details: unexpected response format.']);
      }
    } else {
      _showApiError(res);
    }

    detailsLoading = false;
    update();
  }

  // ===================== Search =====================

  Future<void> searchPayment() async {
    final q = searchController.text.trim();

    // Leeres Suchfeld -> komplette Liste
    if (q.isEmpty) {
      await loadPayments(showSpinner: false);
      return;
    }

    // leichtes Debounce, um Spam-Requests zu vermeiden
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      isLoading = true;
      update();

      final ResponseModel res = await paymentRepo.searchPayment(q);

      if (res.status) {
        final map = _decodeJsonMap(res.responseJson);
        if (map != null) {
          try {
            paymentsModel = PaymentsModel.fromJson(map);
          } catch (e) {
            CustomSnackBar.error(errorList: ['Search parsing failed: $e']);
          }
        } else {
          CustomSnackBar.error(errorList: ['Search: unexpected response format.']);
        }
      } else {
        _showApiError(res);
      }

      isLoading = false;
      update();
    });
  }

  void changeSearchIcon() {
    isSearch = !isSearch;
    update();

    if (!isSearch) {
      searchController.clear();
      loadPayments(showSpinner: false);
    }
  }

  // ===================== Helpers =====================

  Map<String, dynamic>? _decodeJsonMap(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      // manche Backends liefern { "data": [...] } – hier ggf. auspacken:
      if (decoded is List) return {'data': decoded};
      return null;
    } catch (_) {
      return null;
    }
  }

  void _showApiError(ResponseModel res) {
    // Wir haben nur `message` sicher verfügbar – zeig diese an.
    final msg = (res.message ?? 'Request failed');
    CustomSnackBar.error(errorList: [msg]);
  }
}
