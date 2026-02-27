import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/hive/hive_service.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_hive_model.dart';

abstract class IAuthLocalDataSource {
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<AuthHiveModel> register(AuthHiveModel user);
  Future<bool> updateUser(AuthHiveModel user);
  Future<bool> deleteUser(String authId);
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<AuthHiveModel?> getUserById(String authId);
}

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthLocalDataSource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDataSource implements IAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDataSource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  })  : _hiveService = hiveService,
        _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    await _hiveService.register(user);
    return user;
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      // ✅ MUST await if hive login is async
      final user = await _hiveService.login(email, password);

      if (user != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId,
          email: user.email,
          fullName: user.fullName,
          username: user.username,
          phoneNumber: user.phoneNumber,
          profilePicture: user.profilePicture,
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _hiveService.deleteUser(authId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      if (!_userSessionService.isLoggedIn()) return null;

      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return null;

      return _hiveService.getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return _hiveService.getUserByEmail(email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    try {
      return _hiveService.getUserById(authId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      return await _hiveService.updateUser(user);
    } catch (e) {
      return false;
    }
  }
}
