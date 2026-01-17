import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? password; 
  final String? token;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.password,
    this.token,
    this.profilePicture,
  });

  // API response → Model
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'],
      fullName: "${json['firstName']} ${json['lastName']}".trim(),
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      token: json['token'],
      profilePicture: json['profilePicture'],
    );
  }

  // Model → API request (Signup / Login)
  Map<String, dynamic> toJson({String? confirmPassword}) {
    // Split fullName into firstName and lastName
    final nameParts = fullName.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "password": password,
      "confirmPassword": confirmPassword ?? password, 
      "phoneNumber": phoneNumber,
    };
  }

  // API Model → Domain Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
      token: token,
      profilePicture: profilePicture,
    );
  }

  // Entity → API Model
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      token: entity.token,
      profilePicture: entity.profilePicture,
    );
  }
}