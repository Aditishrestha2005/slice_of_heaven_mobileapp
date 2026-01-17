import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/api/api_client.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/auth/data/datasources/remote/auth_datasource.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        username: user.username,
      );

      return AuthApiModel.fromEntity(user.toEntity());
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return AuthApiModel.fromEntity(registeredUser.toEntity());
    }

    return AuthApiModel.fromEntity(user.toEntity());
  }

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }
}
