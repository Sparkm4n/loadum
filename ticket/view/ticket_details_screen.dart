import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/dialog/warning_dialog.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/ticket/controller/ticket_controller.dart';
import 'package:flutex_admin/features/ticket/repo/ticket_repo.dart';
import 'package:flutex_admin/features/ticket/widget/ticket_reply.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TicketRepo(apiClient: Get.find()));
    final controller = Get.put(TicketController(ticketRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadTicketDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.ticketDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateTicketScreen, arguments: widget.id);
          },
          icon: const Icon(
            Icons.edit,
            size: 20,
          ),
        ),
        actionWidgetTwo: IconButton(
          onPressed: () {
            const WarningAlertDialog().warningAlertDialog(context, () {
              Get.back();
              Get.find<TicketController>().deleteTicket(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteTicket.tr,
                subTitle: LocalStrings.deleteTicketWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<TicketController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadTicketDetails(widget.id);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#${controller.ticketDetailsModel.data?.id} - ${controller.ticketDetailsModel.data?.subject}',
                                style: mediumLarge,
                              ),
                              Text(
                                controller.ticketDetailsModel.data?.statusName
                                        ?.tr.capitalize ??
                                    '',
                                style: mediumDefault.copyWith(
                                    color: ColorResources.ticketStatusColor(
                                        controller.ticketDetailsModel.data
                                                ?.status ??
                                            '')),
                              )
                            ],
                          ),
                          const SizedBox(height: Dimensions.space10),
                          CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LocalStrings.contact.tr,
                                    style: lightSmall),
                                Text(
                                    '${controller.ticketDetailsModel.data?.firstName ?? ''} ${controller.ticketDetailsModel.data?.lastName} (${controller.ticketDetailsModel.data?.company ?? ''})',
                                    style: regularDefault),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LocalStrings.department.tr,
                                        style: lightSmall),
                                    Text(LocalStrings.service.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        controller.ticketDetailsModel.data
                                                ?.departmentName ??
                                            '-',
                                        style: regularDefault),
                                    Text(
                                        controller.ticketDetailsModel.data
                                                ?.serviceName ??
                                            '-',
                                        style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LocalStrings.submitted.tr,
                                        style: lightSmall),
                                    Text(LocalStrings.priority.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        DateConverter.formatValidityDate(
                                            controller.ticketDetailsModel.data!
                                                    .date ??
                                                ''),
                                        style: regularDefault),
                                    Text(
                                        controller.ticketDetailsModel.data
                                                ?.priorityName ??
                                            '-',
                                        style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Text(LocalStrings.description.tr,
                                    style: lightSmall),
                                Text(
                                    Converter.parseHtmlString(controller
                                            .ticketDetailsModel.data?.message ??
                                        '-'),
                                    maxLines: 2,
                                    style: regularDefault),
                              ],
                            ),
                          ),
                          if (controller.ticketDetailsModel.data?.ticketReplies
                                  ?.isNotEmpty ??
                              false) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space5,
                                  vertical: Dimensions.space15),
                              child: TextIcon(
                                text: LocalStrings.ticketReplies.tr,
                                textStyle: regularDefault,
                                icon: Icons.comment_outlined,
                              ),
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return TicketReplies(
                                    reply: controller.ticketDetailsModel.data!
                                        .ticketReplies![index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: Dimensions.space10),
                                itemCount: controller.ticketDetailsModel.data!
                                    .ticketReplies!.length)
                          ]
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
