import "package:flutex_admin/common/models/language_model.dart";
import "package:flutex_admin/core/utils/images.dart";
import "package:get/get.dart";

class LocalStrings {
  static const String appName = "Flutex";
  static const String topic = "Flutex";

  static List<LanguageModel> appLanguages = [
    LanguageModel(
      languageFlag: MyImages.english,
      languageName: "English",
      countryCode: "US",
      languageCode: "en",
    ),
    LanguageModel(
      languageFlag: MyImages.arabic,
      languageName: "العربية",
      countryCode: "SA",
      languageCode: "ar",
    ),
    LanguageModel(
      languageFlag: MyImages.spanish,
      languageName: "Spanish",
      countryCode: "ES",
      languageCode: "es",
    ),
    LanguageModel(
      languageFlag: MyImages.frensh,
      languageName: "French",
      countryCode: "FR",
      languageCode: "fr",
    ),
    LanguageModel(
      languageFlag: MyImages.german,
      languageName: "Deutsch",
      countryCode: "DE",
      languageCode: "de",
    ),
    LanguageModel(
      languageFlag: MyImages.hindi,
      languageName: "Hindi",
      countryCode: "HI",
      languageCode: "hi",
    ),
  ];

  // Onboarding Screens
  static const String onboardTitle1    = "Schedule jobs in minutes";
  static const String onboardSubTitle1 = "Create and assign jobs fast with a drag-and-drop calendar, instant crew notifications, and clear routes.";

  static const String onboardTitle2    = "Quotes, invoices & payments—together";
  static const String onboardSubTitle2 = "Send professional quotes, convert to jobs in one tap, and get paid online with friendly auto-reminders.";

  static const String onboardTitle3    = "Delight clients. Win more referrals.";
  static const String onboardSubTitle3 = "Share SMS updates, before/after photos, and quick feedback links—turn happy clients into repeat clients.";

  static const String skip       = "Skip";
  static const String next       = "Next";
  static const String getStarted = "Get Started";


  // Login Screen
  static const String password = "Password";
  static const String passwordHint = "Enter password";
  static const String rememberMe = "Remember Me";
  static const String forgotPassword = "Forgot Password?";
  static const String forgotPasswordTitle = "Forgot Password";
  static const String forgotPasswordDesc =
      "Enter your email below to receive a password reset verification code";
  static const String signIn = "Sign In";
  static const String login = "Login";
  static const String loginDesc = "Login to your account";

  // Register Screen
  static const String firstName = "First Name";
  static const String enterFirstName = "Enter first name";
  static const String firstNameHint = "Enter first Name";
  static const String lastName = "Last Name";
  static const String enterLastName = "Enter last name";
  static const String lastNameHint = "Enter last Name";
  static const String country = "Country";
  static const String selectCountry = "Select Country";
  static const String noCountryFound = "No Country Found";
  static const String emailAddress = "Email Address";
  static const String emailAddressHint = "Enter email address";
  static const String companyName = "Company Name";
  static const String enterCompanyName = "Enter Company Name";
  static const String email = "Email";
  static const String enterEmail = "Please, Enter Email Address";
  static RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static const String invalidEmailMsg = "Enter valid email";
  static const String enterYourPassword = "Enter your password";

  // Change Password
  static const String changePassword = "Change Password";
  static const String currentPassword = "Current Password";
  static const String currentPasswordHint = "Enter current password";
  static const String saveNewPassword = "Save New Password";

  // Home
  static const String welcome = "Welcome";
  static const String of = "of";
  static const String invoicesAwaitingPayment = "Invoices Awaiting Payment";
  static const String convertedLeads = "Converted Leads";
  static const String notCompleted = "Not Completed Tasks";
  static const String projectsInProgress = "Projects In Progress";
  static const String projectStatistics = "Statistics by Project Status";

  // Profile
  static const String viewProfile = "View Profile";
  static const String name = "Name";
  static const String enterName = "Enter Name";
  static const String title = "Title";
  static const String phone = "Phone";
  static const String zipCode = "Zip Code";
  static const String enterYourZipCode = "Enter your zip code";
  static const String state = "State";
  static const String enterYourState = "Enter your state";
  static const String city = "City";
  static const String enterYourCity = "Enter your city";
  static const String editProfile = "Edit Profile";
  static const String updateProfile = "Update Profile";

