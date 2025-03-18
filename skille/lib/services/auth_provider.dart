import 'package:flutter/material.dart';
import '../models/user.dart';
import 'api_interface.dart';

class AuthProvider extends ChangeNotifier {
  final ApiInterface _apiService;
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  AuthProvider({required ApiInterface apiService}) : _apiService = apiService;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiService.getToken();
      if (token != null) {
        _user = await _apiService.getProfile();
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _user = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password,
      String phoneNumber, bool isServiceProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.register(
          name, email, password, phoneNumber, isServiceProvider);
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _apiService.updateProfile(data);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();

    // In a real app, you would also call the API to persist changes
    // For now, this just updates the local state
  }
}
