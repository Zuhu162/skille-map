import 'package:flutter/material.dart';
import '../../models/service.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = service.media.isNotEmpty;
    final imageUrl = hasMedia ? service.media.first : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(service.title),
              background: hasMedia
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 64, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.green.shade100,
                      child: Center(
                        child: Text(
                          service.title.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ),
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          '\$${service.rate.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        backgroundColor: Colors.green.shade100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Service Provider",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${service.averageRating.toStringAsFixed(1)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' (${service.ratings.length} reviews)',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement view profile action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('View profile action')),
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Profile'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                  if (service.availability != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Availability',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.availability!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'What to expect',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildExpectationItem(
                    Icons.check_circle_outline,
                    'Professional ${service.title} service',
                  ),
                  _buildExpectationItem(
                    Icons.check_circle_outline,
                    'Experienced service provider',
                  ),
                  _buildExpectationItem(
                    Icons.check_circle_outline,
                    'Satisfaction guaranteed',
                  ),
                  _buildExpectationItem(
                    Icons.access_time,
                    'Typically responds within 24 hours',
                  ),
                  if (service.ratings.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...service.ratings
                        .take(3)
                        .map((rating) => _buildReviewItem(rating)),
                    if (service.ratings.length > 3) ...[
                      TextButton(
                        onPressed: () {
                          // TODO: Show all reviews
                        },
                        child: Text(
                          'See all ${service.ratings.length} reviews',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement booking action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Book service action')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement contact action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Contact provider action')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Contact Provider'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpectationItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Rating rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'User',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < rating.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (rating.review != null && rating.review!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(rating.review!),
          ],
          const Divider(),
        ],
      ),
    );
  }
}
