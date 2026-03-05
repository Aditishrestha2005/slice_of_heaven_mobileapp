import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
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

  /// ===============================
  /// GET CURRENT USER PROFILE
  /// ===============================
  Future<void> getCurrentUserProfile() async {
    state = state.copyWith(
      status: ProfileStatus.loading,
      errorMessage: null,
    );

    final result = await _getCurrentUserProfileUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) async {
        // update UI state
        state = state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          errorMessage: null,
        );

        // ✅ IMPORTANT FIX
        // restore profile picture & phone into session
        final session = ref.read(userSessionServiceProvider);

        await session.updateProfileSession(
          fullName: profile.fullName,
          email: profile.email,
          phoneNumber: profile.phoneNumber,
          profilePicture: profile.profilePicture,
        );
      },
    );
  }

  /// ===============================
  /// UPDATE PROFILE
  /// ===============================
  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? profilePicturePath,
    File? profilePictureFile,
  }) async {
    state = state.copyWith(
      status: ProfileStatus.loading,
      errorMessage: null,
    );

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

    /// ===============================
    /// REFRESH PROFILE AFTER UPDATE
    /// ===============================
    if (success) {
      final refreshed = await _getCurrentUserProfileUsecase();

      refreshed.fold(
        (_) {
          // keep existing state
        },
        (profile) async {
          // update UI state
          state = state.copyWith(profile: profile);

          // ✅ Save into session so picture stays after restart
          final session = ref.read(userSessionServiceProvider);

          await session.updateProfileSession(
            fullName: profile.fullName,
            email: profile.email,
            phoneNumber: profile.phoneNumber,
            profilePicture: profile.profilePicture,
          );
        },
      );
    }
  }

  /// ===============================
  /// CLEAR ERROR
  /// ===============================
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}