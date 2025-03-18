import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/service.dart';
import 'api_interface.dart';

class MockApiService implements ApiInterface {
  final storage = FlutterSecureStorage();

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Mock services data with realistic content and images for our new categories
  final List<Map<String, dynamic>> _services = [
    // Transport services
    {
      '_id': 't1',
      'provider': {
        '_id': 'u1',
        'name': 'Sarah Johnson',
        'email': 'sarah@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=688&q=80',
      },
      'type': 'transport',
      'title': 'Airport Transfer Service',
      'description':
          'Reliable airport pickup and dropoff services with comfortable vehicles and experienced drivers.',
      'rate': 35.0,
      'availability': 'Mon-Sun, 24/7',
      'media': [
        'https://images.unsplash.com/photo-1549927681-0b673b8243ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'vehicle': 'Sedan/SUV available',
        'capacity': '4 passengers with luggage',
        'features': ['Air conditioning', 'Free WiFi', 'Bottled water']
      },
      'ratings': [
        {
          'user': {'_id': 'u5'},
          'rating': 5.0,
          'review': 'On time and very professional service.'
        },
        {
          'user': {'_id': 'u6'},
          'rating': 4.5,
          'review': 'Great experience, clean car and friendly driver.'
        }
      ],
      'createdAt': '2023-04-01T10:30:00.000Z',
    },
    {
      '_id': 't2',
      'provider': {
        '_id': 'u3',
        'name': 'Michael Chen',
        'email': 'michael@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'transport',
      'title': 'City Rideshare & Taxi Service',
      'description':
          'Quick and affordable ridesharing within the city limits. Professional and punctual service.',
      'rate': 25.0,
      'availability': 'Mon-Sun, 6am-11pm',
      'media': [
        'https://images.unsplash.com/photo-1590361232060-61b9a025a068?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2073&q=80',
      ],
      'details': {
        'vehicle': 'Compact car',
        'payment': 'Cash and card accepted',
        'features': ['Air conditioning', 'Phone chargers']
      },
      'ratings': [
        {
          'user': {'_id': 'u7'},
          'rating': 4.8,
          'review': 'Arrived promptly and got me to my destination safely.'
        }
      ],
      'createdAt': '2023-04-10T15:45:00.000Z',
    },

    // Moving services
    {
      '_id': 'm1',
      'provider': {
        '_id': 'u2',
        'name': 'Michael Chen',
        'email': 'michael@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'moving',
      'title': 'Professional Home Moving',
      'description':
          'Full-service home moving including packing, transportation, and unpacking. We handle your belongings with care.',
      'rate': 120.0,
      'availability': 'Mon-Sat, 8am-6pm',
      'media': [
        'https://images.unsplash.com/photo-1600518464441-7960ef6f7e5f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1534565337904-78df6d2cb4e7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'crew': '2-4 people',
        'vehicle': 'Moving truck with lift gate',
        'insurance': 'Full coverage for your belongings'
      },
      'ratings': [
        {
          'user': {'_id': 'u8'},
          'rating': 4.9,
          'review':
              'Excellent service! Very careful with our furniture and efficient.'
        },
        {
          'user': {'_id': 'u9'},
          'rating': 4.5,
          'review': 'Great crew, moved everything quickly and without damage.'
        }
      ],
      'createdAt': '2023-03-15T12:00:00.000Z',
    },
    {
      '_id': 'm2',
      'provider': {
        '_id': 'u4',
        'name': 'Emily Wilson',
        'email': 'emily@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'moving',
      'title': 'Office Relocation Services',
      'description':
          'Specialized in moving offices and businesses with minimal downtime. Weekend moves available.',
      'rate': 150.0,
      'availability': 'Mon-Sun, by appointment',
      'media': [
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'expertise': 'IT equipment, furniture, documents',
        'planning': 'Pre-move consultation included',
        'services': ['Packing', 'Furniture assembly', 'Equipment setup']
      },
      'ratings': [
        {
          'user': {'_id': 'u10'},
          'rating': 4.7,
          'review':
              'Helped us move our entire office over a weekend. Back up and running by Monday!'
        }
      ],
      'createdAt': '2023-03-20T09:15:00.000Z',
    },

    // Tutoring services
    {
      '_id': 'tu1',
      'provider': {
        '_id': 'u3',
        'name': 'Jessica Lee',
        'email': 'jessica@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'tutoring',
      'title': 'Math & Science Tutoring',
      'description':
          'Expert tutoring in mathematics, physics, and chemistry for high school and college students.',
      'rate': 50.0,
      'availability': 'Weekdays 3pm-8pm, Weekends 10am-4pm',
      'media': [
        'https://images.unsplash.com/photo-1607453998774-d533f65dac99?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'subjects': ['Algebra', 'Calculus', 'Physics', 'Chemistry'],
        'credentials': 'MS in Mathematics, 5 years teaching experience',
        'method': 'In-person or online sessions available'
      },
      'ratings': [
        {
          'user': {'_id': 'u11'},
          'rating': 5.0,
          'review':
              'Jessica helped my daughter improve her calculus grade from C to A in just two months!'
        },
        {
          'user': {'_id': 'u12'},
          'rating': 4.8,
          'review': 'Very patient and knowledgeable tutor. Highly recommend.'
        }
      ],
      'createdAt': '2023-02-10T14:30:00.000Z',
    },
    {
      '_id': 'tu2',
      'provider': {
        '_id': 'u5',
        'name': 'David Kim',
        'email': 'david@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'tutoring',
      'title': 'Language & ESL Tutoring',
      'description':
          'Conversational and academic language tutoring in Spanish, French, and ESL for all ages and levels.',
      'rate': 45.0,
      'availability': 'Flexible schedule, 7 days a week',
      'media': [
        'https://images.unsplash.com/photo-1543269865-cbf427effbad?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'languages': ['Spanish', 'French', 'English (ESL)'],
        'focus': 'Conversation, grammar, writing, test preparation',
        'experience':
            'Certified language instructor with international experience'
      },
      'ratings': [
        {
          'user': {'_id': 'u13'},
          'rating': 4.6,
          'review':
              'David makes learning Spanish fun and practical. Great tutor!'
        }
      ],
      'createdAt': '2023-02-20T11:45:00.000Z',
    },

    // Cooking services
    {
      '_id': 'c1',
      'provider': {
        '_id': 'u4',
        'name': 'David Kim',
        'email': 'david@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'cooking',
      'title': 'Personal Chef Service',
      'description':
          'Private chef service for special occasions, dinner parties, or regular meal prep. Customized menus based on preferences.',
      'rate': 85.0,
      'availability':
          'Evenings and weekends, book at least 48 hours in advance',
      'media': [
        'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1507048331197-7d4ac70811cf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2074&q=80',
      ],
      'details': {
        'cuisine': ['Asian', 'Mediterranean', 'American', 'Vegetarian/Vegan'],
        'services': 'Shopping, cooking, serving, cleanup',
        'experience': 'Trained chef with 8 years of restaurant experience'
      },
      'ratings': [
        {
          'user': {'_id': 'u14'},
          'rating': 4.9,
          'review':
              'David prepared an amazing anniversary dinner for us. The food was restaurant quality!'
        },
        {
          'user': {'_id': 'u15'},
          'rating': 4.7,
          'review':
              'Hired for a dinner party and everyone was impressed. Will use again!'
        }
      ],
      'createdAt': '2023-01-15T18:00:00.000Z',
    },
    {
      '_id': 'c2',
      'provider': {
        '_id': 'u6',
        'name': 'Maria Rodriguez',
        'email': 'maria@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=761&q=80',
      },
      'type': 'cooking',
      'title': 'Cooking Classes & Workshops',
      'description':
          'Hands-on cooking classes for individuals or small groups. Learn new cuisines, techniques, and recipes in a fun environment.',
      'rate': 60.0,
      'availability': 'Weekends and select weekday evenings',
      'media': [
        'https://images.unsplash.com/photo-1556911073-a517e752729c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'class size': '1-6 people',
        'duration': '2-3 hours per class',
        'includes': 'All ingredients, equipment, recipes to take home'
      },
      'ratings': [
        {
          'user': {'_id': 'u16'},
          'rating': 4.8,
          'review':
              'Took Maria\'s pasta making class and it was fantastic! Very hands-on and informative.'
        }
      ],
      'createdAt': '2023-01-25T16:30:00.000Z',
    },

    // Photography services
    {
      '_id': 'p1',
      'provider': {
        '_id': 'u5',
        'name': 'Emily Wilson',
        'email': 'emily@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'photography',
      'title': 'Portrait & Family Photography',
      'description':
          'Professional portrait photography for individuals, couples, and families. Indoor studio or outdoor natural light sessions available.',
      'rate': 60.0,
      'availability': 'Weekends and weekday evenings',
      'media': [
        'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'session': '1-2 hours',
        'includes': '20-30 edited digital photos',
        'equipment': 'Professional DSLR camera and lighting'
      },
      'ratings': [
        {
          'user': {'_id': 'u17'},
          'rating': 5.0,
          'review':
              'Emily captured our family perfectly! The photos are beautiful and natural.'
        },
        {
          'user': {'_id': 'u18'},
          'rating': 4.8,
          'review':
              'Professional, patient with our kids, and delivered stunning photos.'
        }
      ],
      'createdAt': '2022-12-10T13:00:00.000Z',
    },
    {
      '_id': 'p2',
      'provider': {
        '_id': 'u7',
        'name': 'James Wilson',
        'email': 'james@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'photography',
      'title': 'Event & Wedding Photography',
      'description':
          'Capturing special events and weddings with a documentary style approach. Focusing on candid moments and emotions.',
      'rate': 120.0,
      'availability': 'Booking at least 1 month in advance',
      'media': [
        'https://images.unsplash.com/photo-1537633552985-df8429cb55a9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'coverage': '4-8 hours',
        'deliverables': 'Online gallery, high-resolution digital files',
        'experience': 'Over 50 weddings and events covered'
      },
      'ratings': [
        {
          'user': {'_id': 'u19'},
          'rating': 4.9,
          'review':
              'James photographed our wedding and the photos are everything we hoped for. Highly recommend!'
        }
      ],
      'createdAt': '2022-12-20T10:45:00.000Z',
    },

    // Tour Guide services
    {
      '_id': 'tg1',
      'provider': {
        '_id': 'u6',
        'name': 'Daniel Martinez',
        'email': 'daniel@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      },
      'type': 'tour_guide',
      'title': 'City Walking Tours',
      'description':
          'Guided walking tours exploring the history, architecture, and hidden gems of the city. Small groups for a personalized experience.',
      'rate': 40.0,
      'availability': 'Daily, 9am and 2pm departures',
      'media': [
        'https://images.unsplash.com/photo-1473163928189-364b2c4e1135?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1579282240050-352db0a14c21?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2952&q=80',
      ],
      'details': {
        'duration': '2-3 hours',
        'distance': 'Approximately 2 miles of walking',
        'group size': 'Maximum 8 people'
      },
      'ratings': [
        {
          'user': {'_id': 'u20'},
          'rating': 4.8,
          'review':
              'Daniel is incredibly knowledgeable about the city\'s history. Learned so much on our tour!'
        },
        {
          'user': {'_id': 'u21'},
          'rating': 4.7,
          'review':
              'Great tour! Saw places we would have never found on our own.'
        }
      ],
      'createdAt': '2022-11-15T09:30:00.000Z',
    },
    {
      '_id': 'tg2',
      'provider': {
        '_id': 'u7',
        'name': 'Sofia Garcia',
        'email': 'sofia@example.com',
        'avatar':
            'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
      },
      'type': 'tour_guide',
      'title': 'Food & Cultural Tours',
      'description':
          'Explore local cuisine and culture through guided tours of markets, restaurants, and food districts. Includes multiple tastings.',
      'rate': 65.0,
      'availability': 'Tuesdays, Thursdays, and Saturdays',
      'media': [
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      ],
      'details': {
        'duration': '3-4 hours',
        'includes': '5-7 food tastings, cultural insights',
        'suitability':
            'Vegetarian options available, please advise dietary restrictions'
      },
      'ratings': [
        {
          'user': {'_id': 'u22'},
          'rating': 4.9,
          'review':
              'Sofia\'s food tour was a highlight of our trip! Delicious tastings and fascinating stories about the local cuisine.'
        }
      ],
      'createdAt': '2022-11-25T14:15:00.000Z',
    },
  ];

  // Mock users data
  final List<Map<String, dynamic>> _users = [
    {
      '_id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'phoneNumber': '1234567890',
      'isServiceProvider': true,
      'bio': 'I am a service provider',
      'friends': [],
      'friendRequests': [],
    },
    {
      '_id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phoneNumber': '0987654321',
      'isServiceProvider': false,
      'bio': 'Regular user',
      'friends': [],
      'friendRequests': [],
    }
  ];

  String? _currentUserId;

  @override
  Future<String?> getToken() async {
    return await storage.read(key: 'mock_token');
  }

  @override
  Future<void> saveToken(String token) async {
    await storage.write(key: 'mock_token', value: token);
  }

  @override
  Future<void> deleteToken() async {
    await storage.delete(key: 'mock_token');
    _currentUserId = null;
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email,
      String password, String phoneNumber, bool isServiceProvider) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Check if user exists
    if (_users.any((user) => user['email'] == email)) {
      throw Exception('User already exists');
    }

    final newUser = {
      '_id': (_users.length + 1).toString(),
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isServiceProvider': isServiceProvider,
      'bio': '',
      'friends': [],
      'friendRequests': [],
    };

    _users.add(newUser);
    _currentUserId = newUser['_id'] as String;

    const token = 'mock-token-12345';
    await saveToken(token);

    return {
      'token': token,
      'user': newUser,
    };
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    final user = _users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => throw Exception('Invalid credentials'),
    );

    _currentUserId = user['_id'] as String;

    const token = 'mock-token-12345';
    await saveToken(token);

    return {
      'token': token,
      'user': user,
    };
  }

  @override
  Future<void> logout() async {
    await deleteToken();
  }

  @override
  Future<User> getProfile() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final userData = _users.firstWhere(
      (user) => user['_id'] == _currentUserId,
      orElse: () => throw Exception('User not found'),
    );

    return User.fromJson(userData);
  }

  @override
  Future<User> updateProfile(Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final userIndex =
        _users.indexWhere((user) => user['_id'] == _currentUserId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    // Update user data
    _users[userIndex] = {
      ..._users[userIndex],
      ...data,
    };

    return User.fromJson(_users[userIndex]);
  }

  @override
  Future<List<Service>> getServices({String? type}) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    List<Map<String, dynamic>> filteredServices = type != null
        ? _services.where((service) => service['type'] == type).toList()
        : List.from(_services);

    return filteredServices.map((service) {
      // Resolve provider data
      final provider = _users.firstWhere(
        (user) => user['_id'] == service['provider']['_id'],
        orElse: () => {'_id': service['provider']['_id']},
      );

      return Service.fromJson({
        ...service,
        'provider': provider,
      });
    }).toList();
  }

  @override
  Future<Service> getServiceById(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    final serviceData = _services.firstWhere(
      (service) => service['_id'] == id,
      orElse: () => throw Exception('Service not found'),
    );

    // Resolve provider data
    final provider = _users.firstWhere(
      (user) => user['_id'] == serviceData['provider']['_id'],
      orElse: () => {'_id': serviceData['provider']['_id']},
    );

    return Service.fromJson({
      ...serviceData,
      'provider': provider,
    });
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
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    // Check if user is service provider
    final user = _users.firstWhere(
      (user) => user['_id'] == _currentUserId,
      orElse: () => throw Exception('User not found'),
    );

    if (user['isServiceProvider'] != true) {
      throw Exception('User is not a service provider');
    }

    final newService = {
      '_id': (_services.length + 1).toString(),
      'provider': _currentUserId,
      'type': type,
      'title': title,
      'description': description,
      'rate': rate,
      'availability': availability,
      'media': media
          .map((file) => 'mock-media-path/${file.path.split('/').last}')
          .toList(),
      'details': details ?? {},
      'ratings': [],
      'createdAt': DateTime.now().toIso8601String(),
    };

    _services.add(newService);

    return Service.fromJson({
      ...newService,
      'provider': user,
    });
  }

  @override
  Future<Service> updateService(
      String id, Map<String, dynamic> data, List<File>? media) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final serviceIndex =
        _services.indexWhere((service) => service['_id'] == id);
    if (serviceIndex == -1) {
      throw Exception('Service not found');
    }

    if (_services[serviceIndex]['provider'] != _currentUserId) {
      throw Exception('Not authorized');
    }

    // Update service data
    _services[serviceIndex] = {
      ..._services[serviceIndex],
      ...data,
    };

    if (media != null) {
      _services[serviceIndex]['media'] = media
          .map((file) => 'mock-media-path/${file.path.split('/').last}')
          .toList();
    }

    // Resolve provider data
    final provider = _users.firstWhere(
      (user) => user['_id'] == _services[serviceIndex]['provider'],
      orElse: () => {'_id': _services[serviceIndex]['provider']},
    );

    return Service.fromJson({
      ..._services[serviceIndex],
      'provider': provider,
    });
  }

  @override
  Future<void> deleteService(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final serviceIndex =
        _services.indexWhere((service) => service['_id'] == id);
    if (serviceIndex == -1) {
      throw Exception('Service not found');
    }

    if (_services[serviceIndex]['provider'] != _currentUserId) {
      throw Exception('Not authorized');
    }

    _services.removeAt(serviceIndex);
  }

  @override
  Future<Service> rateService(String id, double rating, String? review) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final serviceIndex =
        _services.indexWhere((service) => service['_id'] == id);
    if (serviceIndex == -1) {
      throw Exception('Service not found');
    }

    if (_services[serviceIndex]['provider'] == _currentUserId) {
      throw Exception('You cannot rate your own service');
    }

    final ratings =
        List<Map<String, dynamic>>.from(_services[serviceIndex]['ratings']);

    final ratingIndex = ratings.indexWhere((r) => r['user'] == _currentUserId);
    if (ratingIndex != -1) {
      ratings[ratingIndex] = {
        'user': _currentUserId,
        'rating': rating,
        'review': review,
      };
    } else {
      ratings.add({
        'user': _currentUserId,
        'rating': rating,
        'review': review,
      });
    }

    _services[serviceIndex]['ratings'] = ratings;

    // Resolve provider data
    final provider = _users.firstWhere(
      (user) => user['_id'] == _services[serviceIndex]['provider'],
      orElse: () => {'_id': _services[serviceIndex]['provider']},
    );

    return Service.fromJson({
      ..._services[serviceIndex],
      'provider': provider,
    });
  }

  @override
  Future<void> sendFriendRequest(String userId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    if (userId == _currentUserId) {
      throw Exception('You cannot send a friend request to yourself');
    }

    final userIndex = _users.indexWhere((user) => user['_id'] == userId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final currentUserIndex =
        _users.indexWhere((user) => user['_id'] == _currentUserId);

    // Check if already friends
    if (_users[currentUserIndex]['friends'].contains(userId)) {
      throw Exception('Users are already friends');
    }

    // Check if request already sent
    final List<Map<String, dynamic>> requests =
        List.from(_users[userIndex]['friendRequests']);
    if (requests.any((request) => request['from'] == _currentUserId)) {
      throw Exception('Friend request already sent');
    }

    requests.add({
      'from': _currentUserId,
      'status': 'pending',
    });

    _users[userIndex]['friendRequests'] = requests;
  }

  @override
  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final userIndex =
        _users.indexWhere((user) => user['_id'] == _currentUserId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final List<Map<String, dynamic>> requests =
        List.from(_users[userIndex]['friendRequests']);

    // Resolve 'from' user data
    return requests.map((request) {
      final fromUser = _users.firstWhere(
        (user) => user['_id'] == request['from'],
        orElse: () =>
            {'_id': request['from'], 'name': 'Unknown User', 'email': ''},
      );

      return {
        ...request,
        'from': fromUser,
      };
    }).toList();
  }

  @override
  Future<void> respondToFriendRequest(String requestId, String status) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    if (status != 'accepted' && status != 'rejected') {
      throw Exception('Invalid status');
    }

    final userIndex =
        _users.indexWhere((user) => user['_id'] == _currentUserId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final List<Map<String, dynamic>> requests =
        List.from(_users[userIndex]['friendRequests']);
    final requestIndex = requests.indexWhere((r) => r['_id'] == requestId);

    if (requestIndex == -1) {
      throw Exception('Friend request not found');
    }

    requests[requestIndex]['status'] = status;

    if (status == 'accepted') {
      // Add to friends list
      final fromUserId = requests[requestIndex]['from'] as String;

      // Add to current user's friends
      final List<String> currentUserFriends =
          List.from(_users[userIndex]['friends']);
      currentUserFriends.add(fromUserId);
      _users[userIndex]['friends'] = currentUserFriends;

      // Add to requester's friends
      final requesterIndex =
          _users.indexWhere((user) => user['_id'] == fromUserId);
      if (requesterIndex != -1) {
        final List<String> requesterFriends =
            List.from(_users[requesterIndex]['friends']);
        requesterFriends.add(_currentUserId!);
        _users[requesterIndex]['friends'] = requesterFriends;
      }
    }

    _users[userIndex]['friendRequests'] = requests;
  }

  @override
  Future<List<Map<String, dynamic>>> getFriends() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw Exception('Not authenticated');
    }

    final userIndex =
        _users.indexWhere((user) => user['_id'] == _currentUserId);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    final List<String> friendIds = List.from(_users[userIndex]['friends']);

    return friendIds.map((friendId) {
      return _users.firstWhere(
        (user) => user['_id'] == friendId,
        orElse: () => {
          '_id': friendId,
          'name': 'Unknown User',
          'email': '',
          'phoneNumber': ''
        },
      );
    }).toList();
  }
}
