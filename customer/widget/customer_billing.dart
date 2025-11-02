import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/customer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerBilling extends StatelessWidget {
  const CustomerBilling({
    super.key,
    required this.customerModel,
  });

  final Customer customerModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Helpers
    String _s(String? v) => (v == null || v.trim().isEmpty) ? '-' : v.trim();
    bool _eq(String? a, String? b) => (a ?? '').trim() == (b ?? '').trim();

    // Billing (korrekte Felder)
    final bStreet  = customerModel.billingStreet;
    final bCity    = customerModel.billingCity;
    final bState   = customerModel.billingState;
    final bZip     = customerModel.billingZip;
    final bCountry = customerModel.billingCountry;

    // Shipping (optional für Cleaning; wird nur gezeigt, wenn anders als Billing)
    final sStreet  = customerModel.shippingStreet;
    final sCity    = customerModel.shippingCity;
    final sState   = customerModel.shippingState;
    final sZip     = customerModel.shippingZip;
    final sCountry = customerModel.shippingCountry;

    final shippingProvided = [
      sStreet, sCity, sState, sZip, sCountry?.toString()
    ].any((v) => (v ?? '').trim().isNotEmpty);

    final shippingEqualsBilling =
        _eq(bStreet, sStreet) &&
            _eq(bCity, sCity) &&
            _eq(bState, sState) &&
            _eq(bZip, sZip) &&
            _eq(bCountry?.toString(), sCountry?.toString());

    return Padding(
      padding: const EdgeInsets.all(Dimensions.space10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // BILLING
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.space10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TitleRow(
                    icon: Icons.receipt_long_outlined,
                    title: LocalStrings.billingAddress.tr,
                  ),
                  const SizedBox(height: 8),
                  _KV(label: LocalStrings.address.tr, value: _s(bStreet), dense: true),
                  const SizedBox(height: 4),
                  _TwoColKV(
                    leftLabel: LocalStrings.city.tr,
                    leftValue: _s(bCity),
                    rightLabel: LocalStrings.state.tr,
                    rightValue: _s(bState),
                  ),
                  const SizedBox(height: 8),
                  const CustomDivider(),
                  const SizedBox(height: 8),
                  _TwoColKV(
                    leftLabel: LocalStrings.zipCode.tr,
                    leftValue: _s(bZip),
                    rightLabel: LocalStrings.country.tr,
                    rightValue: _s(bCountry?.toString()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // SHIPPING – nur zeigen wenn sinnvoll
          if (shippingProvided && !shippingEqualsBilling)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TitleRow(
                      icon: Icons.local_shipping_outlined,
                      title: LocalStrings.shippingAddress.tr,
                    ),
                    const SizedBox(height: 8),
                    _KV(label: LocalStrings.address.tr, value: _s(sStreet), dense: true),
                    const SizedBox(height: 4),
                    _TwoColKV(
                      leftLabel: LocalStrings.city.tr,
                      leftValue: _s(sCity),
                      rightLabel: LocalStrings.state.tr,
                      rightValue: _s(sState),
                    ),
                    const SizedBox(height: 8),
                    const CustomDivider(),
                    const SizedBox(height: 8),
                    _TwoColKV(
                      leftLabel: LocalStrings.zipCode.tr,
                      leftValue: _s(sZip),
                      rightLabel: LocalStrings.country.tr,
                      rightValue: _s(sCountry?.toString()),
                    ),
                  ],
                ),
              ),
            )
          else
          // Hinweis: Shipping = Billing (Cleaning-typisch)
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        // Klarer, freundlicher Hinweistext
                        'Shipping is the same as billing for this customer.',
                        style: lightDefault.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* —————— kleine, wiederverwendbare UI-Bausteine —————— */

class _TitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  const _TitleRow({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: regularLarge.copyWith(color: theme.colorScheme.primary),
        ),
      ],
    );
  }
}

class _KV extends StatelessWidget {
  final String label;
  final String value;
  final bool dense;
  const _KV({required this.label, required this.value, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: lightSmall.copyWith(color: theme.hintColor)),
        const SizedBox(height: 2),
        Text(
          value,
          style: dense ? regularSmall : regularDefault,
        ),
      ],
    );
  }
}

class _TwoColKV extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const _TwoColKV({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _KV(label: leftLabel, value: leftValue)),
        const SizedBox(width: 12),
        Expanded(child: _KV(label: rightLabel, value: rightValue)),
      ],
    );
  }
}
