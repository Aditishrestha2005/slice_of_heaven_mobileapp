import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/api/api_client.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/features/home/data/datasources/home_data_source.dart';
import 'package:slice_of_heaven/features/home/data/models/pizza_api_model.dart';

final homeRemoteDatasourceProvider = Provider<IHomeRemoteDataSource>((ref) {
  return HomeRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class HomeRemoteDatasource implements IHomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDatasource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<PizzaApiModel>> getAllPizzas() async {
    try {
      final fullUrl = "${ApiEndpoints.baseUrl}${ApiEndpoints.pizzas}";
      print("🔥 FETCHING PIZZAS FROM => $fullUrl");

      final response = await _apiClient.get(ApiEndpoints.pizzas);

      print("🔥 STATUS CODE => ${response.statusCode}");
      print("🔥 RAW RESPONSE => ${response.data}");

      // Case A: { success: true, data: [...] }
      if (response.data is Map &&
          response.data['success'] == true &&
          response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => PizzaApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
        print("✅ PIZZAS COUNT => ${list.length}");
        return list;
      }

      // Case B: directly list
      if (response.data is List) {
        final list = (response.data as List)
            .map((e) => PizzaApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
        print("✅ PIZZAS COUNT (NO WRAPPER) => ${list.length}");
        return list;
      }

      print("⚠️ Unexpected response structure => ${response.data}");
      return [];
    } on DioException catch (e) {
      print("❌ DIO ERROR => ${e.message}");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");
      rethrow; // repository will catch and show in UI
    }
  }
}