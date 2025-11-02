// lib/features/menu/view/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/features/menu/widget/menu_item.dart';
import 'package:flutex_admin/common/components/dialog/warning_dialog.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutex_admin/core/route/route.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  bool _is(String route) => Get.currentRoute == route;

  void _closeDrawer(BuildContext context) {
    final nav = Navigator.maybeOf(context);
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }

  void _go(BuildContext context, String route) {
    try {
      if (_is(route)) {
        _closeDrawer(context);
        return;
      }
      _closeDrawer(context);
      Get.offAllNamed(route);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route "$route" is not registered.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            const SizedBox(height: 10),

            // ===== Header mit sichtbarem "View profile"-Button
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 24, child: Icon(Icons.person, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('admin admin',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _go(context, RouteHelper.profileScreen),
                          icon: Icon(Icons.person_outline, size: 16, color: cs.primary),
                          label: Text('View profile',
                              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: BorderSide(color: cs.primary, width: 1),
                            foregroundColor: cs.primary,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== Haupteinträge (verwenden RouteHelper!)
            MenuItems(
              leadingIcon: Icons.people_outline,
              label: 'Customers',
              selected: _is(RouteHelper.customerScreen),
              onPressed: () => _go(context, RouteHelper.customerScreen),
            ),
            MenuItems(
              leadingIcon: Icons.work_outline,
              label: 'Projects',
              selected: _is(RouteHelper.projectScreen),
              onPressed: () => _go(context, RouteHelper.projectScreen),
            ),
            MenuItems(
              leadingIcon: Icons.checklist_outlined,
              label: 'Tasks',
              selected: _is(RouteHelper.taskScreen),
              onPressed: () => _go(context, RouteHelper.taskScreen),
            ),
            MenuItems(
              leadingIcon: Icons.receipt_long_outlined,
              label: 'Invoices',
              selected: _is(RouteHelper.invoiceScreen),
              onPressed: () => _go(context, RouteHelper.invoiceScreen),
            ),
            MenuItems(
              leadingIcon: Icons.assignment_outlined,
              label: 'Contracts',
              selected: _is(RouteHelper.contractScreen),
              onPressed: () => _go(context, RouteHelper.contractScreen),
            ),
            MenuItems(
              leadingIcon: Icons.confirmation_number_outlined,
              label: 'Tickets',
              selected: _is(RouteHelper.ticketScreen),
              onPressed: () => _go(context, RouteHelper.ticketScreen),
            ),

            MenuItems(
              leadingIcon: Icons.summarize_outlined,
              label: 'Estimates',
              selected: _is(RouteHelper.estimateScreen),
              onPressed: () => _go(context, RouteHelper.estimateScreen),
            ),
            MenuItems(
              leadingIcon: Icons.description_outlined,
              label: 'Proposals',
              selected: _is(RouteHelper.proposalScreen),
              onPressed: () => _go(context, RouteHelper.proposalScreen),
            ),

            // ===== Calling
            MenuItems(
              leadingIcon: Icons.phone_outlined,
              label: 'Calling',
              selected: _is(RouteHelper.callScreen),
              onPressed: () => _go(context, RouteHelper.callScreen),
            ),

            MenuItems(
              leadingIcon: Icons.payments_outlined,
              label: 'Payments',
              selected: _is(RouteHelper.paymentScreen),
              onPressed: () => _go(context, RouteHelper.paymentScreen),
            ),
            MenuItems(
              leadingIcon: Icons.inventory_2_outlined,
              label: 'Items',
              selected: _is(RouteHelper.itemScreen),
              onPressed: () => _go(context, RouteHelper.itemScreen),
            ),

            // ===== Settings (wieder sichtbar)
            MenuItems(
              leadingIcon: Icons.settings_outlined,
              label: 'Settings',
              selected: _is(RouteHelper.settingsScreen),
              onPressed: () => _go(context, RouteHelper.settingsScreen),
            ),

            const Divider(height: 24),

            // ===== Logout
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.logout, color: ColorResources.primaryColor),
              title: const Text('Logout'),
              onTap: () {
                const WarningAlertDialog().warningAlertDialog(
                  context,
                      () {
                    Get.back();
                    Get.find<DashboardController>().logout();
                  },
                  title: 'Sign out of Loadum?',
                  subTitle: 'You’ll be signed out on this device. You can sign in again anytime.',
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
