import 'dart:io';
import 'package:slice_of_heaven/features/profile/data/models/profile_hive_model.dart';

abstract interface class IProfileLocalDataSource {
  Future<ProfileHiveModel?> getCurrentUserProfile();
  Future<ProfileHiveModel> saveProfile(ProfileHiveModel profile);
  Future<ProfileHiveModel?> getProfileById(String userId);
  Future<ProfileHiveModel?> getProfileByEmail(String email);
  Future<bool> updateProfile(ProfileHiveModel profile);
  Future<bool> deleteProfile(String userId);
}

abstract interface class IProfileRemoteDataSource {
  /// Update profile via API (token based auth expected)
  /// profilePicture is optional image file for multipart upload
  Future<bool> updateProfileRemote({
    required String fullName,
    required String email,
    String? phoneNumber,
    File? profilePicture,
  });
}
