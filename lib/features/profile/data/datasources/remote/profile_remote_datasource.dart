import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/api/api_client.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/core/services/storage/token_service.dart';
import 'package:slice_of_heaven/features/profile/data/datasources/profile_datasource.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDataSource>((ref) {
  return ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<bool> updateProfileRemote({
    required String fullName,
    required String email,
    String? phoneNumber,
    File? profilePicture,
  }) async {
    final token = await _tokenService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token not found. Please login again.");
    }

    final formData = FormData.fromMap({
      "fullName": fullName,
      "email": email,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (profilePicture != null)
        "profilePicture": await MultipartFile.fromFile(
          profilePicture.path,
          filename: profilePicture.path.split("/").last,
        ),
    });

    // ✅ MUST BE POST (backend uses router.post)
    final response = await _apiClient.post(
      ApiEndpoints.updateProfile, // ✅ change endpoint name in ApiEndpoints
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return response.data["success"] == true;
  }
}
