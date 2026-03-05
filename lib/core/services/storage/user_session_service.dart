// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
//   throw UnimplementedError('SharedPreferences must be overridden in main.dart');
// });

// final userSessionServiceProvider = Provider<UserSessionService>((ref) {
//   final prefs = ref.read(sharedPreferencesProvider);
//   return UserSessionService(prefs: prefs);
// });

// class UserSessionService {
//   final SharedPreferences _prefs;

//   static const String _keyIsLoggedIn = 'is_logged_in';
//   static const String _keyUserId = 'user_id';
//   static const String _keyUserEmail = 'user_email';
//   static const String _keyUserFullName = 'user_full_name';
//   static const String _keyUserUsername = 'user_username';
//   static const String _keyUserPhoneNumber = 'user_phone_number';
//   static const String _keyUserProfilePicture = 'user_profile_picture';

//   UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

//   /// ✅ Works for both OLD + NEW calls.
//   /// username is optional now, so old auth code won't crash.
//   Future<void> saveUserSession({
//     required String userId,
//     required String email,
//     required String fullName,
//     String? username,
//     String? phoneNumber,
//     String? profilePicture,
//   }) async {
//     await _prefs.setBool(_keyIsLoggedIn, true);
//     await _prefs.setString(_keyUserId, userId);
//     await _prefs.setString(_keyUserEmail, email);
//     await _prefs.setString(_keyUserFullName, fullName);

//     // keep existing username if not provided
//     final existingUsername = _prefs.getString(_keyUserUsername);
//     final safeUsername = (username != null && username.trim().isNotEmpty)
//         ? username.trim()
//         : (existingUsername ?? '');
//     await _prefs.setString(_keyUserUsername, safeUsername);

//     if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
//       await _prefs.setString(_keyUserPhoneNumber, phoneNumber.trim());
//     } else {
//       await _prefs.remove(_keyUserPhoneNumber);
//     }

//     if (profilePicture != null && profilePicture.trim().isNotEmpty) {
//       await _prefs.setString(_keyUserProfilePicture, profilePicture.trim());
//     } else {
//       await _prefs.remove(_keyUserProfilePicture);
//     }
//   }

//   /// ✅ For profile update only (no username/userId change)
//   Future<void> updateProfileSession({
//     required String fullName,
//     required String email,
//     String? phoneNumber,
//     String? profilePicture,
//   }) async {
//     await _prefs.setString(_keyUserEmail, email);
//     await _prefs.setString(_keyUserFullName, fullName);

//     if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
//       await _prefs.setString(_keyUserPhoneNumber, phoneNumber.trim());
//     } else {
//       await _prefs.remove(_keyUserPhoneNumber);
//     }

//     if (profilePicture != null && profilePicture.trim().isNotEmpty) {
//       await _prefs.setString(_keyUserProfilePicture, profilePicture.trim());
//     } else {
//       await _prefs.remove(_keyUserProfilePicture);
//     }
//   }

//   bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

//   String? getCurrentUserId() => _prefs.getString(_keyUserId);
//   String? getCurrentUserEmail() => _prefs.getString(_keyUserEmail);
//   String? getCurrentUserFullName() => _prefs.getString(_keyUserFullName);
//   String? getCurrentUserUsername() => _prefs.getString(_keyUserUsername);
//   String? getCurrentUserPhoneNumber() => _prefs.getString(_keyUserPhoneNumber);
//   String? getCurrentUserProfilePicture() =>
//       _prefs.getString(_keyUserProfilePicture);

//   Future<void> clearSession() async {
//     await _prefs.remove(_keyIsLoggedIn);
//     await _prefs.remove(_keyUserId);
//     await _prefs.remove(_keyUserEmail);
//     await _prefs.remove(_keyUserFullName);
//     await _prefs.remove(_keyUserUsername);
//     await _prefs.remove(_keyUserPhoneNumber);
//     await _prefs.remove(_keyUserProfilePicture);
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserUsername = 'user_username';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserProfilePicture = 'user_profile_picture';

  // ✅ ADD THIS (token key)
  static const String _keyAuthToken = 'auth_token';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  /// ✅ Works for both OLD + NEW calls.
  /// username is optional now, so old auth code won't crash.
  /// ✅ Added token optional (so old code still works)
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    String? username,
    String? phoneNumber,
    String? profilePicture,

    // ✅ NEW (optional)
    String? token,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);

    // keep existing username if not provided
    final existingUsername = _prefs.getString(_keyUserUsername);
    final safeUsername = (username != null && username.trim().isNotEmpty)
        ? username.trim()
        : (existingUsername ?? '');
    await _prefs.setString(_keyUserUsername, safeUsername);

    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber.trim());
    } else {
      await _prefs.remove(_keyUserPhoneNumber);
    }

    if (profilePicture != null && profilePicture.trim().isNotEmpty) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture.trim());
    } else {
      await _prefs.remove(_keyUserProfilePicture);
    }

    // ✅ SAVE TOKEN if provided
    if (token != null && token.trim().isNotEmpty) {
      await _prefs.setString(_keyAuthToken, token.trim());
    }
  }

  /// ✅ For profile update only (no username/userId change)
  Future<void> updateProfileSession({
    required String fullName,
    required String email,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);

    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber.trim());
    } else {
      await _prefs.remove(_keyUserPhoneNumber);
    }

    if (profilePicture != null && profilePicture.trim().isNotEmpty) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture.trim());
    } else {
      await _prefs.remove(_keyUserProfilePicture);
    }
  }

  // ✅ Token helpers (needed for Order sync + place order)
  String? getToken() => _prefs.getString(_keyAuthToken);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyAuthToken, token.trim());
  }

  bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

  String? getCurrentUserId() => _prefs.getString(_keyUserId);
  String? getCurrentUserEmail() => _prefs.getString(_keyUserEmail);
  String? getCurrentUserFullName() => _prefs.getString(_keyUserFullName);
  String? getCurrentUserUsername() => _prefs.getString(_keyUserUsername);
  String? getCurrentUserPhoneNumber() => _prefs.getString(_keyUserPhoneNumber);
  String? getCurrentUserProfilePicture() =>
      _prefs.getString(_keyUserProfilePicture);

  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserUsername);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserProfilePicture);

    // ✅ clear token
    await _prefs.remove(_keyAuthToken);
  }
}