import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;

  const ProfileEntity({
    this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        phoneNumber,
        profilePicture,
      ];
}
