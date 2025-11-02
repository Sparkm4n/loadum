import 'dart:convert';

import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/controllers/localization_controller.dart';
import 'package:flutex_admin/common/models/language_model.dart';
import 'package:flutex_admin/features/dashboard/repo/dashboard_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/core/helper/shared_preference_helper.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';

class LanguageBody extends StatefulWidget {
  final List<LanguageModel> langList;

  const LanguageBody({super.key, required this.langList});

  @override
  State<LanguageBody> createState() => _LanguageBodyState();
}

class _LanguageBodyState extends State<LanguageBody> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.langList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              setState(() {
                selectedIndex = index;
              });
              String languageCode = widget.langList[index].languageCode;
              final repo = Get.put(DashboardRepo(apiClient: Get.find()));
              final localizationController = Get.put(
                  LocalizationController(sharedPreferences: Get.find()));
              Map<String, Map<String, String>> language = {};
              final String response =
                  await rootBundle.loadString('assets/lang/$languageCode.json');
              var resJson = jsonDecode(response);
              await repo.apiClient.sharedPreferences.setString(
                  SharedPreferenceHelper.languageListKey, languageCode);

              var value = resJson as Map<String, dynamic>;
              Map<String, String> json = {};
              value.forEach((key, value) {
                json[key] = value.toString();
              });

              language['${widget.langList[index].languageCode}_${'US'}'] = json;

              Get.clearTranslations();
              Get.addTranslations(Messages(languages: language).keys);

              Locale local = Locale(widget.langList[index].languageCode, 'US');
              localizationController.setLanguage(local);

              Get.back();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15, horizontal: Dimensions.space15),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(Dimensions.defaultRadius)),
              child: Row(
                children: [
                  Image.asset(
                    widget.langList[index].languageFlag,
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(width: Dimensions.space15),
                  Text(
                    (widget.langList[index].languageName).tr,
                    style: regularLarge.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
