import 'package:flutex_admin/features/auth/view/forget_password.dart';
import 'package:flutex_admin/features/auth/view/login_screen.dart';
import 'package:flutex_admin/features/contract/view/add_contract_screen.dart';
import 'package:flutex_admin/features/contract/view/contract_details_screen.dart';
import 'package:flutex_admin/features/contract/view/contracts_screen.dart';
import 'package:flutex_admin/features/contract/view/update_contract_screen.dart';
import 'package:flutex_admin/features/customer/view/add_contact_screen.dart';
import 'package:flutex_admin/features/customer/view/add_customer_screen.dart';
import 'package:flutex_admin/features/customer/view/customers_screen.dart';
import 'package:flutex_admin/features/customer/view/customer_details_screen.dart';
import 'package:flutex_admin/features/customer/view/update_customer_screen.dart';
import 'package:flutex_admin/features/estimate/view/add_estimate_screen.dart';
import 'package:flutex_admin/features/estimate/view/estimate_details_screen.dart';
import 'package:flutex_admin/features/estimate/view/estimate_screen.dart';
import 'package:flutex_admin/features/estimate/view/update_estimate_screen.dart';
import 'package:flutex_admin/features/dashboard/view/dashboard_screen.dart';
import 'package:flutex_admin/features/expense/view/add_expense_screen.dart';
import 'package:flutex_admin/features/expense/view/expense_details_screen.dart';
import 'package:flutex_admin/features/expense/view/expense_screen.dart';
import 'package:flutex_admin/features/expense/view/update_expense_screen.dart';
import 'package:flutex_admin/features/lead/view/kanban_lead_screen.dart';
import 'package:flutex_admin/features/notification/view/notification_screen.dart';
import 'package:flutex_admin/features/onboarding/view/onboard_intro_screen.dart';
import 'package:flutex_admin/features/invoice/view/add_invoice_screen.dart';
import 'package:flutex_admin/features/invoice/view/invoice_details_screen.dart';
import 'package:flutex_admin/features/invoice/view/invoice_screen.dart';
import 'package:flutex_admin/features/invoice/view/update_invoice_screen.dart';
import 'package:flutex_admin/features/item/view/item_details_screen.dart';
import 'package:flutex_admin/features/item/view/item_screen.dart';
import 'package:flutex_admin/features/lead/view/add_lead_screen.dart';
import 'package:flutex_admin/features/lead/view/lead_details_screen.dart';
import 'package:flutex_admin/features/lead/view/lead_screen.dart';
import 'package:flutex_admin/features/lead/view/update_lead_screen.dart';
import 'package:flutex_admin/features/payment/view/payment_details_screen.dart';
import 'package:flutex_admin/features/payment/view/payment_screen.dart';
import 'package:flutex_admin/features/privacy/view/privacy_policy_screen.dart';
import 'package:flutex_admin/features/profile/view/edit_profile_screen.dart';
import 'package:flutex_admin/features/profile/view/profile_screen.dart';
import 'package:flutex_admin/features/project/view/add_project_screen.dart';
import 'package:flutex_admin/features/project/view/project_details_screen.dart';
import 'package:flutex_admin/features/project/view/project_screen.dart';
import 'package:flutex_admin/features/project/view/update_project_screen.dart';
import 'package:flutex_admin/features/proposal/view/add_proposal_screen.dart';
import 'package:flutex_admin/features/proposal/view/proposal_details_screen.dart';
import 'package:flutex_admin/features/proposal/view/proposal_screen.dart';
import 'package:flutex_admin/features/proposal/view/update_proposal_screen.dart';
import 'package:flutex_admin/features/splash/view/splash_screen.dart';
import 'package:flutex_admin/features/staff/view/add_staff_screen.dart';
import 'package:flutex_admin/features/staff/view/staff_details_screen.dart';
import 'package:flutex_admin/features/staff/view/staffs_screen.dart';
import 'package:flutex_admin/features/task/view/add_task_screen.dart';
import 'package:flutex_admin/features/task/view/task_details_screen.dart';
import 'package:flutex_admin/features/task/view/task_screen.dart';
import 'package:flutex_admin/features/task/view/update_task_screen.dart';
import 'package:flutex_admin/features/ticket/view/add_ticket_screen.dart';
import 'package:flutex_admin/features/ticket/view/ticket_details_screen.dart';
import 'package:flutex_admin/features/ticket/view/ticket_screen.dart';
import 'package:flutex_admin/features/ticket/view/update_ticket_screen.dart';

