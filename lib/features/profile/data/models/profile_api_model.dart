import 'dart:io';
import 'package:dio/dio.dart';

class ProfileApiModel {
  final String userId;
  final String? fullName;
  final String? email;
  final String? username;
  final String? phoneNumber;
  final String? profilePicture; // URL from backend

  ProfileApiModel({
    required this.userId,
    this.fullName,
    this.email,
    this.username,
    this.phoneNumber,
    this.profilePicture,
  });

  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    return ProfileApiModel(
      userId: (json['userId'] ?? json['_id'] ?? '').toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
    );
  }

  /// Change the key "profilePicture" to "image" if your backend expects image.
  Future<FormData> toFormData(File? imageFile) async {
    final map = <String, dynamic>{
      "userId": userId,
      if (fullName != null) "fullName": fullName,
      if (email != null) "email": email,
      if (username != null) "username": username,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
    };

    final formData = FormData.fromMap(map);

    if (imageFile != null) {
      formData.files.add(
        MapEntry(
          "profilePicture", // 👈 change to "image" if needed
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
