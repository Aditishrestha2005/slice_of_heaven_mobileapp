import 'package:slice_of_heaven/features/auth/data/models/auth_api_model.dart';

/// ===============================
/// REMOTE DATASOURCE INTERFACE
/// ===============================
///
/// This file MUST contain ONLY remote-related interfaces.
/// Do NOT add local datasource here.
abstract class IAuthRemoteDataSource {
  /// Register user via API
  Future<AuthApiModel> register(AuthApiModel user);

  /// Login user via API
  Future<AuthApiModel?> login(String email, String password);

  /// Get user by ID via API
  Future<AuthApiModel?> getUserById(String authId);
}