  // Settings
  static const String profile = "Profile";
  static const String theme = "Theme";
  static const String notification = "Notifications";
  static const String settings = "Settings";
  static const String language = "Language";
  static const String selectLanguage = "Select Language";
  static const String terms = "Terms & Conditions";
  static const String privacyPolicy = "Privacy & Policy";
  static const String signOut = "Sign Out";
  static const String darkmode = "Dark Mode";
  static const String light = "Light";
  static const String exit = "Exit";
  static const String exitTitle = "Are you sure you want to exit the app?";
  static const String logout = "Logout";
  static const String logoutTitle = "Logout";
  static const String logoutSureWarningMSg =
      "Are you sure you want to log out from your account?";
  static const String logoutSuccessMsg = "Sign Out Successfully";

  // Download Process
  static const String fileDownloadAt = "File download at";
  static const String errorDownloadingFile = "Error downloading file";
  static const String downloading = "Downloading";
  static const String fileDownloadedSuccess = "File downloaded successfully";
  static const String requestFail = "Request Failed";

  // Operations
  static const String isRequired = "is required";
  static const String chooseFile = "Choose File";
  static const String copy = "Copy";
  static const String view = "View";
  static const String viewAll = "View All";
  static const String edit = "Edit";
  static const String submit = "Submit";
  static const String update = "Update";
  static const String dataNotFound = "Data not found";
  static const String seeAll = "See All";
  static const String showMore = "Show More";
  static const String more = "More";
  static const String status = "Status";
  static const String selectStatus = "Select Status";
  static const String complete = "Completed";
  static const String confirm = "Confirm";
  static const String cancel = "Cancel";
  static const String success = "success";
  static const String fieldErrorMsg = "Please fill out this field";
  static const String requestSuccess = "Request Success";
  static const String badResponseMsg = "Bad Response Format!";
  static const String serverError = "Server Error";
  static const String unAuthorized = "Unauthorized";
  static const String somethingWentWrong = "Something went wrong";
  static const String noInternet = "No internet connection";
  static const String noDataFound = "Sorry!\n No Data Found";
  static const String yes = "Yes";
  static const String no = "No";
  static const String retry = "Retry";
  static const String error = "Error";
  static const String filter = "Filter";
  static const String sort = "Sort";
  static const String sortBy = "Sort By";
  static const String newestFirst = "Newest First";
  static const String oldestFirst = "Oldest First";
  static const String nameAZ = "Name A-Z";
  static const String nameZA = "Name Z-A";
  static const String clear = "Clear";

  // Status
  static const String approved = "Approved";
  static const String accept = "Accept";
  static const String enabled = "Enabled";
  static const String disabled = "Disabled";
  static const String succeed = "Succeed";
  static const String pending = "Pending";
  static const String rejected = "Rejected";
  static const String reject = "Reject";
  static const String completed = "Completed";
  static const String paid = "Paid";
  static const String unpaid = "Unpaid";
  static const String signed = "Signed";
  static const String notSigned = "Not Signed";
  static const String draft = "Draft";
  static const String sent = "Sent";
  static const String expired = "Expired";
  static const String accepted = "Accepted";
  static const String declined = "Declined";
  static const String notStarted = "Not Started";
  static const String inProgress = "In Progress";
  static const String onHold = "On Hold";
  static const String finished = "Finished";
  static const String cancelled = "Cancelled";
  static const String priorityUrgent = "Urgent";
  static const String priorityHigh = "High";
  static const String priorityMedium = "Medium";
  static const String priorityLow = "Low";
  static const String awaitingFeedback = "Awaiting Feedback";
  static const String overdue = "Overdue";
  static const String partialyPaid = "Partially Paid";
  static const String open = "Open";
  static const String answered = "Answered";
  static const String closed = "Closed";

  // Contract
  static const String contracts = "Contracts";
  static const String contract = "Contract";
  static const String contractSummery = "Contract Summery";
  static const String contractDetails = "Contract Details";
  static const String updateContract = "Update Contract";
  static const String deleteContract = "Delete Contract";
  static const String deleteContractWarningMSg =
      "Are you sure that you want to delete this Contract?";
  static const String contractValue = "Contract Value";
  static const String startDate = "Start Date";
  static const String endDate = "End Date";
  static const String contractType = "Contract Type";
  static const String addContract = "Add Contract";
  static const String client = "Client";
  static const String selectClient = "Select Client";
  static const String noClientFound = "No Client Found";
  static const String pleaseSelectClient = "Please, Select Client.";
  static const String pleaseSelectContact = "Please, Select Contact.";
  static const String enterValue = "Please, Enter Value.";
  static const String content = "Content";
  static const String noContent = "No Content Found";

