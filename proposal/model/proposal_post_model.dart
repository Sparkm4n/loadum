import 'package:flutex_admin/features/proposal/model/proposal_item_model.dart';

class ProposalPostModel {
  final String subject;
  final String related;
  final String relId;
  final String proposalTo;
  final String date;
  final String openTill;
  final String currency;
  final String? discountType;
  final String status;
  final String? assigned;
  final String email;
  final List<ProposalItemModel> newItems;
  final List<String>? removedItems;
  final String subtotal;
  final String total;

  ProposalPostModel({
    required this.subject,
    required this.related,
    required this.relId,
    required this.proposalTo,
    required this.date,
    required this.openTill,
    required this.currency,
    this.discountType,
    required this.status,
    this.assigned,
    required this.email,
    required this.newItems,
    this.removedItems,
    required this.subtotal,
    required this.total,
  });
}
