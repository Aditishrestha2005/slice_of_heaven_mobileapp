import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final orderRemoteDatasourceProvider = Provider<OrderRemoteDatasource>((ref) {
  return OrderRemoteDatasource(
    client: http.Client(),
    baseUrl: "http://10.0.2.2:5000", // emulator
  );
});

class OrderRemoteDatasource {
  final http.Client client;
  final String baseUrl;

  OrderRemoteDatasource({
    required this.client,
    required this.baseUrl,
  });

  Map<String, String> _headers(String token) => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

  Future<Map<String, dynamic>> createOrder({
    required String token,
    required List<Map<String, dynamic>> items,
    required String fullName,
    required String phone,
    required String address,
    String? note,
  }) async {
    final res = await client.post(
      Uri.parse("$baseUrl/api/orders"), // ✅ FIXED
      headers: _headers(token),
      body: jsonEncode({
        "items": items,
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "note": note,
      }),
    );

    print("ORDER STATUS CODE: ${res.statusCode}");
    print("ORDER RESPONSE BODY: ${res.body}");

    final decoded = jsonDecode(res.body);

    if (res.statusCode != 201) {
      throw Exception(decoded["message"] ?? "Create order failed");
    }

    return (decoded["data"] as Map).cast<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> getMyOrders(String token) async {
    final res = await client.get(
      Uri.parse("$baseUrl/api/orders/my"), // ✅ FIXED
      headers: _headers(token),
    );

    print("GET ORDERS STATUS: ${res.statusCode}");
    print("GET ORDERS BODY: ${res.body}");

    final decoded = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(decoded["message"] ?? "Fetch orders failed");
    }

    return (decoded["data"] as List).cast<Map<String, dynamic>>();
  }
}