  // Estimate
  static const String estimates = "Estimates";
  static const String estimate = "Estimate";
  static const String estimateSummery = "Estimate Summery";
  static const String estimateDetails = "Estimate Details";
  static const String to = "To";
  static const String estimateDate = "Estimate Date";
  static const String expiryDate = "Expiry Date";
  static const String referenceNo = "Reference No";
  static const String discount = "Discount";
  static const String subtotal = "Subtotal";
  static const String total = "Total";
  static const String clientNote = "Client Note";
  static const String adminNote = "Admin Note";
  static const String addEstimate = "Add Estimate";
  static const String updateEstimate = "Update Estimate";
  static const String deleteEstimate = "Delete Estimate";
  static const String deleteEstimateWarningMSg =
      "Are you sure that you want to delete this Estimate?";
  static const String number = "Number";
  static const String enterNumber = "Please, Enter Invoice Number.";
  static const String enterTotal = "Please, Enter Total.";
  static const String addItems = "Add Items";
  static const String addItem = "Add Item";
  static const String removeItem = "Remove";
  static const String itemName = "Item Name";
  static const String enterItemName = "Please, Enter Item Name.";
  static const String enterItemQty = "Please, Enter Item Qty.";
  static const String enterRate = "Please, Enter Item Rate.";
  static const String pleaseEnterDate = "Please, Enter Date.";
  static const String pleaseAddItem = "Please, Add items to the invoice.";

  // Project
  static const String project = "Project";
  static const String projects = "Projects";
  static const String projectSummery = "Project Summery";
  static const String updateProject = "Update Project";
  static const String deleteProject = "Delete Project";
  static const String deleteProjectWarningMSg =
      "Are you sure that you want to delete this Project?";
  static const String projectDetails = "Project Details";
  static const String description = "Description";
  static const String billingType = "Billing Type";
  static const String selectBillingType = "Select Billing Type";
  static const String fixedRate = "Fixed Rate";
  static const String projectHours = "Project Hours";
  static const String taskHours = "Task Hours";
  static const String totalRate = "Total Rate";
  static const String hours = "Hours";
  static const String deadline = "Deadline";
  static const String logged = "Logged";
  static const String totalExpenses = "Total Expenses";
  static const String billableExpenses = "Billable Expenses";
  static const String billedExpenses = "Billed Expenses";
  static const String unbilledExpenses = "Unbilled Expenses";
  static const String projectProgress = "Project Progress";
  static const String openTasks = "Open Tasks";
  static const String daysLeft = "Days Left";
  static const String overview = "Overview";
  static const String discussion = "Discussion";
  static const String taskDetails = "Task Details";
  static const String addProject = "Add Project";
  static const String ratePerHour = "Rate Per Hour";
  static const String totalComments = "Total comments";
  static const String visible = "Visible";
  static const String notVisible = "Not Visible";

  // Tasks
  static const String tasks = "Tasks";
  static const String task = "Task";
  static const String taskSummery = "Task Summery";
  static const String updateTask = "Update Task";
  static const String deleteTask = "Delete Task";
  static const String deleteTaskWarningMSg =
      "Are you sure that you want to delete this Task?";
  static const String createNewTask = "Create New Task";
  static const String comments = "Comments";
  static const String checklistItems = "Checklist Items";
  static const String checklistNotFound =
      "Checklist items not found for this task";
  static const String taskTitle = "Task Title";
  static const String enterTaskTitle = "Please, Enter Task Title.";
  static const String taskNameFieldErrorMsg = "Please, fill up Task Name field";
  static const String taskStartDate = "Start Date";
  static const String enterStartDate = "Please, Enter Start Date.";
  static const String taskDueDate = "Due Date";
  static const String enterDueDate = "Please, Enter Due Date.";
  static const String hourlyRate = "Hourly Rate";
  static const String tags = "Tags";
  static const String milestone = "Milestone";
  static const String relatedTo = "Related To";
  static const String nothingSelected = "Nothing Selected";
  static const String repeatEvery = "Repeat Every";
  static const String repeatType = "Repeat Type";
  static const String week = "Week";
  static const String twoWeeks = "2 Weeks";
  static const String oneMonth = "1 Month";
  static const String twoMonths = "2 Months";
  static const String threeMonths = "3 Months";
  static const String sixMonths = "6 Months";
  static const String oneYear = "1 Year";
  static const String custom = "Custom";
  static const String recurring = "Custom Recurring";
  static const String days = "Day(s)";
  static const String weeks = "Week(s)";
  static const String months = "Month(s)";
  static const String years = "Year(s)";
  static const String public = "Public";
  static const String billable = "Billable";
  static const String notBillable = "Not Billable";
  static const String testing = "Testing";
  static const String assignees = "Assignees";
  static const String taskPriorityFieldErrorMsg =
      "Please, select your Task Priority";
  static const String taskStartDateFieldErrorMsg =
      "Please, fill up Start Date field";
  static const String taskDueDateFieldErrorMsg =
      "Please, fill up Due Date field";
  static const String taskDescriptionFieldErrorMsg =
      "Please, fill up Task Description field";
  static const String editTask = "Edit Task";
  static const String taskUpdateErrorMsg = "You're Not Allowed to Update Tasks";
  static const String selectProject = "Select Project";
  static const String noProjectFound = "No Projects Found";
  static const String selectInvoice = "Select Invoice";
  static const String noInvoiceFound = "No Invoice Found";
  static const String selectLead = "Select Lead";
  static const String noLeadFound = "No Lead Found";
  static const String selectContract = "Select Contract";
  static const String noContractFound = "No Contract Found";
  static const String selectEstimate = "Select Estimate";
  static const String noEstimateFound = "No Estimate Found";
  static const String selectProposal = "Select Proposal";
  static const String noProposalFound = "No Proposal Found";

