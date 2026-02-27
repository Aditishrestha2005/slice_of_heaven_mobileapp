import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:slice_of_heaven/features/profile/domain/entities/profile_entity.dart';
import 'package:slice_of_heaven/features/profile/domain/repositories/profile_repository.dart';

// Provider
final getCurrentUserProfileUsecaseProvider =
    Provider<GetCurrentUserProfileUsecase>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return GetCurrentUserProfileUsecase(profileRepository: repo);
});

class GetCurrentUserProfileUsecase
    implements UsecaseWithoutParams<ProfileEntity> {
  final IProfileRepository _profileRepository;

  GetCurrentUserProfileUsecase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileEntity>> call() {
    return _profileRepository.getCurrentUserProfile();
  }
}

class UsecaseWithoutParms {
}
