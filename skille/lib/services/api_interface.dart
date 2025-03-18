import 'dart:io';
import '../models/user.dart';
import '../models/service.dart';

abstract class ApiInterface {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();

  Future<Map<String, dynamic>> register(String name, String email,
      String password, String phoneNumber, bool isServiceProvider);

  Future<Map<String, dynamic>> login(String email, String password);

  Future<void> logout();

  Future<User> getProfile();

  Future<User> updateProfile(Map<String, dynamic> data);

  Future<List<Service>> getServices({String? type});

  Future<Service> getServiceById(String id);

  Future<Service> createService(
      String type,
      String title,
      String description,
      double rate,
      String? availability,
      Map<String, dynamic>? details,
      List<File> media);

  Future<Service> updateService(
      String id, Map<String, dynamic> data, List<File>? media);

  Future<void> deleteService(String id);

  Future<Service> rateService(String id, double rating, String? review);

  Future<void> sendFriendRequest(String userId);

  Future<List<Map<String, dynamic>>> getFriendRequests();

  Future<void> respondToFriendRequest(String requestId, String status);

  Future<List<Map<String, dynamic>>> getFriends();
}
