class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isServiceProvider;
  final String? bio;
  final List<String> friends;
  final List<FriendRequest> friendRequests;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isServiceProvider,
    this.bio,
    this.friends = const [],
    this.friendRequests = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isServiceProvider: json['isServiceProvider'] ?? false,
      bio: json['bio'],
      friends:
          json['friends'] != null ? List<String>.from(json['friends']) : [],
      friendRequests: json['friendRequests'] != null
          ? List<FriendRequest>.from(
              json['friendRequests'].map((x) => FriendRequest.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isServiceProvider': isServiceProvider,
      'bio': bio,
      'friends': friends,
      'friendRequests': friendRequests.map((x) => x.toJson()).toList(),
    };
  }
}

class FriendRequest {
  final String from;
  final String status;

  FriendRequest({
    required this.from,
    required this.status,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      from: json['from']['_id'] ?? json['from'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'status': status,
    };
  }
}
