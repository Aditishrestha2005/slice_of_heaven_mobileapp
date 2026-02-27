import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/profile/domain/entities/profile_entity.dart';
import 'package:slice_of_heaven/features/profile/domain/repositories/profile_repository.dart';
import 'package:slice_of_heaven/features/profile/data/repositories/profile_repository_impl.dart';

// ✅ Params
class UpdateProfileParams extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;

  // ✅ store locally
  final String? profilePicturePath;

  // ✅ send to backend
  final File? profilePictureFile;

  const UpdateProfileParams({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePicturePath,
    this.profilePictureFile,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        phoneNumber,
        profilePicturePath,
        profilePictureFile,
      ];
}

// Provider
final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(profileRepository: repo);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<bool, UpdateProfileParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUsecase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProfileParams params) {
    final entity = ProfileEntity(
      userId: params.userId,
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      profilePicture: params.profilePicturePath, // ✅ save local path
    );

    // ✅ forward file to repo for backend upload
    return _profileRepository.updateProfile(
      entity,
      profilePictureFile: params.profilePictureFile,
    );
  }
}
