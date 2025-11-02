import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/proposal/model/proposal_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProposalCard extends StatelessWidget {
  const ProposalCard({
    super.key,
    required this.index,
    required this.proposalModel,
  });
  final int index;
  final ProposalsModel proposalModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.proposalDetailsScreen,
            arguments: proposalModel.data![index].id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.proposalStatusColor(
                      proposalModel.data![index].status!),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Text(
                            proposalModel.data![index].subject ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${proposalModel.data![index].total} ${proposalModel.data![index].currencyName}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: Dimensions.space5),
                            Text(
                              Converter.proposalStatusString(
                                  proposalModel.data![index].status ?? ''),
                              style: lightDefault.copyWith(
                                  color: ColorResources.proposalStatusColor(
                                      proposalModel.data![index].status!)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: proposalModel.data![index].proposalTo ?? '',
                          icon: Icons.account_box_rounded,
                        ),
                        TextIcon(
                          text: proposalModel.data![index].date ?? '',
                          icon: Icons.calendar_month,
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
