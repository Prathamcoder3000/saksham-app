import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // 🌐 LIVE PRODUCTION BACKEND (Render)
  static String get baseUrl {
    return 'https://saksham-app.onrender.com/api/v1';
  }

  static String get socketUrl {
    return 'https://saksham-app.onrender.com';
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
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        await prefs.setString('cache_$endpoint', response.body);
      }

      _handleResponse(response);
      return response;
    } catch (e) {
      final cachedData = prefs.getString('cache_$endpoint');
      if (cachedData != null) {
        return http.Response(
          cachedData,
          200,
          headers: {
            'Content-Type': 'application/json',
            'x-offline-cache': 'true',
          },
        );
      }
      rethrow;
    }
  }

  // POST Request
  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> data) async {
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
  static Future<http.Response> put(
      String endpoint, Map<String, dynamic> data) async {
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

  // PATCH Request
  static Future<http.Response> patch(
      String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();

    final response = await http.patch(
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

  static void _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      if (onUnauthorized != null) {
        onUnauthorized!();
      }
    }
  }
}