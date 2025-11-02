import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/project/model/project_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.index,
    required this.projectModel,
  });
  final int index;
  final ProjectsModel projectModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.projectDetailsScreen,
            arguments: projectModel.data![index].id!);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        ),
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.projectStatusColor(
                      projectModel.data![index].status!),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          projectModel.data![index].name ?? '',
                          style: regularDefault,
                        ),
                        Container(
                            padding: const EdgeInsets.all(Dimensions.space5),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.cardRadius),
                                side: BorderSide(
                                    color: ColorResources.projectStatusColor(
                                        projectModel.data![index].status!)),
                              ),
                            ),
                            child: Text(
                              Converter.projectStatusString(
                                  projectModel.data![index].status ?? ''),
                              style: lightSmall.copyWith(
                                  color: ColorResources.projectStatusColor(
                                      projectModel.data![index].status ?? '')),
                            ))
                      ],
                    ),
                    const SizedBox(height: Dimensions.space5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Text(
                            Converter.parseHtmlString(
                                projectModel.data![index].description ?? ''),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: Dimensions.fontDefault,
                                color: ColorResources.blueGreyColor),
                          ),
                        ),
                        if (projectModel.data![index].deadline != null)
                          Text(
                            '${projectModel.data![index].progress!}%',
                            style: const TextStyle(
                                fontSize: Dimensions.fontDefault,
                                color: ColorResources.blueGreyColor),
                          ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space5),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                          minHeight: Dimensions.space8,
                          value: double.parse(
                                  projectModel.data![index].progress!) *
                              0.01,
                          color: ColorResources.projectStatusColor(
                              projectModel.data![index].status!),
                          backgroundColor: ColorResources.lightBlueGreyColor),
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: projectModel.data![index].startDate ?? '',
                          icon: Icons.calendar_month,
                        ),
                        TextIcon(
                          text: projectModel.data![index].company ?? '',
                          icon: Icons.business_center_outlined,
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
