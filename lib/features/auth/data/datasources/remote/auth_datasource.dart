import 'package:slice_of_heaven/features/auth/data/models/auth_api_model.dart';


abstract class IAuthRemoteDataSource {
  /// Register user via API
  Future<AuthApiModel> register(AuthApiModel user);

  /// Login user via API
  Future<AuthApiModel?> login(String email, String password);

  /// Get user by ID via API
  Future<AuthApiModel?> getUserById(String authId);
}
