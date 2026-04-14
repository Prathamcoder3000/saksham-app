import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // 🌐 DYNAMIC BASE URL
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api/v1';
    return (defaultTargetPlatform == TargetPlatform.android) 
      ? 'http://10.0.2.2:5000/api/v1' 
      : 'http://localhost:5000/api/v1';
  }

  static String get socketUrl {
    if (kIsWeb) return 'http://localhost:5000';
    return (defaultTargetPlatform == TargetPlatform.android) 
      ? 'http://10.0.2.2:5000' 
      : 'http://localhost:5000';
  }

  // Helper to get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Global callback for unauthorized access
  static VoidCallback? onUnauthorized;

  // GET Request with Caching
  static Future<http.Response> get(String endpoint) async {
    final token = await getToken();
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Cache successful GET requests
        await prefs.setString('cache_$endpoint', response.body);
      }

      _handleResponse(response);
      return response;
    } catch (e) {
      // Offline fallback: Return cached data if available
      final cachedData = prefs.getString('cache_$endpoint');
      if (cachedData != null) {
        print('Offline: Returning cached data for $endpoint');
        return http.Response(cachedData, 200, headers: {
          'Content-Type': 'application/json',
          'x-offline-cache': 'true',
        });
      }
      rethrow;
    }
  }

  // POST Request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    _handleResponse(response);
    return response;
  }

  // PUT Request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    _handleResponse(response);
    return response;
  }

  // DELETE Request
  static Future<http.Response> delete(String endpoint) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    _handleResponse(response);
    return response;
  }

  static void _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      if (onUnauthorized != null) {
        onUnauthorized!();
      }
    }
  }
}
