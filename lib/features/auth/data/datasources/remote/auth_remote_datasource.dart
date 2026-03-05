import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/api/api_client.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/core/services/storage/token_service.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/auth/data/datasources/auth_datasource.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenService = tokenService;

  // ---------------- LOGIN ----------------
  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    if (response.data["success"] == true) {
      final user = AuthApiModel.fromJson(response.data["data"]);

      final token = (response.data["token"] ?? "").toString();
      if (token.isNotEmpty) {
        await _tokenService.saveToken(token);
      }

      await _userSessionService.saveUserSession(
        userId: user.id ?? "",
        email: user.email,
        fullName: user.fullName,
        username: user.username,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture,
      );

      return user;
    }
    return null;
  }

  // ---------------- REGISTER (🔥 FIXED) ----------------
  @override
  Future<AuthApiModel> register(
    AuthApiModel user, {
    required String password,
    required String confirmPassword,
  }) async {
    // 🔥 IMPORTANT: SEND PURE JSON (NOT FormData)
    final body = {
      "fullName": user.fullName,        // ✅ EXACT key backend expects
      "username": user.username,
      "email": user.email,
      "phoneNumber": user.phoneNumber,  // ✅ EXACT key
      "password": password,
      "confirmPassword": confirmPassword,
    };

    // 🧪 Debug (remove later if you want)
    print("REGISTER BODY => $body");

    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: body,
    );

    return AuthApiModel.fromJson(response.data["data"]);
  }

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    return null;
  }
}
