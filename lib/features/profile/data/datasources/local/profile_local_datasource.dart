import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/hive/hive_service.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/profile/data/datasources/profile_datasource.dart';
import 'package:slice_of_heaven/features/profile/data/models/profile_hive_model.dart';

final profileLocalDatasourceProvider = Provider<ProfileLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return ProfileLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class ProfileLocalDatasource implements IProfileLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  ProfileLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  })  : _hiveService = hiveService,
        _userSessionService = userSessionService;

  @override
  Future<ProfileHiveModel?> getCurrentUserProfile() async {
    try {
      if (!_userSessionService.isLoggedIn()) return null;

      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return null;

      return _hiveService.getProfileById(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProfileHiveModel> saveProfile(ProfileHiveModel profile) async {
    return await _hiveService.saveProfile(profile);
  }

  @override
  Future<ProfileHiveModel?> getProfileById(String userId) async {
    try {
      return _hiveService.getProfileById(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProfileHiveModel?> getProfileByEmail(String email) async {
    try {
      return _hiveService.getProfileByEmail(email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProfile(ProfileHiveModel profile) async {
    try {
      final updated = await _hiveService.updateProfile(profile);

      if (updated) {
        // ✅ don't call saveUserSession here (it needs username sometimes)
        await _userSessionService.updateProfileSession(
          fullName: profile.fullName,
          email: profile.email,
          phoneNumber: profile.phoneNumber,
          profilePicture: profile.profilePicture,
        );
      }

      return updated;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProfile(String userId) async {
    try {
      await _hiveService.deleteProfile(userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
