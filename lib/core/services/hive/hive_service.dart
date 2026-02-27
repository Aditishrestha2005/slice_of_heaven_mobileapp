import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_hive_model.dart';
import 'package:slice_of_heaven/features/profile/data/models/profile_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  static bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Auth
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isBoxOpen(HiveTableConstant.authTable)) {
      await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    }

    // Profile
    if (!Hive.isAdapterRegistered(HiveTableConstant.profileTypeId)) {
      Hive.registerAdapter(ProfileHiveModelAdapter());
    }
    if (!Hive.isBoxOpen(HiveTableConstant.profileTable)) {
      await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileTable);
    }

    _initialized = true;
  }

  // ================= AUTH =================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> register(AuthHiveModel user) async {
    await init();
    await _authBox.put(user.authId, user);
    return user;
  }

  // ✅ make it async + ensure init
  Future<AuthHiveModel?> login(String email, String password) async {
    await init();
    try {
      return _authBox.values.firstWhere(
        (user) =>
            user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  AuthHiveModel? getUserById(String authId) => _authBox.get(authId);

  Future<AuthHiveModel?> getUserByEmail(String email) async {
    await init();
    try {
      return _authBox.values.firstWhere(
        (user) => user.email.trim().toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateUser(AuthHiveModel user) async {
    await init();
    await _authBox.put(user.authId, user); // ✅ upsert
    return true;
  }

  Future<void> deleteUser(String authId) async {
    await init();
    await _authBox.delete(authId);
  }

  // ================= PROFILE =================
  Box<ProfileHiveModel> get _profileBox =>
      Hive.box<ProfileHiveModel>(HiveTableConstant.profileTable);

  Future<ProfileHiveModel> saveProfile(ProfileHiveModel profile) async {
    await init();
    final key = profile.userId;
    if (key == null || key.isEmpty) {
      throw Exception("Profile userId is null/empty");
    }
    await _profileBox.put(key, profile); // ✅ use userId as key
    return profile;
  }

  ProfileHiveModel? getProfileById(String userId) {
    return _profileBox.get(userId);
  }

  ProfileHiveModel? getProfileByEmail(String email) {
    try {
      return _profileBox.values.firstWhere(
        (p) => p.email.trim().toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // ✅ IMPORTANT FIX: UPSERT (update OR create)
  Future<bool> updateProfile(ProfileHiveModel profile) async {
    await init();
    final key = profile.userId;
    if (key == null || key.isEmpty) return false;

    await _profileBox.put(key, profile); // ✅ always put
    return true;
  }

  Future<void> deleteProfile(String userId) async {
    await init();
    await _profileBox.delete(userId);
  }
}