// Calling
import 'package:flutex_admin/features/call/view/call_screen.dart';

// Echter Settings-Screen
import 'package:flutex_admin/features/settings/view/settings_screen.dart';

import 'package:get/get.dart';

class RouteHelper {
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = '/onboard_screen';
  static const String loginScreen = "/login_screen";
  static const String forgotPasswordScreen = "/forgot_password_screen";

  static const String dashboardScreen = "/dashboard_screen";
  static const String customerScreen = "/customer_screen";
  static const String customerDetailsScreen = "/customer_details_screen";
  static const String addCustomerScreen = "/add_customer_screen";
  static const String updateCustomerScreen = "/update_customer_screen";
  static const String addContactScreen = "/add_contact_screen";
  static const String projectScreen = "/project_screen";
  static const String projectDetailsScreen = "/project_details_screen";
  static const String addProjectScreen = "/add_project_screen";
  static const String updateProjectScreen = "/update_project_screen";
  static const String taskScreen = "/task_screen";
  static const String taskDetailsScreen = "/task_details_screen";
  static const String addTaskScreen = "/add_task_screen";
  static const String updateTaskScreen = "/update_task_screen";
  static const String invoiceScreen = "/invoice_screen";
  static const String invoiceDetailsScreen = "/invoice_details_screen";
  static const String addInvoiceScreen = "/add_invoice_screen";
  static const String updateInvoiceScreen = "/update_invoice_screen";
  static const String contractScreen = "/contract_screen";
  static const String contractDetailsScreen = "/contract_details_screen";
  static const String addContractScreen = "/add_contract_screen";
  static const String updateContractScreen = "/update_contract_screen";
  static const String ticketScreen = "/ticket_screen";
  static const String ticketDetailsScreen = "/ticket_details_screen";
  static const String addTicketScreen = "/add_ticket_screen";
  static const String updateTicketScreen = "/update_ticket_screen";
  static const String leadScreen = "/lead_screen";
  static const String kanbanLeadScreen = "/kanban_lead_screen";
  static const String leadDetailsScreen = "/lead_details_screen";
  static const String addLeadScreen = "/add_lead_screen";
  static const String updateLeadScreen = "/update_lead_screen";
  static const String estimateScreen = "/estimate_screen";
  static const String estimateDetailsScreen = "/estimate_details_screen";
  static const String addEstimateScreen = "/add_estimate_screen";
  static const String updateEstimateScreen = "/update_estimate_screen";
  static const String proposalScreen = "/proposal_screen";
  static const String proposalDetailsScreen = "/proposal_details_screen";
  static const String addProposalScreen = "/add_proposal_screen";
  static const String updateProposalScreen = "/update_proposal_screen";
  static const String expenseScreen = "/expense_screen";
  static const String expenseDetailsScreen = "/expense_details_screen";
  static const String addExpenseScreen = "/add_expense_screen";
  static const String updateExpenseScreen = "/update_expense_screen";
  static const String staffScreen = "/staff_screen";
  static const String staffDetailsScreen = "/staff_details_screen";
  static const String addStaffScreen = "/add_staff_screen";
  static const String paymentScreen = "/payment_screen";
  static const String paymentDetailsScreen = "/payment_details_screen";
  static const String itemScreen = "/item_screen";
  static const String itemDetailsScreen = "/item_details_screen";
  static const String notificationsScreen = "/notifications_screen";
  static const String settingsScreen = "/settings_screen";
  static const String profileScreen = "/profile_screen";
  static const String editProfileScreen = "/edit_profile_screen";
  static const String privacyScreen = "/privacy_screen";

  // Calling
  static const String callScreen = "/call";

