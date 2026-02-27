import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? password;
  final String? token;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.password,
    this.token,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        authId,
        fullName,
        email,
        username,
        phoneNumber,
        password,
        token,
        profilePicture,
      ];
}
