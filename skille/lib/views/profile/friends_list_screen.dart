import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock friends data
    final List<Map<String, dynamic>> friends = [
      {
        'id': '2',
        'name': 'Michael Chen',
        'specialty': 'Moving',
        'avatar':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
        'phone': '+6012-876-5432',
      },
      {
        'id': '7',
        'name': 'Sofia Garcia',
        'specialty': 'Tour Guide',
        'avatar':
            'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
        'phone': '+6012-987-6543',
      },
      {
        'id': '8',
        'name': 'Alex Thompson',
        'specialty': 'Photography',
        'avatar':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
        'phone': '+6017-765-4321',
      },
      {
        'id': '9',
        'name': 'Raj Patel',
        'specialty': 'Tutoring',
        'avatar':
            'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
        'phone': '+6019-543-2109',
      },
      {
        'id': '10',
        'name': 'Lisa Wang',
        'specialty': 'Transport',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
        'phone': '+6012-345-6789',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: friends.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No friends yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add friends to see them here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final friend = friends[index];
                return _buildFriendItem(context, friend);
              },
            ),
    );
  }

  Widget _buildFriendItem(BuildContext context, Map<String, dynamic> friend) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(friend['avatar'] as String),
        backgroundColor: Colors.grey.shade200,
      ),
      title: Text(
        friend['name'] as String,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Specializes in ${friend["specialty"]}',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 14, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                friend['phone'] as String,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.message, color: Colors.green),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Message ${friend['name']} functionality not implemented'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        tooltip: 'Message',
      ),
      onTap: () {
        // View profile on tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: friend['id'] as String),
          ),
        );
      },
    );
  }
}
