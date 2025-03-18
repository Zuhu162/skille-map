class Service {
  final String id;
  final String provider;
  final String type;
  final String title;
  final String description;
  final double rate;
  final String? availability;
  final List<String> media;
  final Map<String, dynamic>? details;
  final List<Rating> ratings;
  final String createdAt;

  Service({
    required this.id,
    required this.provider,
    required this.type,
    required this.title,
    required this.description,
    required this.rate,
    this.availability,
    required this.media,
    this.details,
    required this.ratings,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      provider: json['provider']['_id'] ?? json['provider'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      rate: json['rate'].toDouble(),
      availability: json['availability'],
      media: json['media'] != null ? List<String>.from(json['media']) : [],
      details: json['details'],
      ratings: json['ratings'] != null
          ? List<Rating>.from(json['ratings'].map((x) => Rating.fromJson(x)))
          : [],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'provider': provider,
      'type': type,
      'title': title,
      'description': description,
      'rate': rate,
      'availability': availability,
      'media': media,
      'details': details,
      'ratings': ratings.map((x) => x.toJson()).toList(),
      'createdAt': createdAt,
    };
  }

  double get averageRating {
    if (ratings.isEmpty) return 0;
    return ratings.map((r) => r.rating).reduce((a, b) => a + b) /
        ratings.length;
  }
}

class Rating {
  final String user;
  final double rating;
  final String? review;

  Rating({
    required this.user,
    required this.rating,
    this.review,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      user: json['user']['_id'] ?? json['user'],
      rating: json['rating'].toDouble(),
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'rating': rating,
      'review': review,
    };
  }
}
