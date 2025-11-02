import 'package:flutex_admin/common/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/lead/widget/add_note_bottom_sheet.dart';
import 'package:flutex_admin/features/lead/widget/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class LeadNotes extends StatefulWidget {
  const LeadNotes({super.key, required this.id});
  final String id;

  @override
  State<LeadNotes> createState() => _LeadNotesState();
}

class _LeadNotesState extends State<LeadNotes> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadDetailsController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLeadNotes(widget.id);
    });
  }

  bool showFab = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadDetailsController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.notesModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadLeadNotes(widget.id);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(Dimensions.space10),
                    itemBuilder: (context, index) {
                      return NoteCard(
                        index: index,
                        note: controller.notesModel.data!,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemCount: controller.notesModel.data!.length,
                  ),
                )
              : const Center(child: NoDataWidget()),
          floatingActionButton: AnimatedSlide(
            offset: showFab ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: showFab ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: CustomFAB(
                icon: Icons.sticky_note_2_outlined,
                isShowText: true,
                text: LocalStrings.addLeadNote.tr,
                press: () {
                  CustomBottomSheet(
                    child: AddNoteBottomSheet(leadId: widget.id),
                  ).customBottomSheet(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
