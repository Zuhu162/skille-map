import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/service.dart';
import 'api_interface.dart';

class ApiService implements ApiInterface {
  final String baseUrl = 'http://10.0.2.2:5000/api';
  final storage = FlutterSecureStorage();

  @override
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  @override
  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  @override
  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<Map<String, String>> getHeaders() async {
    String? token = await getToken();
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email,
      String password, String phoneNumber, bool isServiceProvider) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'isServiceProvider': isServiceProvider,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      await saveToken(responseData['token']);
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await saveToken(responseData['token']);
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Login failed');
    }
  }

  @override
  Future<void> logout() async {
    await deleteToken();
  }

  @override
  Future<User> getProfile() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<User> updateProfile(Map<String, dynamic> data) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<List<Service>> getServices({String? type}) async {
    String url = '$baseUrl/services';
    if (type != null) {
      url += '?type=$type';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List services = jsonDecode(response.body);
      return services.map((service) => Service.fromJson(service)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load service');
    }
  }

  @override
  Future<Service> createService(
      String type,
      String title,
      String description,
      double rate,
      String? availability,
      Map<String, dynamic>? details,
      List<File> media) async {
    final headers = await getHeaders();
    var uri = Uri.parse('$baseUrl/services');
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'x-auth-token': headers['x-auth-token'] ?? '',
    });

    request.fields['type'] = type;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['rate'] = rate.toString();
    if (availability != null) request.fields['availability'] = availability;
    if (details != null) request.fields['details'] = jsonEncode(details);

    for (var file in media) {
      request.files.add(await http.MultipartFile.fromPath(
        'media',
        file.path,
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create service');
    }
  }

  @override
  Future<Service> updateService(
      String id, Map<String, dynamic> data, List<File>? media) async {
    final headers = await getHeaders();
    var uri = Uri.parse('$baseUrl/services/$id');
    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({
      'x-auth-token': headers['x-auth-token'] ?? '',
    });

    data.forEach((key, value) {
      if (value != null) {
        if (value is Map) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      }
    });

    if (media != null) {
      for (var file in media) {
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          file.path,
        ));
      }
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update service');
    }
  }

  @override
  Future<void> deleteService(String id) async {
    final headers = await getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/services/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service');
    }
  }

  @override
  Future<Service> rateService(String id, double rating, String? review) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/services/$id/rate'),
      headers: headers,
      body: jsonEncode({
        'rating': rating,
        'review': review,
      }),
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to rate service');
    }
  }

  @override
  Future<void> sendFriendRequest(String userId) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/friends/request'),
      headers: headers,
      body: jsonEncode({
        'userId': userId,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(
          responseData['message'] ?? 'Failed to send friend request');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/friends/requests'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List requests = jsonDecode(response.body);
      return requests.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load friend requests');
    }
  }

  @override
  Future<void> respondToFriendRequest(String requestId, String status) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/friends/respond'),
      headers: headers,
      body: jsonEncode({
        'requestId': requestId,
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(
          responseData['message'] ?? 'Failed to respond to friend request');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFriends() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/friends'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List friends = jsonDecode(response.body);
      return friends.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load friends');
    }
  }
}
