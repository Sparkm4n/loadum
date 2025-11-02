import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_controller.dart';
import 'package:flutex_admin/features/lead/model/kanban_lead_model.dart';
import 'package:flutex_admin/features/lead/model/lead_model.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/lead/widget/board_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';
import 'package:get/get.dart';

class KanbanLeadScreen extends StatefulWidget {
  const KanbanLeadScreen({super.key});

  @override
  State<KanbanLeadScreen> createState() => _KanbanLeadScreenState();
}

class _KanbanLeadScreenState extends State<KanbanLeadScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadKanbanLeads();
    });
  }

  //Can be used to animate to different sections of the BoardView
  BoardViewController boardViewController = BoardViewController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.leadsKanban.tr,
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : Builder(builder: (context) {
                List<BoardList> lists = [];
                for (int i = 0;
                    i < controller.kanbanLeadModel.data!.length;
                    i++) {
                  lists.add(_boardList(controller.kanbanLeadModel.data![i])
                      as BoardList);
                }
                return RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).cardColor,
                    onRefresh: () async {
                      await controller.loadKanbanLeads();
                    },
                    child: BoardView(
                      lists: lists,
                      boardViewController: boardViewController,
                    ));
              }),
      );
    });
  }

  Widget boardItem(Lead itemObject) {
    return BoardItem(
      draggable: false,
      onStartDragItem:
          (int? listIndex, int? itemIndex, BoardItemState? state) {},
      onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
          int? oldItemIndex, BoardItemState? state) {},
      onTapItem:
          (int? listIndex, int? itemIndex, BoardItemState? state) async {},
      item: BoardCard(lead: itemObject),
    );
  }

  Widget _boardList(KanbanLead list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.leads!.length; i++) {
      items.insert(i, boardItem(list.leads![i]) as BoardItem);
    }

    return BoardList(
      draggable: false,
      headerBackgroundColor: Converter.hexStringToColor(list.color ?? ''),
      backgroundColor:
          Converter.hexStringToColor(list.color ?? '').withValues(alpha: 0.05),
      header: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.space5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                offset: const Offset(25, 0),
                label: Text("${list.total}"),
                child: Text(list.status ?? '',
                    style: regularDefault.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
      items: items,
    );
  }
}
