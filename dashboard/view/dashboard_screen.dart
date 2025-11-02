import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutex_admin/common/components/app-bar/action_button_icon_widget.dart';
import 'package:flutex_admin/common/components/circle_image_button.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/will_pop_widget.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutex_admin/features/dashboard/model/dashboard_model.dart';
import 'package:flutex_admin/features/dashboard/repo/dashboard_repo.dart';
import 'package:flutex_admin/features/dashboard/widget/dashboard_card.dart';
import 'package:flutex_admin/features/dashboard/widget/drawer.dart';
import 'package:flutex_admin/features/dashboard/widget/home_estimates_card.dart';
import 'package:flutex_admin/features/dashboard/widget/home_invoices_card.dart';
import 'package:flutex_admin/features/dashboard/widget/home_proposals_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<DashboardRepo>()) {
      Get.put(DashboardRepo(apiClient: Get.find()));
    }
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController(dashboardRepo: Get.find()));
    }

    final controller = Get.find<DashboardController>();
    controller.isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return WillPopWidget(
      nextRoute: '',
      child: GetBuilder<DashboardController>(builder: (controller) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 56,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, size: 28, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
            centerTitle: true,
            title: _LogoTitle(url: controller.homeModel.overview?.perfexLogo),
            actions: [
              // Settings öffnet IMMER die Settings-Route (nicht das Drawer-Menü)
              ActionButtonIconWidget(
                pressed: () {
                  final scaffold = Scaffold.maybeOf(context);
                  if (scaffold?.isDrawerOpen ?? false) {
                    Navigator.of(context).pop();
                  }
                  if (Get.currentRoute != RouteHelper.settingsScreen) {
                    Get.toNamed(RouteHelper.settingsScreen);
                  }
                },
                icon: Icons.settings,
                size: 32,
                iconColor: Colors.white,
              ),
            ],
            backgroundColor: cs.primary,
            elevation: 0,
          ),

          drawer: HomeDrawer(homeModel: controller.homeModel),

          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
            color: theme.primaryColor,
            backgroundColor: theme.cardColor,
            onRefresh: () async => controller.initialData(shouldLoad: false),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.space10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WelcomeCard(
                    name:
                    '${controller.homeModel.staff?.firstName ?? ''} ${controller.homeModel.staff?.lastName ?? ''}'.trim(),
                    email: controller.homeModel.staff?.email ?? '',
                    avatarUrl: controller.homeModel.staff?.profileImage ?? '',
                  ),
                  const SizedBox(height: Dimensions.space10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashboardCard(
                        currentValue: controller.homeModel.overview?.invoicesAwaitingPaymentTotal ?? '0',
                        totalValue: controller.homeModel.overview?.totalInvoices ?? '0',
                        percent: controller.homeModel.overview?.invoicesAwaitingPaymentPercent ?? '0',
                        icon: Icons.attach_money_rounded,
                        title: LocalStrings.invoicesAwaitingPayment.tr,
                      ),
                      DashboardCard(
                        currentValue: controller.homeModel.overview?.leadsConvertedTotal ?? '0',
                        totalValue: controller.homeModel.overview?.totalLeads ?? '0',
                        percent: controller.homeModel.overview?.leadsConvertedPercent ?? '0',
                        icon: Icons.move_up_rounded,
                        title: LocalStrings.convertedLeads.tr,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DashboardCard(
                        currentValue: controller.homeModel.overview?.notFinishedTasksTotal ?? '0',
                        totalValue: controller.homeModel.overview?.totalTasks ?? '0',
                        percent: controller.homeModel.overview?.notFinishedTasksPercent ?? '0',
                        icon: Icons.task_outlined,
                        title: LocalStrings.notCompleted.tr,
                      ),
                      DashboardCard(
                        currentValue: controller.homeModel.overview?.projectsInProgressTotal ?? '0',
                        totalValue: controller.homeModel.overview?.totalProjects ?? '0',
                        percent: controller.homeModel.overview?.inProgressProjectsPercent ?? '0',
                        icon: Icons.dashboard_customize_rounded,
                        title: LocalStrings.projectsInProgress.tr,
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.space10),
                  _CarouselSection(controller: controller),

                  const SizedBox(height: Dimensions.space15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                    child: Row(
                      children: [
                        Icon(Icons.menu_open_rounded, size: 20, color: cs.primary),
                        const SizedBox(width: Dimensions.space10),
                        Text(
                          LocalStrings.projectStatistics.tr,
                          style: regularLarge.copyWith(color: cs.primary),
                        ),
                      ],
                    ),
                  ),
                  const CustomDivider(space: Dimensions.space5, padding: Dimensions.space15),
                  _ProjectsDonut(
                    data: controller.homeModel.data?.projects ?? const [],
                    tooltip: _tooltip,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _LogoTitle extends StatelessWidget {
  final String? url;
  const _LogoTitle({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Image.asset(MyImages.appLogoWhite, height: 30, fit: BoxFit.contain);
    }
    return CachedNetworkImage(
      imageUrl: url!,
      height: 30,
      fit: BoxFit.contain,
      placeholder: (context, _url) =>
          Image.asset(MyImages.appLogoWhite, height: 30, fit: BoxFit.contain),
      errorWidget: (context, _url, error) =>
          Image.asset(MyImages.appLogoWhite, height: 30, fit: BoxFit.contain),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;
  const _WelcomeCard({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorResources.blueGreyColor,
            radius: 32,
            child: CircleImageWidget(
              imagePath: avatarUrl,
              isAsset: false,
              isProfile: true,
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(width: Dimensions.space20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${LocalStrings.welcome.tr} ',
                      style: regularLarge.copyWith(
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: name.isEmpty ? '—' : name,
                      style: regularLarge.copyWith(
                        color: theme.textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.space5),
                Text(
                  email.isEmpty ? '—' : email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: regularSmall.copyWith(color: ColorResources.blueGreyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselSection extends StatefulWidget {
  final DashboardController controller;
  const _CarouselSection({required this.controller});

  @override
  State<_CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<_CarouselSection> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = (width * 0.9).clamp(320, 460).toDouble();

    final showInvoices  = widget.controller.homeModel.menuItems?.invoices  ?? true;
    final showEstimates = widget.controller.homeModel.menuItems?.estimates ?? true;
    final showProposals = widget.controller.homeModel.menuItems?.proposals ?? true;

    final cards = <Widget>[
      if (showInvoices)  HomeInvoicesCard(invoices:  widget.controller.homeModel.data?.invoices),
      if (showEstimates) HomeEstimatesCard(estimates: widget.controller.homeModel.data?.estimates),
      if (showProposals) HomeProposalsCard(proposals: widget.controller.homeModel.data?.proposals),
    ];

    if (cards.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: height,
            viewportFraction: 1,
            enableInfiniteScroll: true,
            enlargeCenterPage: false,
            onPageChanged: (i, _) => setState(() => index = i),
          ),
          items: cards,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  cards.length,
                      (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == index ? ColorResources.secondaryColor : Colors.transparent,
                      border: Border.all(color: ColorResources.colorGrey, width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectsDonut extends StatelessWidget {
  final List<DataField> data;
  final TooltipBehavior tooltip;
  const _ProjectsDonut({required this.data, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      tooltipBehavior: tooltip,
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: lightDefault,
      ),
      series: <CircularSeries>[
        DoughnutSeries<DataField, String>(
          dataSource: data,
          xValueMapper: (DataField d, _) => d.status?.tr ?? '',
          yValueMapper: (DataField d, _) => int.tryParse(d.total ?? '') ?? 0,
          dataLabelMapper: (d, _) => d.total ?? '0',
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          radius: '80%',
          innerRadius: '55%',
        ),
      ],
    );
  }
}
