import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/column_widget/card_column.dart';
import 'package:flutex_admin/common/components/image/circle_shape_image.dart';

import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';

import 'package:flutex_admin/features/profile/controller/profile_controller.dart';
import 'package:flutex_admin/features/profile/repo/profile_repo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final Uri _billingUri = Uri.parse('https://loadum.pro/billing/');

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<ProfileRepo>()) {
      Get.put(ProfileRepo(apiClient: Get.find()));
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController(profileRepo: Get.find()));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProfileController>().loadData();
    });
  }

  String _initials(String? first, String? last) {
    final f = (first ?? '').trim();
    final l = (last ?? '').trim();
    final a = f.isNotEmpty ? f[0] : '';
    final b = l.isNotEmpty ? l[0] : (f.length > 1 ? f[1] : '');
    final res = (a + b).toUpperCase();
    return res.isEmpty ? '—' : res;
  }

  Future<void> _openBilling() async {
    try {
      final ok = await launchUrl(_billingUri, mode: LaunchMode.inAppBrowserView);
      if (!ok) {
        await launchUrl(_billingUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: _billingUri.toString()));
      Get.snackbar(
        'Link copied',
        'Billing URL copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GetBuilder<ProfileController>(
      builder: (c) {
        final d = c.profileModel.data;
        final fullName = '${d?.firstName ?? ''} ${d?.lastName ?? ''}'.trim();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: 'Profile',
            bgColor: theme.appBarTheme.backgroundColor ?? cs.primary,
          ),
          body: c.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
            color: cs.primary,
            backgroundColor: theme.cardColor,
            onRefresh: () => c.loadData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // ===== Branded header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      Dimensions.space20,
                      Dimensions.space20,
                      Dimensions.space20,
                      Dimensions.space15,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.secondary.withOpacity(.75)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar with initials fallback
                        Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: .6,
                              color: Colors.white.withOpacity(.85),
                            ),
                          ),
                          child: ClipOval(
                            child: (d?.profileImage ?? '').isNotEmpty
                                ? Image.network(
                              d!.profileImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _InitialsAvatar(
                                text: _initials(d.firstName, d.lastName),
                              ),
                            )
                                : _InitialsAvatar(
                              text: _initials(d?.firstName, d?.lastName),
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.space15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName.isEmpty ? '—' : fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: regularExtraLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Display locale & device timezone (safe defaults)
                              Text(
                                'Locale: ${Get.locale?.toLanguageTag() ?? '—'}',
                                style: theme.textTheme.labelMedium?.copyWith(color: Colors.white),
                              ),
                              Text(
                                'Timezone: ${DateTime.now().timeZoneName}',
                                style: theme.textTheme.labelMedium?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== Contact
                  _SectionCard(
                    title: 'Contact',
                    children: [
                      _rowIcon(theme, MyImages.email, 'Email', d?.email),
                      const CustomDivider(space: Dimensions.space10),
                      _rowIcon(theme, MyImages.phone, 'Phone', d?.phoneNumber),
                    ],
                  ),

                  // ===== Billing & Subscription (plan unknown -> “Manage billing” CTA)
                  _SectionCard(
                    title: 'Billing & Subscription',
                    children: [
                      Text(
                        'Manage invoices, payment methods, or upgrade your plan.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _openBilling,
                              icon: const Icon(Icons.open_in_browser_rounded),
                              label: const Text('Manage billing'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.space20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _rowIcon(ThemeData theme, String asset, String label, String? value) {
    final cs = theme.colorScheme;
    return Row(
      children: [
        CircleShapeImage(
          imageColor: theme.appBarTheme.backgroundColor ?? cs.primary,
          image: asset,
        ),
        const SizedBox(width: Dimensions.space15),
        Expanded(child: CardColumn(header: label, body: (value ?? '-').toString())),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;
  const _SectionCard({required this.title, required this.children, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.space15, Dimensions.space15, Dimensions.space15, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.space15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String text;
  const _InitialsAvatar({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(.08),
      alignment: Alignment.center,
      child: Text(text, style: regularExtraLarge.copyWith(fontWeight: FontWeight.w800)),
    );
  }
}
