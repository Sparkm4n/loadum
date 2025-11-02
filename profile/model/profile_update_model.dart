import 'dart:io';

class ProfileUpdateModel {
  final String firstName;
  final String lastName;
  final String? facebook;
  final String? linkedin;
  final String? phoneNumber;
  final String? skype;
  final File? image;

  ProfileUpdateModel({
    required this.firstName,
    required this.lastName,
    this.facebook,
    this.linkedin,
    this.phoneNumber,
    this.skype,
    this.image,
  });
}