  List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: onboardScreen, page: () => const OnBoardIntroScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: forgotPasswordScreen, page: () => const ForgetPasswordScreen()),

    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),

    GetPage(name: customerScreen, page: () => const CustomersScreen()),
    GetPage(name: customerDetailsScreen, page: () => CustomerDetailsScreen(id: Get.arguments)),
    GetPage(name: addCustomerScreen, page: () => const AddCustomerScreen()),
    GetPage(name: addContactScreen, page: () => AddContactScreen(id: Get.arguments)),
    GetPage(name: updateCustomerScreen, page: () => UpdateCustomerScreen(id: Get.arguments)),

    GetPage(name: projectScreen, page: () => const ProjectsScreen()),
    GetPage(name: projectDetailsScreen, page: () => ProjectDetailsScreen(id: Get.arguments)),
    GetPage(name: addProjectScreen, page: () => const AddProjectScreen()),
    GetPage(name: updateProjectScreen, page: () => UpdateProjectScreen(id: Get.arguments)),

    GetPage(name: taskScreen, page: () => const TaskScreen()),
    GetPage(name: taskDetailsScreen, page: () => TaskDetailsScreen(id: Get.arguments)),
    GetPage(name: addTaskScreen, page: () => const AddTaskScreen()),
    GetPage(name: updateTaskScreen, page: () => UpdateTaskScreen(id: Get.arguments)),

    GetPage(name: invoiceScreen, page: () => const InvoicesScreen()),
    GetPage(name: invoiceDetailsScreen, page: () => InvoiceDetailsScreen(id: Get.arguments)),
    GetPage(name: addInvoiceScreen, page: () => const AddInvoiceScreen()),
    GetPage(name: updateInvoiceScreen, page: () => UpdateInvoiceScreen(id: Get.arguments)),

    GetPage(name: contractScreen, page: () => const ContractsScreen()),
    GetPage(name: contractDetailsScreen, page: () => ContractDetailsScreen(id: Get.arguments)),
    GetPage(name: addContractScreen, page: () => const AddContractScreen()),
    GetPage(name: updateContractScreen, page: () => UpdateContractScreen(id: Get.arguments)),

    GetPage(name: ticketScreen, page: () => const TicketsScreen()),
    GetPage(name: ticketDetailsScreen, page: () => TicketDetailsScreen(id: Get.arguments)),
    GetPage(name: addTicketScreen, page: () => const AddTicketScreen()),
    GetPage(name: updateTicketScreen, page: () => UpdateTicketScreen(id: Get.arguments)),

    GetPage(name: leadScreen, page: () => const LeadScreen()),
    GetPage(name: kanbanLeadScreen, page: () => const KanbanLeadScreen()),
    GetPage(name: leadDetailsScreen, page: () => LeadDetailsScreen(id: Get.arguments)),
    GetPage(name: addLeadScreen, page: () => const AddLeadScreen()),
    GetPage(name: updateLeadScreen, page: () => UpdateLeadScreen(id: Get.arguments)),

    GetPage(name: estimateScreen, page: () => const EstimateScreen()),
    GetPage(name: estimateDetailsScreen, page: () => EstimateDetailsScreen(id: Get.arguments)),
    GetPage(name: addEstimateScreen, page: () => const AddEstimateScreen()),
    GetPage(name: updateEstimateScreen, page: () => UpdateEstimateScreen(id: Get.arguments)),

    GetPage(name: expenseScreen, page: () => const ExpenseScreen()),
    GetPage(name: expenseDetailsScreen, page: () => ExpenseDetailsScreen(id: Get.arguments)),
    GetPage(name: addExpenseScreen, page: () => const AddExpenseScreen()),
    GetPage(name: updateExpenseScreen, page: () => UpdateExpenseScreen(id: Get.arguments)),

    GetPage(name: proposalScreen, page: () => const ProposalScreen()),
    GetPage(name: proposalDetailsScreen, page: () => ProposalDetailsScreen(id: Get.arguments)),
    GetPage(name: addProposalScreen, page: () => const AddProposalScreen()),
    GetPage(name: updateProposalScreen, page: () => UpdateProposalScreen(id: Get.arguments)),

    GetPage(name: staffScreen, page: () => const StaffsScreen()),
    GetPage(name: staffDetailsScreen, page: () => StaffDetailsScreen(id: Get.arguments)),
    GetPage(name: addStaffScreen, page: () => const AddStaffScreen()),

    GetPage(name: paymentScreen, page: () => const PaymentScreen()),
    GetPage(name: paymentDetailsScreen, page: () => PaymentDetailsScreen(id: Get.arguments)),

    GetPage(name: itemScreen, page: () => const ItemScreen()),
    GetPage(name: itemDetailsScreen, page: () => ItemDetailsScreen(id: Get.arguments)),

    GetPage(name: notificationsScreen, page: () => const NotificationScreen()),

    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),

    // Settings zeigt auf den echten SettingsScreen
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),

    GetPage(name: privacyScreen, page: () => const PrivacyPolicyScreen()),

    // Calling
    GetPage(name: callScreen, page: () => const CallScreen()),
  ];
}