  // Invoice
  static const String invoice = "Invoice";
  static const String invoices = "Invoices";
  static const String sales = "Sales";
  static const String invoiceDetails = "Invoice Details";
  static const String invoiceSummery = "Invoice Summery";
  static const String billTo = "Bill to";
  static const String invoiceDate = "Invoice Date";
  static const String dueDate = "Due Date";
  static const String totalPaid = "Total Paid";
  static const String amountDue = "Amount Due";
  static const String transactions = "Transactions";
  static const String id = "ID";
  static const String qty = "Qty";
  static const String unit = "Unit";
  static const String rate = "Rate";
  static const String tax = "Tax";
  static const String date = "Date";
  static const String amount = "Amount";
  static const String addInvoice = "Add Invoice";
  static const String updateInvoice = "Update Invoice";
  static const String deleteInvoice = "Delete Invoice";
  static const String deleteInvoiceWarningMSg =
      "Are you sure that you want to delete this Invoice?";
  static const String showQuantityAs = "Show Quantity As";
  static const String selectCurrency = "Select Currency";
  static const String noCurrencyFound = "No Currency Found";
  static const String pleaseSelectCurrency = "Please, Select Currency.";
  static const String selectPaymentMode = "Select Payment Mode";
  static const String noPaymentModeFound = "No Payment Mode Found";
  static const String pleaseSelectPaymentMode = "Please, Select Payment Mode.";
  static const String selectItem = "Select Item";
  static const String noItemFound = "No Item Found";
  static const String recordPayment = "Record Payment";
  static const String amountReceived = "Amount Received";

  // Customer
  static const String customer = "Customer";
  static const String customers = "Customers";
  static const String customerDetails = "Customer Details";
  static const String customerSummery = "Customer Summery";
  static const String createdOn = "Created On";
  static const String totalCustomers = "Total Customers";
  static const String activeCustomers = "Active Customers";
  static const String inactiveCustomers = "Inactive Customers";
  static const String totalContacts = "Total Contacts";
  static const String activeContacts = "Active Contacts";
  static const String inactiveContacts = "Inactive Contacts";
  static const String lastLoginContacts = "Last Login Contacts";
  static const String contacts = "Contacts";
  static const String billingAndShipping = "Billing & Shipping";
  static const String company = "Company";
  static const String vatNumber = "VAT Number";
  static const String website = "Website";
  static const String currency = "Currency";
  static const String defaultLanguage = "Default Language";
  static const String defaultCurrency = "Default Currency";
  static const String address = "Address";
  static const String billingAddress = "Billing Address";
  static const String shippingAddress = "Shipping Address";
  static const String newContact = "New Contact";
  static const String attachReceipt = "Attach Receipt";
  static const String position = "Position";
  static const String direction = "Direction";
  static const String primaryContact = "Primary Contact";
  static const String doNotSendWelcomeEmail = "Do not send welcome email";
  static const String sendSetPasswordEmail = "Send SET password email";
  static const String support = "Support";
  static const String permissons = "Permissions";
  static const String makeSureToSetAppropriatePermissionsForThisContact =
      "Make sure to set appropriate permissions for this contact";
  static const String emailNotifications = "Email Notifications";
  static const String creditNote = "Credit Note";
  static const String creditNotes = "Credit Notes";
  static const String addCustomer = "Add Customer";
  static const String updateCustomer = "Update Customer";
  static const String deleteCustomer = "Delete Customer";
  static const String deleteCustomerWarningMSg =
      "Are you sure that you want to delete this customer?";
  static const String addContact = "Add Contact";
  static const String group = "Group";
  static const String selectGroup = "Select Group";
  static const String noGroupFound = "No Group Found";
  static const String billingStreet = "Billing Street";
  static const String billingCity = "Billing City";
  static const String billingState = "Billing State";
  static const String billingZip = "Billing Zip";
  static const String billingCountry = "Billing Country";
  static const String selectBillingCountry = "Select Billing Country";
  static const String shippingStreet = "Shipping Street";
  static const String shippingCity = "Shipping City";
  static const String shippingState = "Shipping State";
  static const String shippingZip = "Shipping Zip";
  static const String shippingCountry = "Shipping Country";
  static const String selectShippingCountry = "Select Shipping Country";

