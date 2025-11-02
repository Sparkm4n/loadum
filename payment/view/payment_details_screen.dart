import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/header_text.dart';

import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';

import 'package:flutex_admin/features/payment/controller/payment_controller.dart';
import 'package:flutex_admin/features/payment/repo/payment_repo.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  @override
  void initState() {
    super.initState();

    // DI sicherstellen (nicht doppelt registrieren)
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<PaymentRepo>()) {
      Get.put(PaymentRepo(apiClient: Get.find()));
    }
    if (!Get.isRegistered<PaymentController>()) {
      Get.put(PaymentController(paymentRepo: Get.find()));
    }

    final c = Get.find<PaymentController>();
    c.detailsLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.loadPaymentDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.paymentDetails.tr),
      body: GetBuilder<PaymentController>(
        builder: (c) {
          // Loading-State für Detailabruf
          if (c.detailsLoading) {
            return const CustomLoader();
          }

          final data = c.paymentDetailsModel.data;
          final hasData = data != null;

          return RefreshIndicator(
            color: cs.primary,
            backgroundColor: theme.cardColor,
            onRefresh: () => c.loadPaymentDetails(widget.id),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.space10),
              child: hasData
                  ? Container(
                margin: const EdgeInsets.only(bottom: Dimensions.space10),
                padding: const EdgeInsets.all(Dimensions.space15),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius:
                  BorderRadius.circular(Dimensions.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.06),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeaderText(
                          text: LocalStrings.paymentReceipt.tr,
                          textStyle: mediumExtraLarge,
                        ),
                        _StatusChip(
                          isActive:
                          (data!.active ?? '0').toString() == '1',
                        ),
                      ],
                    ),

                    const CustomDivider(space: Dimensions.space10),

                    // Body Infos in klarer Hierarchie
                    _InfoRow(
                      label: LocalStrings.paymentMode.tr,
                      value: data!.name ?? '-',
                    ),
                    _InfoRow(
                      label: LocalStrings.paymentDate.tr,
                      value: data.date ?? '-',
                    ),
                    _InfoRow(
                      label: LocalStrings.invoice.tr,
                      value: (data.invoiceId == null ||
                          data.invoiceId.toString().isEmpty)
                          ? '-'
                          : '#${data.invoiceId}',
                    ),
                    _InfoRow(
                      label: LocalStrings.transactionId.tr,
                      value: data.transactionId?.toString() ?? '-',
                    ),

                    const SizedBox(height: Dimensions.space20),

                    // Amount Card (Branding Fläche)
                    Center(
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 1.5,
                        height: Dimensions.space90,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(
                              Dimensions.groupCardRadius),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              cs.primary,
                              cs.secondary.withOpacity(.65),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocalStrings.totalAmount.tr,
                              style: lightLarge.copyWith(
                                  color: Colors.white),
                            ),
                            const SizedBox(height: Dimensions.space5),
                            Text(
                              data.amount?.toString() ?? '-',
                              style: regularExtraLarge.copyWith(
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : _EmptyState(
                onRetry: () => c.loadPaymentDetails(widget.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Kleine Status-Pille „Aktiv/Inactive“
class _StatusChip extends StatelessWidget {
  final bool isActive;
  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? ColorResources.greenColor
        : ColorResources.blueColor; // beibehaltene App-Farben

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.space10,
        vertical: Dimensions.space5,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          side: BorderSide(color: color),
        ),
      ),
      child: Text(
        isActive ? LocalStrings.active.tr : LocalStrings.notActive.tr,
        style: lightSmall.copyWith(color: color),
      ),
    );
  }
}

/// Standardisierte Label/Value-Zeile mit Abstand
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: Dimensions.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: lightDefault),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyMedium ?? regularDefault),
        ],
      ),
    );
  }
}

/// Leerer Zustand, wenn keine Zahlungsdaten geliefert wurden
class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: Dimensions.space20),
      padding: const EdgeInsets.all(Dimensions.space20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Dimensions.cardRadius),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long, size: 40, color: theme.disabledColor),
          const SizedBox(height: Dimensions.space10),
          Text(
            LocalStrings.noDataFound.tr,
            style:
            theme.textTheme.titleMedium?.copyWith(color: theme.disabledColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.space10),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            // ALT: Text(LocalStrings.tryAgain.tr),
            label: const Text('Erneut laden'),
          ),

        ],
      ),
    );
  }
}
