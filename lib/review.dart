class Review {
  String userID;
  String reviewText;
  DateTime date;
  double rating;

  Review({
    required this.userID,
    required this.reviewText,
    required this.date,
    required this.rating,
  });

  // Convert a Review object into a map
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'reviewText': reviewText,
      'date': date.toIso8601String(), // Firestore handles DateTime objects as strings
      'rating': rating,
    };
  }

  // Create a Review object from a map (useful when retrieving data from Firestore)
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userID: map['userID'],
      reviewText: map['reviewText'],
      date: DateTime.parse(map['date']),
      rating: map['rating'],
    );
  }
}
