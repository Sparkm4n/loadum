class LeadCreateModel {
  final String source;
  final String status;
  final String name;
  final String? assigned;
  final String? tags;
  final String? value;
  final String? title;
  final String? email;
  final String? website;
  final String? phoneNumber;
  final String? company;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? defaultLanguage;
  final String? description;
  final String? isPublic;

  LeadCreateModel({
    required this.source,
    required this.status,
    required this.name,
    this.assigned,
    this.tags,
    this.value,
    this.title,
    this.email,
    this.website,
    this.phoneNumber,
    this.company,
    this.address,
    this.city,
    this.state,
    this.country,
    this.defaultLanguage,
    this.description,
    this.isPublic,
  });
}
