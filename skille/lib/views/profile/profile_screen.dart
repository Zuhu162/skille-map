import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'friends_list_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String? userId; // If null, displays current user's profile

  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  User? _user;
  bool _isFriend = false;
  bool _hasSentRequest = false;
  late final bool _isCurrentUser;
  bool _isGridView = true; // Toggle between grid and list view

  // Mock posts data
  final List<Map<String, dynamic>> _posts = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'caption': 'Professional moving service',
      'likes': 124,
      'comments': 8,
      'date': '2024-03-15',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1534261368209-cf1dec6798c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'caption': 'Office relocation made easy',
      'likes': 89,
      'comments': 5,
      'date': '2024-03-14',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1578575437130-527eed3abbec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'caption': 'Safe and secure transport',
      'likes': 156,
      'comments': 12,
      'date': '2024-03-13',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1615873968403-89e068629265?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1632&q=80',
      'caption': 'Special care for fragile items',
      'likes': 203,
      'comments': 15,
      'date': '2024-03-12',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1513467535987-fd81bc7d62f8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'caption': 'Weekend moving services available',
      'likes': 178,
      'comments': 9,
      'date': '2024-03-11',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (widget.userId == null) {
        // View current user profile
        _user = authProvider.user;
        _isCurrentUser = true;
      } else {
        // View someone else's profile
        // In a real app, fetch the user data from a service
        // For now, we'll mock this data
        _isCurrentUser = widget.userId == authProvider.user?.id;

        // Mock user data for demonstration
        if (!_isCurrentUser) {
          // Using mock data based on userId to simulate different users
          if (widget.userId == '1') {
            _user = User(
              id: '1',
              name: 'Sarah Johnson',
              email: 'sarah@example.com',
              phoneNumber: '+6012-345-6789',
              isServiceProvider: true,
              bio:
                  '5 years experience as a professional driver specializing in transport services. UTM graduate in logistics management.',
            );
            _isFriend = false;
          } else if (widget.userId == '2') {
            _user = User(
              id: '2',
              name: 'Michael Chen',
              email: 'michael@example.com',
              phoneNumber: '+6012-876-5432',
              isServiceProvider: true,
              bio:
                  'Professional mover with full equipment. Specializing in home and office relocations. UTM alumnus with business management degree.',
            );
            _isFriend = true; // This user is already a friend
          } else if (widget.userId == '3') {
            _user = User(
              id: '3',
              name: 'Jessica Lee',
              email: 'jessica@example.com',
              phoneNumber: '+6019-765-4321',
              isServiceProvider: true,
              bio:
                  'Math and Science tutor with teaching license. UTM graduate in education with 4 years of tutoring experience.',
            );
            _isFriend = false;
            _hasSentRequest = true; // Already sent a friend request
          } else if (widget.userId == '4') {
            _user = User(
              id: '4',
              name: 'David Kim',
              email: 'david@example.com',
              phoneNumber: '+6017-123-4567',
              isServiceProvider: true,
              bio:
                  'Trained chef with 8 years of experience specializing in Asian cuisine. UTM culinary arts graduate.',
            );
            _isFriend = false;
          } else if (widget.userId == '5') {
            _user = User(
              id: '5',
              name: 'Emily Wilson',
              email: 'emily@example.com',
              phoneNumber: '+6018-234-5678',
              isServiceProvider: true,
              bio:
                  'Professional photographer with published work. UTM fine arts graduate specializing in portrait and event photography.',
            );
            _isFriend = false;
          } else if (widget.userId == '6') {
            _user = User(
              id: '6',
              name: 'Daniel Martinez',
              email: 'daniel@example.com',
              phoneNumber: '+6013-345-6789',
              isServiceProvider: true,
              bio:
                  'Local tour guide with extensive knowledge of the city. UTM tourism management graduate offering city walking tours.',
            );
            _isFriend = false;
          } else if (widget.userId == '7') {
            _user = User(
              id: '7',
              name: 'Sofia Garcia',
              email: 'sofia@example.com',
              phoneNumber: '+6012-987-6543',
              isServiceProvider: true,
              bio:
                  'Food and cultural tour guide. UTM graduate in cultural studies with passion for local cuisine and history.',
            );
            _isFriend = true; // This user is already a friend
          } else {
            // Default user if ID doesn't match
            _user = User(
              id: widget.userId!,
              name: 'User ${widget.userId}',
              email: 'user${widget.userId}@example.com',
              phoneNumber: '+601X-XXX-XXXX',
              isServiceProvider: true,
              bio: 'UTM service provider',
            );
            _isFriend = false;
          }
        } else {
          _user = authProvider.user;
        }
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    if (result == true) {
      _loadUserData();
    }
  }

  void _navigateToFriendsList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FriendsListScreen()),
    );
  }

  void _sendFriendRequest() {
    setState(() {
      _hasSentRequest = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request sent to ${_user!.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _acceptFriendRequest() {
    setState(() {
      _isFriend = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are now friends with ${_user!.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeFriend() {
    setState(() {
      _isFriend = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_user!.name} removed from friends'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // In a real app, upload the image to a server
        // For now, just show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('User not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isCurrentUser ? 'My Profile' : _user!.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          if (_isCurrentUser)
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              onPressed: _uploadImage,
              tooltip: 'Upload Image',
            ),
          if (_isCurrentUser)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEditProfile,
              tooltip: 'Edit Profile',
            ),
          if (_isCurrentUser)
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: _navigateToFriendsList,
              tooltip: 'Friends List',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 16),
                    _buildProfileStats(),
                    if (!_isCurrentUser) ...[
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                    ],
                    const SizedBox(height: 16),
                    _buildBioSection(),
                    const SizedBox(height: 16),
                    _buildViewToggle(),
                  ],
                ),
              ),
            ),
            _isGridView ? _buildGridPosts() : _buildListPosts(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    // Create a random profile image based on userId
    final String imageUrl = _user!.id == '1'
        ? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=688&q=80'
        : _user!.id == '2'
            ? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'
            : _user!.id == '3'
                ? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'
                : _user!.id == '4'
                    ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'
                    : _user!.id == '5'
                        ? 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'
                        : _user!.id == '6'
                            ? 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80'
                            : _user!.id == '7'
                                ? 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80'
                                : 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

    return Column(
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.grey.shade200,
                onBackgroundImageError: (_, __) {
                  // Fallback for image loading error
                },
              ),
              const SizedBox(height: 16),
              Text(
                _user!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _user!.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (_user!.isServiceProvider)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn('Posts', _posts.length.toString()),
        _buildStatColumn('Friends', '286'),
        _buildStatColumn('Rating', '4.8'),
      ],
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.grid_on,
            color: _isGridView ? Colors.green : Colors.grey,
          ),
          onPressed: () => setState(() => _isGridView = true),
        ),
        IconButton(
          icon: Icon(
            Icons.view_list,
            color: !_isGridView ? Colors.green : Colors.grey,
          ),
          onPressed: () => setState(() => _isGridView = false),
        ),
      ],
    );
  }

  Widget _buildGridPosts() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts[index];
          return GestureDetector(
            onTap: () => _showPostDetails(post),
            child: Image.network(
              post['imageUrl'] as String,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  Widget _buildListPosts() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  post['imageUrl'] as String,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['caption'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.favorite,
                              color: Colors.red.shade400, size: 20),
                          const SizedBox(width: 4),
                          Text('${post['likes']}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.comment_outlined, size: 20),
                          const SizedBox(width: 4),
                          Text('${post['comments']}'),
                          const Spacer(),
                          Text(
                            post['date'] as String,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  void _showPostDetails(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              post['imageUrl'] as String,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            Text(
              post['caption'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red.shade400),
                const SizedBox(width: 4),
                Text('${post['likes']} likes'),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined),
                const SizedBox(width: 4),
                Text('${post['comments']} comments'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Posted on ${post['date']}',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _user!.bio ?? 'No bio provided',
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_isFriend) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _removeFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Remove Friend'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message functionality not implemented'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Message'),
            ),
          ),
        ],
      );
    } else if (_hasSentRequest) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: null, // Disabled
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: Colors.grey,
            disabledForegroundColor: Colors.grey.shade400,
          ),
          child: const Text('Friend Request Sent'),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _sendFriendRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('Send Friend Request'),
        ),
      );
    }
  }
}
