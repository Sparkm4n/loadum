import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/dashboard/model/dashboard_model.dart';
import 'package:flutex_admin/features/dashboard/widget/custom_linerprogress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeEstimatesCard extends StatelessWidget {
  const HomeEstimatesCard({
    super.key,
    required this.estimates,
  });

  final List<DataField>? estimates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = estimates ?? const <DataField>[];

    // Summe für stabile Prozent-Berechnung (Fallback, falls percent fehlt/korrupt ist)
    final total = items.fold<int>(
      0,
          (sum, e) => sum + (int.tryParse(e.total ?? '') ?? 0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.space5,
        vertical: Dimensions.space5,
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.space15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
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
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add_chart_outlined,
                  size: 20, color: theme.primaryColor),
              label: Text(
                '${LocalStrings.estimates.tr} ${LocalStrings.overview.tr}',
                style:
                regularLarge.copyWith(color: theme.primaryColor),
              ),
            ),
            const CustomDivider(space: Dimensions.space5),
            const SizedBox(height: Dimensions.space10),

            // >>> WICHTIG: Expanded + ListView => kein Bottom-Overflow mehr
            Expanded(
              child: items.isEmpty
                  ? Center(
                child: Text(
                  LocalStrings.noDataFound.tr,
                  style: theme.textTheme.bodyMedium,
                ),
              )
                  : ListView.separated(
                // weiche Scroll-Physik, nutzt die verfügbare Höhe
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space10),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: Dimensions.space2),
                itemBuilder: (context, index) {
                  final e = items[index];

                  // Status/Name
                  final name = e.status?.tr ?? '';

                  // Farbe je Status
                  final color = ColorResources.estimateTextStatusColor(
                    e.status.toString(),
                  );

                  // Prozent robust: erst percent-Feld, ansonsten aus total/gesamt
                  double pct =
                      double.tryParse(e.percent ?? '') ?? -1.0;
                  if (pct > 1.0) pct = pct / 100.0;
                  if (pct < 0.0) {
                    final v = int.tryParse(e.total ?? '') ?? 0;
                    pct = total > 0 ? (v / total) : 0.0;
                  }
                  pct = pct.clamp(0.0, 1.0);

                  final data = (int.tryParse(e.total ?? '') ?? 0).toString();

                  return CustomLinerProgress(
                    name: name,
                    color: color,
                    value: pct,         // 0..1
                    data: data,         // z.B. "12"
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