  // Payment
  static const String payment = "Payment";
  static const String payments = "Payments";
  static const String paymentDetails = "Payment Details";
  static const String paymentSummery = "Payment Summery";
  static const String active = "Active";
  static const String notActive = "Not Active";
  static const String paymentReceipt = "Payment Receipt";
  static const String paymentMode = "Payment Mode";
  static const String paymentDate = "Payment Date";
  static const String transactionId = "Transaction ID";
  static const String totalAmount = "Total Amount";

  // Item
  static const String item = "Item";
  static const String items = "Items";
  static const String itemDetails = "Item Details";
  static const String itemSummery = "Item Summery";
  static const String groupName = "Group Name";

  // Proposal
  static const String proposal = "Proposal";
  static const String proposals = "Proposals";
  static const String proposalDetails = "Proposal Details";
  static const String proposalSummery = "Proposal Summery";
  static const String openTill = "Open till";
  static const String totalTax = "Total Tax";
  static const String adjustment = "Adjustment";
  static const String revised = "Revised";
  static const String addProposal = "Add Proposal";
  static const String updateProposal = "Update Proposal";
  static const String deleteProposal = "Delete Proposal";
  static const String deleteProposalWarningMSg =
      "Are you sure that you want to delete this Proposal?";

  // Expense
  static const String expense = "Expense";
  static const String expenses = "Expenses";
  static const String expenseDetails = "Expense Details";
  static const String expenseSummery = "Expense Summery";
  static const String expenseCategory = "Expense Category";
  static const String selectExpenseCategory = "Select Expense Category";
  static const String noExpenseCategoryFound = "No Expense Category Found";
  static const String addExpense = "Add Expense";
  static const String updateExpense = "Update Expense";
  static const String deleteExpense = "Delete Expense";
  static const String deleteExpenseWarningMSg =
      "Are you sure that you want to delete this Expense?";
  static const String advancedOptions = "Advanced Options";

  // Ticket
  static const String ticket = "Ticket";
  static const String tickets = "Tickets";
  static const String ticketDetails = "Ticket Details";
  static const String ticketSummery = "Ticket Summery";
  static const String reply = "Reply";
  static const String department = "Department";
  static const String selectDepartment = "Select Department";
  static const String noDepartmentFound = "No Department Found";
  static const String contact = "Contact";
  static const String selectContact = "Select Contact";
  static const String noContactFound = "No Contacts Found";
  static const String submitted = "Submitted";
  static const String priority = "Priority";
  static const String selectPriority = "Select Priority";
  static const String noPriorityFound = "No Priority Found";
  static const String service = "Service";
  static const String selectService = "Select Service";
  static const String noServiceFound = "No Service Found";
  static const String createNewTicket = "Create New Ticket";
  static const String updateTicket = "Update Ticket";
  static const String deleteTicket = "Delete Ticket";
  static const String deleteTicketWarningMSg =
      "Are you sure that you want to delete this Ticket?";
  static const String subject = "Subject";
  static const String enterSubject = "Please, Enter Subject.";
  static const String enterDescription = "Please, fill up Description field";
  static const String ticketReply = "Add Ticket Reply";
  static const String ticketReplies = "Ticket Replies";
  static const String ticketMessage = "Message";
  static const String enterTicketReply = "Please, Enter Ticket Reply.";

