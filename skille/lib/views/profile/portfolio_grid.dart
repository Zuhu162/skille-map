import 'package:flutter/material.dart';
import '../../models/user.dart';

class PortfolioGrid extends StatelessWidget {
  final User user;
  final bool canEdit;
  final VoidCallback onAddPressed;

  const PortfolioGrid({
    super.key,
    required this.user,
    this.canEdit = false,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    // For now, we'll use dummy data
    // In a real app, this would come from user.posts or similar
    final dummyPosts = List.generate(
      8,
      (index) => {
        'id': 'post_$index',
        'imageUrl': 'https://picsum.photos/500/500?random=$index',
        'caption': 'Sample post $index',
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (canEdit)
                IconButton(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add_box, color: Colors.green),
                  tooltip: 'Add new post',
                ),
            ],
          ),
        ),
        dummyPosts.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        canEdit
                            ? 'Your portfolio is empty. Add your first post!'
                            : '${user.name}\'s portfolio is empty.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (canEdit) ...[
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: onAddPressed,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Post'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: dummyPosts.length,
                itemBuilder: (context, index) {
                  final post = dummyPosts[index];
                  return GestureDetector(
                    onTap: () {
                      // TODO: Open post detail view
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on post ${post['id']}')),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        post['imageUrl'] as String,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
