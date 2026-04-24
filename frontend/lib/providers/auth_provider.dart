import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        _token = responseData['token'];
        _user = UserModel.fromJson(responseData['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('userData', jsonEncode(_user!.toJson()));
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  AuthProvider() {
    // Register global unauthorized callback
    ApiService.onUnauthorized = logout;
  }

  // Auto-login on app start
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;

    final token = prefs.getString('token');
    
    try {
      // Verify token with backend
      final response = await ApiService.get('/auth/me');
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = token;
        _user = UserModel.fromJson(responseData['data']);
        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      // If offline, trust local data for now but set token
      _token = token;
      if (prefs.containsKey('userData')) {
        final userData = jsonDecode(prefs.getString('userData')!);
        _user = UserModel.fromJson(userData);
      }
      notifyListeners();
      return true;
    }
  }

  // Update Profile
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await ApiService.put('/users/me', updateData);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        _user = UserModel.fromJson(responseData['data']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(_user!.toJson()));
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Update error: $e");
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
