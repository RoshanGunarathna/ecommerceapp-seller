class Rating {
  final String userId;
  final double rating;
  Rating({
    required this.userId,
    required this.rating,
  });

  static Map<String, dynamic> toMap(Rating ratingModel) {
    return <String, dynamic>{
      'userId': ratingModel.userId,
      'rating': ratingModel.rating,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] as String,
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }
}
