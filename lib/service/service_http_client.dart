import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  final String baseUrl = 'http://10.0.2.2:8000/api/';
  final secureStorage = FlutterSecureStorage();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getAuthToken() async {
    return await _secureStorage.read(key: "authToken");
  }

  Future<Map<String, String>> _getHeaders({bool includeToken = true}) async {
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (includeToken) {
      final token = await _getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        log('Auth Token being sent: $token');
      } else {
        log('Warning: No authentication token found for request.');
        // Melempar exception jika token tidak ada dan diperlukan
        throw Exception("Authentication token not found. Please log in.");
      }
    }
    return headers;
  }

  //POST
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      log('--- Received POST Response (No Token) ---');
      log('Status Code: ${response.statusCode}');
      log('Headers: ${response.headers}');
      log('Body: ${response.body}');
      return response;
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }

  //GET
  Future<http.Response> get(String endpoint) async {
    final token = await secureStorage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.get(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }

  //POST with token
  Future<http.Response> postWithToken(String url, dynamic body) async {
    final token = await secureStorage.read(key: "authToken");
    log('Auth Token being sent: $token'); // Tambahkan ini

    return http.post(
      Uri.parse(baseUrl + url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body is String ? body : json.encode(body),
    );
  }

  // PUT with token
  Future<http.Response> putWithToken(String endpoint, dynamic body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await _getHeaders(includeToken: true); // Dengan token

      // Pastikan body selalu di-encode ke JSON string jika bukan string
      final requestBody = (body is String) ? body : jsonEncode(body);

      // --- Log tambahan untuk debugging tipe data ---
      log('Debug (PUT): Type of "body" received: ${body.runtimeType}');
      log(
        'Debug (PUT): Type of "requestBody" (after encoding): ${requestBody.runtimeType}',
      );
      // --- End Log tambahan ---

      log('--- Sending PUT Request (With Token) ---');
      log('URL: $uri');
      log('Headers: $headers');
      log('Body: $requestBody'); // Log body yang sudah di-encode

      final response = await http.put(
        uri,
        headers: headers,
        body: requestBody, // Menggunakan JSON string
      );

      log('--- Received PUT Response (With Token) ---');
      log('Status Code: ${response.statusCode}');
      log('Headers: ${response.headers}');
      log('Body: ${response.body}');
      return response;
    } catch (e) {
      log('Error in PUT request (With Token) to $endpoint: $e');
      rethrow; // Melempar kembali exception
    }
  }

  // DELETE with token
  Future<http.Response> deleteWithToken(String url) async {
    final token = await secureStorage.read(key: "authToken");

    return http.delete(
      Uri.parse(baseUrl + url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getWithToken(String endpoint) async {
    final token = await secureStorage.read(key: "authToken");

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      log(
        'Warning: No authToken found for GET with token request to $endpoint',
      );
      throw Exception(
        "Authentication token not found. Cannot perform GET request.",
      );
    }

    final url = Uri.parse("$baseUrl$endpoint");

    log('--- Sending GET Request (With Token) ---');
    log('URL: $url');
    log('Headers: $headers');

    try {
      final response = await http.get(url, headers: headers);
      log('--- Received GET Response (With Token) ---');
      log('Status Code: ${response.statusCode}');
      log('Headers: ${response.headers}');
      log('Body: ${response.body}');
      return response;
    } catch (e) {
      log('Error in GET request (With Token): $e');
      throw Exception("GET request failed: $e");
    }
  }
}
