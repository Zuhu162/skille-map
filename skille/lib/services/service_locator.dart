import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_interface.dart';
import 'api_service.dart';
import 'auth_provider.dart';
import 'service_provider.dart';
import 'friend_provider.dart';

class ServiceLocator {
  static ApiInterface _apiService = ApiService();

  // Method to change the implementation of ApiService
  static void switchApiImplementation(ApiInterface newImplementation) {
    _apiService = newImplementation;
  }

  // Method to get all providers for the app
  static List<ChangeNotifierProvider> getProviders() {
    return [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(apiService: _apiService),
      ),
      ChangeNotifierProvider<ServiceProvider>(
        create: (context) => ServiceProvider(apiService: _apiService),
      ),
      ChangeNotifierProvider<FriendProvider>(
        create: (context) => FriendProvider(apiService: _apiService),
      ),
    ];
  }
}
