import 'dart:io';
import 'package:flutter/material.dart';
import '../models/service.dart';
import 'api_interface.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiInterface _apiService;
  List<Service> _services = [];
  bool _isLoading = false;
  String? _error;

  ServiceProvider({required ApiInterface apiService})
      : _apiService = apiService;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchServices({String? type}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _services = await _apiService.getServices(type: type);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Service>> getServicesByType(String? type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final services = await _apiService.getServices(type: type);
      _isLoading = false;
      notifyListeners();
      return services;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<Service?> getServiceDetail(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final service = await _apiService.getServiceById(id);
      _isLoading = false;
      notifyListeners();
      return service;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> createService(
      Map<String, dynamic> serviceData, List<File> media) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.createService(
        serviceData['type'],
        serviceData['title'],
        serviceData['description'],
        serviceData['rate'],
        serviceData['availability'],
        serviceData['details'],
        media,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
