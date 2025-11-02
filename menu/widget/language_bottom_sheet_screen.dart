import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/common/controllers/localization_controller.dart';
import 'package:flutex_admin/features/menu/widget/language_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageBottomSheetScreen extends StatefulWidget {
  final String languageList;
  final Locale selectedLocal;
  final bool? fromSplash;
  const LanguageBottomSheetScreen(
      {super.key,
      required this.languageList,
      required this.selectedLocal,
      this.fromSplash = false});

  @override
  State<LanguageBottomSheetScreen> createState() =>
      _LanguageBottomSheetScreenState();
}

class _LanguageBottomSheetScreenState extends State<LanguageBottomSheetScreen> {
  @override
  void initState() {
    final controller =
        Get.put(LocalizationController(sharedPreferences: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadCurrentLanguage();
      ();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (languageController) {
      return Center(
          child: Column(
        children: [
          const SizedBox(height: Dimensions.space10),
          const BottomSheetBar(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              LocalStrings.selectLanguage.tr,
              style: mediumExtraLarge.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
          LanguageBody(langList: LocalStrings.appLanguages),
        ],
      ));
    });
  }
}
