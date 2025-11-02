import 'dart:io';

class StaffPostModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? facebook;
  final String? linkedIn;
  final String? skype;
  final String? hourlyRate;
  final String? admin;
  final String? isNotStaff;
  final String? sendWelcomeEmail;
  final File? image;

  StaffPostModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.facebook,
    this.linkedIn,
    this.skype,
    this.hourlyRate,
    this.admin,
    this.isNotStaff,
    this.sendWelcomeEmail,
    this.image,
  });
}
