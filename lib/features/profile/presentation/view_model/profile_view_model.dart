import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/features/profile/domain/usecases/get_current_user_profile_usecase.dart';
import 'package:slice_of_heaven/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:slice_of_heaven/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetCurrentUserProfileUsecase _getCurrentUserProfileUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  ProfileState build() {
    _getCurrentUserProfileUsecase =
        ref.read(getCurrentUserProfileUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    return const ProfileState();
  }

  Future<void> getCurrentUserProfile() async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    final result = await _getCurrentUserProfileUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? profilePicturePath,
    File? profilePictureFile,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        userId: userId,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        profilePicturePath: profilePicturePath,
        profilePictureFile: profilePictureFile,
      ),
    );

    // ✅ fold synchronously (NO async inside fold)
    bool success = false;

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
        success = false;
      },
      (_) {
        state = state.copyWith(
          status: ProfileStatus.success,
          errorMessage: null,
        );
        success = true;
      },
    );

    // ✅ Refresh after successful update (optional but useful)
    if (success) {
      final refreshed = await _getCurrentUserProfileUsecase();
      refreshed.fold(
        (_) {
          // do nothing, keep success state
        },
        (profile) {
          state = state.copyWith(profile: profile);
        },
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
