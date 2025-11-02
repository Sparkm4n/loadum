import 'package:flutex_admin/common/components/circle_image_button.dart';
import 'package:flutex_admin/common/components/dialog/warning_dialog.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutex_admin/features/dashboard/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.homeModel});
  final DashboardModel homeModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            // ===== Header
            UserAccountsDrawerHeader(
              accountName: Text(
                '${homeModel.staff?.firstName ?? ''} ${homeModel.staff?.lastName ?? ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: mediumLarge.copyWith(color: Colors.white),
              ),
              accountEmail: Text(
                homeModel.staff?.email ?? '',
                style: lightDefault.copyWith(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: ColorResources.blueGreyColor,
                child: CircleImageWidget(
                  imagePath: homeModel.staff?.profileImage ?? '',
                  isAsset: false,
                  isProfile: true,
                  width: 80,
                  height: 80,
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    cs.primary.withOpacity(0.55),
                    BlendMode.multiply,
                  ),
                  image: AssetImage(MyImages.login),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Sichtbarer "View profile"-Button direkt unter dem Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteHelper.profileScreen);
                  },
                  icon: Icon(Icons.person_outline, size: 16, color: cs.primary),
                  label: Text(
                    LocalStrings.viewProfile.tr,
                    style: semiBoldLarge.copyWith(color: cs.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ===== Menü
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Customers
                    if (homeModel.menuItems?.customers ?? false)
                      _tile(
                        context,
                        icon: Icons.group_outlined,
                        title: LocalStrings.customers.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.customerScreen);
                        },
                      ),

                    // Projects
                    if (homeModel.menuItems?.projects ?? false)
                      _tile(
                        context,
                        icon: Icons.folder_open_outlined,
                        title: LocalStrings.projects.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.projectScreen);
                        },
                      ),

                    // Tasks
                    if (homeModel.menuItems?.tasks ?? false)
                      _tile(
                        context,
                        icon: Icons.task_alt_rounded,
                        title: LocalStrings.tasks.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.taskScreen);
                        },
                      ),

                    // Invoices
                    if (homeModel.menuItems?.invoices ?? false)
                      _tile(
                        context,
                        icon: Icons.assignment_outlined,
                        title: LocalStrings.invoices.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.invoiceScreen);
                        },
                      ),

                    // Contracts
                    if (homeModel.menuItems?.contracts ?? false)
                      _tile(
                        context,
                        icon: Icons.article_outlined,
                        title: LocalStrings.contracts.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.contractScreen);
                        },
                      ),

                    // Tickets
                    if (homeModel.menuItems?.tickets ?? false)
                      _tile(
                        context,
                        icon: Icons.confirmation_number_outlined,
                        title: LocalStrings.tickets.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.ticketScreen);
                        },
                      ),

                    // Leads
                    if (homeModel.menuItems?.leads ?? false)
                      _tile(
                        context,
                        icon: Icons.markunread_mailbox_outlined,
                        title: LocalStrings.leads.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.leadScreen);
                        },
                      ),

                    // Estimates
                    if (homeModel.menuItems?.estimates ?? false)
                      _tile(
                        context,
                        icon: Icons.add_chart_outlined,
                        title: LocalStrings.estimates.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.estimateScreen);
                        },
                      ),

                    // Proposals
                    if (homeModel.menuItems?.proposals ?? false)
                      _tile(
                        context,
                        icon: Icons.description_outlined,
                        title: LocalStrings.proposals.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.proposalScreen);
                        },
                      ),

                    // ===== CALLING (immer sichtbar – kein Twilio-Wording)
                    _tile(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Calling',
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(RouteHelper.callScreen);
                      },
                    ),

                    // Payments
                    if (homeModel.menuItems?.payments ?? false)
                      _tile(
                        context,
                        icon: Icons.account_balance_wallet_outlined,
                        title: LocalStrings.payments.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.paymentScreen);
                        },
                      ),

                    // Items
                    if (homeModel.menuItems?.items ?? false)
                      _tile(
                        context,
                        icon: Icons.inventory_2_outlined,
                        title: LocalStrings.items.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.itemScreen);
                        },
                      ),

                    // (Optional) Expenses & Staff – falls in deinem Backend freigeschaltet
                    if (homeModel.menuItems?.expenses ?? false)
                      _tile(
                        context,
                        icon: Icons.monetization_on_outlined,
                        title: LocalStrings.expenses.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.expenseScreen);
                        },
                      ),
                    if (homeModel.menuItems?.staff ?? false)
                      _tile(
                        context,
                        icon: Icons.person_4_outlined,
                        title: LocalStrings.staffs.tr,
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(RouteHelper.staffScreen);
                        },
                      ),

                    // Settings
                    _tile(
                      context,
                      icon: Icons.settings_outlined,
                      title: LocalStrings.settings.tr,
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(RouteHelper.settingsScreen);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ===== Logout
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: Dimensions.space20,
                color: Colors.red,
              ),
              title: Text(
                LocalStrings.logout.tr,
                style: regularDefault.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              onTap: () {
                const WarningAlertDialog().warningAlertDialog(
                  context,
                      () {
                    Get.back();
                    Get.find<DashboardController>().logout();
                  },
                  title: LocalStrings.logout.tr,
                  subTitle: LocalStrings.logoutSureWarningMSg.tr,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Einheitlicher Drawer-Eintrag
  Widget _tile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: regularDefault.copyWith(color: textColor)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: Dimensions.space12, color: textColor),
      onTap: onTap,
    );
  }
}