  // Leads
  static const String lead = "Lead";
  static const String leads = "Leads";
  static const String leadDetails = "Lead Details";
  static const String leadSummery = "Lead Summery";
  static const String createNewLead = "Create New Lead";
  static const String updateLead = "Update Lead";
  static const String deleteLead = "Delete Lead";
  static const String deleteLeadWarningMSg =
      "Are you sure that you want to delete this Lead?";
  static const String source = "Source";
  static const String selectSource = "Select Source";
  static const String noSourceFound = "No Sources Found";
  static const String pleaseSelectSource = "Please, Enter Source.";
  static const String enterStatus = "Please, Enter Status.";
  static const String noStatusFound = "No Status Found";
  static const String converted = "Converted";
  static const String newLead = "New Lead";
  static const String closedWon = "Closed - Won";
  static const String closedLost = "Closed - Lost";
  static const String negotiating = "Negotiating";
  static const String contacted = "Contacted";
  static const String qualified = "Qualified";
  static const String reOpened = "Reopened";
  static const String attachments = "Attachments";
  static const String leadValue = "Lead Value";
  static const String reminders = "Reminders";
  static const String notified = "Notified";
  static const String notNotified = "Not Notified";
  static const String setLeadReminder = "Set Lead Reminder";
  static const String dateToBeNotified = "Date to be notified";
  static const String sendEmailReminder =
      "Send also an email for this reminder";
  static const String leadContacted = "I got in touch with this lead";
  static const String note = "Note";
  static const String notes = "Notes";
  static const String addLeadNote = "Add Note";
  static const String pleaseEnterNote = "Please, Enter Note.";
  static const String dateContacted = "Date Contacted";
  static const String activityLogs = "Activity Logs";
  static const String createdLead = "Created lead by";
  static const String createdNewTask = "Created new task";
  static const String updatedLeadStatusFrom = "Updated lead status from";
  static const String assignedTo = "Assigned to";
  static const String leadsKanban = "Leads Kanban";

  // Staff
  static const String staff = "Staff";
  static const String staffs = "Staffs";
  static const String staffSummery = "Staff Summery";
  static const String addStaff = "Add Staff";
  static const String updateStaff = "Update Staff";
  static const String deleteStaff = "Delete Staff Member";
  static const String deleteStaffWarningMSg =
      "Are you sure that you want to delete this Staff?";
  static const String staffDetails = "Staff Details";
  static const String selectStaff = "Select Staff";
  static const String noStaffFound = "No Staff Found";
  static const String facebook = "Facebook";
  static const String linkedIn = "LinkedIn";
  static const String skype = "Skype";
  static const String notStaffMember = "Not Staff Member";
  static const String administrator = "Administrator";
  static const String sendWelcomeEmail = "Send Welcome Email";
  static const String emailTemplates = "Email Templates";
  static const String bulkPDFExport = "Bulk PDF Export";
  static const String knowledgeBase = "Knowledge Base";
  static const String reports = "Reports";
  static const String staffRoles = "Staff Roles";
  static const String subscriptions = "Subscriptions";
  static const String taskChecklistTemplates = "Task Checklist Templates";
  static const String estimateRequest = "Estimate Request";
  static const String viewOwn = "View (Own)";
  static const String viewGlobal = "View (Global)";
  static const String create = "Create";
  static const String delete = "Delete";
  static const String viewAllTemplates = "View All Templates";
  static const String createTimesheets = "Create Timesheets";
  static const String editMilestones = "Edit Milestones";
  static const String deleteMilestones = "Delete Milestones";
  static const String viewTimesheetsReport = "View Timesheets Report";
  static const String editTimesheetsGlobal = "Edit Timesheets (Global)";
  static const String editOwnTimesheets = "Edit Own Timesheets";
  static const String deleteTimesheetsGlobal = "Delete Timesheets (Global)";
  static const String deleteOwnTimesheets = "Delete Own Timesheets";
  static const String noPermissionAssigned = "No Permission Assigned";
  static const String transferDataTo =
      "Staff Member to Transfer this Staff Data to";
  static const String transferDatadesc =
      "Some data for this staff member needs to be transferred to another user. Please select user where you want to transfer the data.";
  static const String staffMember = "Staff Member";
}

class Messages extends Translations {
  final Map<String, Map<String, String>> languages;
  Messages({required this.languages});

  @override
  Map<String, Map<String, String>> get keys {
    return languages;
  }
}
