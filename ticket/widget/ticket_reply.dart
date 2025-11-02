import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/features/ticket/model/ticket_details_model.dart';
import 'package:flutter/material.dart';

class TicketReplies extends StatelessWidget {
  const TicketReplies({
    super.key,
    required this.reply,
  });
  final TicketReply reply;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Converter.parseHtmlString(reply.message ?? ''),
            style: regularDefault,
          ),
          reply.attachments?.isNotEmpty ?? false
              ? Padding(
                  padding: const EdgeInsets.only(top: Dimensions.space5),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                            imageUrl:
                                '${UrlContainer.ticketAttachmentUrl}/${reply.attachments![index].id}/${reply.attachments![index].fileName}',
                            height: 200,
                            errorWidget: (ctx, object, trx) {
                              return Image.asset(MyImages.noDataFound,
                                  height: 30);
                            },
                            placeholder: (ctx, trx) {
                              return Image.asset(
                                MyImages.noDataFound,
                                height: 30,
                                color: Colors.grey,
                              );
                            });
                      },
                      itemCount: reply.attachments!.length),
                )
              : const SizedBox.shrink(),
          const CustomDivider(space: Dimensions.space10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextIcon(
                  text: reply.submitter ?? '', icon: Icons.account_box_rounded),
              TextIcon(
                  text: DateConverter.formatValidityDate(reply.date ?? ''),
                  icon: Icons.calendar_month),
            ],
          )
        ],
      ),
    );
  }
}
