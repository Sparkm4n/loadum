import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';

import '../../../core/helper/shared_preference_helper.dart';

class OnBoardIntroScreen extends StatefulWidget {
  const OnBoardIntroScreen({super.key});

  @override
  State<OnBoardIntroScreen> createState() => _OnBoardIntroScreenState();
}

class _OnBoardIntroScreenState extends State<OnBoardIntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageID = 0;

  ApiClient get _api =>
      Get.isRegistered<ApiClient>()
          ? Get.find<ApiClient>()
          : Get.put(ApiClient(sharedPreferences: Get.find()));

  Future<void> _finish() async {
    await _api.sharedPreferences.setBool(SharedPreferenceHelper.onboardKey, true);
    Get.offAllNamed(RouteHelper.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Responsive Abstände/Höhen
    final size = MediaQuery.sizeOf(context);
    final topPad = size.height * 0.08;
    const footerGuard = 140.0;
    final lottieH = size.height < 700 ? size.height * 0.22 : size.height * 0.26;

    final totalPages = introKey.currentState?.getPagesLength() ?? 3;
    final isLast = (currentPageID + 1) == totalPages;

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        allowImplicitScrolling: true,
        infiniteAutoScroll: false,
        curve: Curves.fastLinearToSlowEaseIn,
        globalBackgroundColor: theme.scaffoldBackgroundColor,

        // Abstand Body (oben/unten), damit Footer nicht überlappt
        bodyPadding: const EdgeInsets.symmetric(horizontal: 16)
            .copyWith(top: topPad, bottom: footerGuard),

        // Brand-Header: Logo + LOADUM + Skip
        globalHeader: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, Dimensions.space50, 16, 8),
          child: Row(
            children: [
              Image.asset(MyImages.appLogo, height: Dimensions.space60, fit: BoxFit.contain),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'LOADUM',
                  // CRM for Cleaning Companies
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: _finish,
                child: Text(
                  'Skip',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Dots passend zum Theme
        dotsFlex: 1,
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 5.0),
          activeSize: const Size(Dimensions.space20, Dimensions.space5),
          color: theme.dividerColor.withOpacity(.35),
          activeColor: cs.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.space3),
          ),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.space3),
          ),
        ),

        // Default-Steuerung ausblenden (eigener Footer-CTA)
        showDoneButton: false,
        showBackButton: false,
        showNextButton: false,
        showSkipButton: false,

        onChange: (v) => setState(() => currentPageID = v),

        // Seiten – Texte aus LocalStrings (bleiben translations-fähig)
        pages: [
          PageViewModel(
            useScrollView: true,
            title: LocalStrings.onboardTitle1.tr,      // z.B. „Schedule & assign in minutes”
            body:  LocalStrings.onboardSubTitle1.tr,   // z.B. „Create jobs...“
            image: SizedBox(height: lottieH, child: Lottie.asset(MyImages.onboardingOne)),
            decoration: _pageDecoration(context),
          ),
          PageViewModel(
            useScrollView: true,
            title: LocalStrings.onboardTitle2.tr,      // z.B. „Quotes, invoices & payments—together”
            body:  LocalStrings.onboardSubTitle2.tr,
            image: SizedBox(height: lottieH, child: Lottie.asset(MyImages.onboardingTwo)),
            decoration: _pageDecoration(context),
          ),
          PageViewModel(
            useScrollView: true,
            title: LocalStrings.onboardTitle3.tr,      // z.B. „Delight clients, grow referrals”
            body:  LocalStrings.onboardSubTitle3.tr,
            image: SizedBox(height: lottieH, child: Lottie.asset(MyImages.onboardingThree)),
            decoration: _pageDecoration(context),
          ),
        ],

        // Footer: CTA + Links (Login / Privacy)
        globalFooter: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25),
              child: RoundedButton(
                text: isLast ? LocalStrings.getStarted.tr : LocalStrings.next.tr,
                cornerRadius: Dimensions.space10,
                press: () async {
                  final current = introKey.currentState!.getCurrentPage();
                  final lastIdx = introKey.currentState!.getPagesLength() - 1;
                  if (current >= lastIdx) {
                    await _finish();
                  } else {
                    introKey.currentState!.next();
                  }
                },
              ),
            ),
            const SizedBox(height: Dimensions.space5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.offAllNamed(RouteHelper.loginScreen),
                    child: Text(
                      'I already have an account',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('•', style: theme.textTheme.labelLarge),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Get.toNamed(RouteHelper.privacyScreen),
                    child: Text(
                      'Privacy & terms',
                      style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space5),
            const CustomDivider(),
          ],
        ),
      ),
    );
  }

  PageDecoration _pageDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PageDecoration(
      imageFlex: 5,
      bodyFlex: 4,
      titleTextStyle: theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w800,
        color: cs.primary,
        height: 1.15,
      ),
      bodyTextStyle: theme.textTheme.bodyMedium!.copyWith(height: 1.45),
      titlePadding: const EdgeInsets.symmetric(
        vertical: Dimensions.space5,
        horizontal: Dimensions.space15,
      ),
      bodyAlignment: Alignment.topLeft,
      bodyPadding: const EdgeInsets.symmetric(
        vertical: Dimensions.space5,
        horizontal: Dimensions.space15,
      ),
    );
  }
}
