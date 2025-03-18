import 'package:flutter/material.dart';
import '../models/user.dart';
import 'api_interface.dart';

class FriendProvider extends ChangeNotifier {
  final ApiInterface _apiService;
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _friendRequests = [];
  bool _isLoading = false;
  String? _error;

  FriendProvider({required ApiInterface apiService}) : _apiService = apiService;

  List<Map<String, dynamic>> get friends => _friends;
  List<Map<String, dynamic>> get friendRequests => _friendRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _friends = await _apiService.getFriends();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFriendRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _friendRequests = await _apiService.getFriendRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendFriendRequest(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.sendFriendRequest(userId);
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

  Future<bool> respondToFriendRequest(String requestId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.respondToFriendRequest(requestId, status);

      // Update friend requests list after response
      await fetchFriendRequests();

      if (status == 'accepted') {
        // If accepted, update friends list
        await fetchFriends();
      }

      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
