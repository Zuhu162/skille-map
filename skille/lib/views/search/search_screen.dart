import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialFilter;

  const SearchScreen({super.key, this.initialFilter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Apply initial filter if provided
    if (widget.initialFilter != null) {
      setState(() {
        _selectedCategory = widget.initialFilter;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Service Providers'),
            Tab(text: 'By Username'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _tabController.index == 0
                    ? 'Search for service providers...'
                    : 'Search by username...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          if (_tabController.index == 0 && _selectedCategory == null)
            _buildCategoryFilters(),
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Chip(
                label: Text('Category: $_selectedCategory'),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                },
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _searchQuery.isEmpty && _selectedCategory == null
                    ? _buildAllProviders()
                    : _buildSearchResults(byUsername: false),
                _searchQuery.isEmpty
                    ? _buildAllProviders()
                    : _buildSearchResults(byUsername: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
      {'name': 'Moving', 'icon': Icons.home_work, 'color': Colors.orange},
      {'name': 'Tutoring', 'icon': Icons.school, 'color': Colors.purple},
      {'name': 'Cooking', 'icon': Icons.restaurant, 'color': Colors.red},
      {'name': 'Photography', 'icon': Icons.camera_alt, 'color': Colors.teal},
      {'name': 'Tour Guide', 'icon': Icons.explore, 'color': Colors.green},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'] as String;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAllProviders() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: allProviders.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final provider = allProviders[index];
        return _buildProviderCard(provider);
      },
    );
  }

  Widget _buildSearchResults({required bool byUsername}) {
    // Filter providers based on search query and/or category
    final filteredProviders = allProviders.where((provider) {
      final name = provider['name'] as String;
      final specialty = provider['specialty'] as String;
      final bio = provider['bio'] as String;

      bool matchesCategory =
          _selectedCategory == null || specialty == _selectedCategory;

      if (byUsername) {
        return name.toLowerCase().contains(_searchQuery.toLowerCase());
      } else {
        bool matchesSearch = _searchQuery.isEmpty ||
            name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            bio.toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesSearch && matchesCategory;
      }
    }).toList();

    if (filteredProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No service providers found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or browse all providers',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProviders.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final provider = filteredProviders[index];
        return _buildProviderCard(provider);
      },
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(userId: provider['id'] as String),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(provider['avatar'] as String),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider['specialty'] as String,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider['bio'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider['rating'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // List of all service providers (original 10 + 15 new ones = 25 total)
  final List<Map<String, dynamic>> allProviders = [
    // Original providers
    {
      'id': '1',
      'name': 'Sarah Johnson',
      'specialty': 'Transport',
      'bio':
          '5 years experience as a professional driver specializing in transport services. UTM graduate in logistics management.',
      'avatar':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=688&q=80',
      'rating': 4.7,
    },
    {
      'id': '2',
      'name': 'Michael Chen',
      'specialty': 'Moving',
      'bio':
          'Professional mover with full equipment. Specializing in home and office relocations. UTM alumnus with business management degree.',
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.9,
    },
    {
      'id': '3',
      'name': 'Jessica Lee',
      'specialty': 'Tutoring',
      'bio':
          'Math and Science tutor with teaching license. UTM graduate in education with 4 years of tutoring experience.',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.8,
    },
    {
      'id': '4',
      'name': 'David Kim',
      'specialty': 'Cooking',
      'bio':
          'Trained chef with 8 years of experience specializing in Asian cuisine. UTM culinary arts graduate.',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.6,
    },
    {
      'id': '5',
      'name': 'Emily Wilson',
      'specialty': 'Photography',
      'bio':
          'Professional photographer with published work. UTM fine arts graduate specializing in portrait and event photography.',
      'avatar':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.9,
    },
    {
      'id': '6',
      'name': 'Daniel Martinez',
      'specialty': 'Tour Guide',
      'bio':
          'Local tour guide with extensive knowledge of the city. UTM tourism management graduate offering city walking tours.',
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.7,
    },
    {
      'id': '7',
      'name': 'Sofia Garcia',
      'specialty': 'Tour Guide',
      'bio':
          'Food and cultural tour guide. UTM graduate in cultural studies with passion for local cuisine and history.',
      'avatar':
          'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
      'rating': 4.8,
    },
    {
      'id': '8',
      'name': 'Alex Thompson',
      'specialty': 'Photography',
      'bio':
          'Specializing in outdoor and adventure photography. UTM graduate with 5 years of professional experience.',
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'rating': 4.5,
    },
    {
      'id': '9',
      'name': 'Raj Patel',
      'specialty': 'Tutoring',
      'bio':
          'Engineering tutor with specialized knowledge in mathematics, physics, and programming. UTM engineering graduate.',
      'avatar':
          'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'rating': 4.9,
    },
    {
      'id': '10',
      'name': 'Lisa Wang',
      'specialty': 'Transport',
      'bio':
          'Professional driver offering reliable transport services. UTM business graduate with focus on customer service.',
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
      'rating': 4.7,
    },

    // Additional Transport providers (3 more)
    {
      'id': '11',
      'name': 'James Wilson',
      'specialty': 'Transport',
      'bio':
          '7 years as a professional driver. Specializes in airport transfers and long-distance travel. UTM transport management graduate.',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.8,
    },
    {
      'id': '12',
      'name': 'Aisha Rahman',
      'specialty': 'Transport',
      'bio':
          'Rideshare expert with exceptional service ratings. UTM business graduate specializing in transport logistics.',
      'avatar':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.9,
    },
    {
      'id': '13',
      'name': 'Carlos Mendoza',
      'specialty': 'Transport',
      'bio':
          'Specialized in student transport services. UTM graduate with focus on safety and reliability.',
      'avatar':
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.6,
    },

    // Additional Moving providers (3 more)
    {
      'id': '14',
      'name': 'Thomas Wright',
      'specialty': 'Moving',
      'bio':
          'Expert in delicate item moving and packing. UTM engineering graduate with 5 years experience in logistics.',
      'avatar':
          'https://images.unsplash.com/photo-1545996124-0501ebae84d0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=700&q=80',
      'rating': 4.7,
    },
    {
      'id': '15',
      'name': 'Hannah Schmidt',
      'specialty': 'Moving',
      'bio':
          'Organizing specialist for relocation services. UTM business graduate with expertise in efficient space management.',
      'avatar':
          'https://images.unsplash.com/photo-1592621385612-4d7129426394?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.5,
    },
    {
      'id': '16',
      'name': 'Omar Farooq',
      'specialty': 'Moving',
      'bio':
          'Specializing in office relocations and equipment moving. UTM logistics graduate with professional-grade moving equipment.',
      'avatar':
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
      'rating': 4.8,
    },

    // Additional Tutoring providers (3 more)
    {
      'id': '17',
      'name': 'Priya Sharma',
      'specialty': 'Tutoring',
      'bio':
          'Languages and humanities tutor. UTM literature graduate with expertise in English, Malay, and Tamil languages.',
      'avatar':
          'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80',
      'rating': 4.9,
    },
    {
      'id': '18',
      'name': 'Benjamin Lee',
      'specialty': 'Tutoring',
      'bio':
          'Computer science and programming tutor. UTM computer science graduate with industry experience.',
      'avatar':
          'https://images.unsplash.com/photo-1553267751-1c148a7280a1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=694&q=80',
      'rating': 4.7,
    },
    {
      'id': '19',
      'name': 'Olivia Chen',
      'specialty': 'Tutoring',
      'bio':
          'Business and economics tutor. UTM business administration graduate with focus on exam preparation techniques.',
      'avatar':
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=761&q=80',
      'rating': 4.8,
    },

    // Additional Cooking providers (3 more)
    {
      'id': '20',
      'name': 'Marco Romano',
      'specialty': 'Cooking',
      'bio':
          'Italian cuisine specialist. UTM culinary graduate with experience in renowned restaurants. Offers private dining and classes.',
      'avatar':
          'https://images.unsplash.com/photo-1583195764036-6dc248ac07d9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1476&q=80',
      'rating': 4.9,
    },
    {
      'id': '21',
      'name': 'Mei Lin',
      'specialty': 'Cooking',
      'bio':
          'Asian fusion cooking expert. UTM food science graduate specializing in healthy meal preparation and cooking workshops.',
      'avatar':
          'https://images.unsplash.com/photo-1583195764036-6dc248ac07d9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1476&q=80',
      'rating': 4.6,
    },
    {
      'id': '22',
      'name': 'Ahmed Hassan',
      'specialty': 'Cooking',
      'bio':
          'Middle Eastern cuisine specialist. UTM hospitality graduate providing catering services and cooking classes for groups.',
      'avatar':
          'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.8,
    },

    // Additional Photography providers (3 more)
    {
      'id': '23',
      'name': 'Rachel Thompson',
      'specialty': 'Photography',
      'bio':
          'Portrait and family photography specialist. UTM fine arts graduate with a keen eye for capturing authentic moments.',
      'avatar':
          'https://images.unsplash.com/photo-1548142813-c348350df52b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=689&q=80',
      'rating': 4.8,
    },
    {
      'id': '24',
      'name': 'Kai Nakamura',
      'specialty': 'Photography',
      'bio':
          'Commercial and product photography expert. UTM visual arts graduate specializing in marketing and e-commerce imagery.',
      'avatar':
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=699&q=80',
      'rating': 4.7,
    },
    {
      'id': '25',
      'name': 'Zoe Williams',
      'specialty': 'Photography',
      'bio':
          'Event and lifestyle photographer. UTM media studies graduate specializing in documenting campus activities and graduation ceremonies.',
      'avatar':
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1471&q=80',
      'rating': 4.6,
    },

    // Additional Tour Guide providers (3 more)
    {
      'id': '26',
      'name': 'Ibrahim Al-Farsi',
      'specialty': 'Tour Guide',
      'bio':
          'Historical and cultural tour specialist. UTM history graduate with extensive knowledge of local heritage sites and traditions.',
      'avatar':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
      'rating': 4.9,
    },
    {
      'id': '27',
      'name': 'Nadia Rodriguez',
      'specialty': 'Tour Guide',
      'bio':
          'Adventure tour leader. UTM sports science graduate specializing in hiking, cycling, and outdoor activities around campus and city.',
      'avatar':
          'https://images.unsplash.com/photo-1499887142886-791eca5918cd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
      'rating': 4.7,
    },
    {
      'id': '28',
      'name': 'Liam O\'Brien',
      'specialty': 'Tour Guide',
      'bio':
          'Night life and entertainment guide. UTM hospitality graduate with connections to the best student hangouts and local venues.',
      'avatar':
          'https://images.unsplash.com/photo-1496345875659-11f7dd282d1d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
      'rating': 4.8,
    },
  ];
}
