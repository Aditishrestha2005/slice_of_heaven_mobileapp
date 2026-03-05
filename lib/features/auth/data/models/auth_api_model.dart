import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? token;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.token,
    this.profilePicture,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final first = (json['firstName'] ?? '').toString();
    final last = (json['lastName'] ?? '').toString();
    final composedName = ('$first $last').trim();

    // ✅ Accept multiple backend key names (very common source of bugs)
    final picture = (json['profilePicture'] ??
            json['imageUrl'] ??
            json['profileImage'] ??
            json['avatar'] ??
            json['image'])
        ?.toString();

    return AuthApiModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      fullName: composedName.isNotEmpty
          ? composedName
          : (json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      token: json['token']?.toString(),
      profilePicture: picture,
    );
  }

  Map<String, dynamic> toRegisterJson({
    required String password,
    required String confirmPassword,
  }) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "password": password,
      "confirmPassword": confirmPassword,
      "phoneNumber": phoneNumber,
    };
  }

  static Map<String, dynamic> toLoginJson({
    required String email,
    required String password,
  }) {
    return {"email": email, "password": password};
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      token: token,
      profilePicture: profilePicture,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      token: entity.token,
      profilePicture: entity.profilePicture,
    );
  }
}