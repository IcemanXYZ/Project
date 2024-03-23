import 'venue_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Venue {
  String venueID;
  String name;
  String location;
  int capacity;
  int maxOccupancy;
  double cost;
  bool availability;
  String venueType;
  List<String> facilities;
  String bookingRestrictions;
  List<String> eventTypesSuitedFor;
  String size;
  List<String> layoutOptions;
  String contactInfo;
  double rating;
  List<String> additionalServices;
  List<String> transportLinks;
  List<String> nearbyAccommodations;
  String virtualTourLink;
  String environmentalInfo;
  String insuranceRequirements;
  String cancellationPolicy;
  List<String> photoGallery;
  List<Review> reviews;
  List<double> allRatings;
  VenueCalendar venueCalendar; // VenueCalendar instance for managing availability

  Venue({
    required this.venueID,
    required this.name,
    required this.location,
    required this.capacity,
    required this.maxOccupancy,
    required this.cost,
    required this.availability,
    required this.venueType,
    required this.facilities,
    required this.bookingRestrictions,
    required this.eventTypesSuitedFor,
    required this.size,
    required this.layoutOptions,
    required this.contactInfo,
    required this.rating,
    required this.additionalServices,
    required this.transportLinks,
    required this.nearbyAccommodations,
    required this.virtualTourLink,
    required this.environmentalInfo,
    required this.insuranceRequirements,
    required this.cancellationPolicy,
    this.photoGallery = const [],
    this.reviews = const [],
    this.allRatings = const [],
  }) : venueCalendar = VenueCalendar(venueID);

  Map<String, dynamic> toMap() {
    return {
      'venueID': venueID,
      'name': name,
      'location': location,
      'capacity': capacity,
      'maxOccupancy': maxOccupancy,
      'cost': cost,
      'availability': availability,
      'venueType': venueType,
      'facilities': facilities,
      'bookingRestrictions': bookingRestrictions,
      'eventTypesSuitedFor': eventTypesSuitedFor,
      'size': size,
      'layoutOptions': layoutOptions,
      'contactInfo': contactInfo,
      'rating': rating,
      'additionalServices': additionalServices,
      'transportLinks': transportLinks,
      'nearbyAccommodations': nearbyAccommodations,
      'virtualTourLink': virtualTourLink,
      'environmentalInfo': environmentalInfo,
      'insuranceRequirements': insuranceRequirements,
      'cancellationPolicy': cancellationPolicy,
      'photoGallery': photoGallery,
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'allRatings': allRatings,
    };
  }

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      venueID: map['venueID'],
      name: map['name'],
      location: map['location'],
      capacity: map['capacity'],
      maxOccupancy: map['maxOccupancy'],
      cost: map['cost'],
      availability: map['availability'],
      venueType: map['venueType'],
      facilities: List<String>.from(map['facilities']),
      bookingRestrictions: map['bookingRestrictions'],
      eventTypesSuitedFor: List<String>.from(map['eventTypesSuitedFor']),
      size: map['size'],
      layoutOptions: List<String>.from(map['layoutOptions']),
      contactInfo: map['contactInfo'],
      rating: map['rating'],
      additionalServices: List<String>.from(map['additionalServices']),
      transportLinks: List<String>.from(map['transportLinks']),
      nearbyAccommodations: List<String>.from(map['nearbyAccommodations']),
      virtualTourLink: map['virtualTourLink'],
      environmentalInfo: map['environmentalInfo'],
      insuranceRequirements: map['insuranceRequirements'],
      cancellationPolicy: map['cancellationPolicy'],
      photoGallery: List<String>.from(map['photoGallery'] ?? []),
      reviews: (map['reviews'] as List).map((reviewMap) => Review.fromMap(reviewMap)).toList(),
      allRatings: List<double>.from(map['allRatings'] ?? []),
    );
  }

  // Method to add a new rating and update the average
  void addRating(double newRating) {
    allRatings.add(newRating);
    rating = _calculateAverageRating();
  }

  // Method to calculate the average rating
  double _calculateAverageRating() {
    if (allRatings.isEmpty) {
      return 0.0;
    }
    return allRatings.reduce((a, b) => a + b) / allRatings.length;
  }

  // Factory constructor for creating a new Venue instance from a Firestore snapshot.
  factory Venue.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Venue(
      venueID: doc.id,
      name: data?['name'] ?? '',
      location: data?['location'] ?? '',
      capacity: data?['capacity'] ?? 0,
      maxOccupancy: data?['maxOccupancy'] ?? 0,
      cost: (data?['cost'] as num?)?.toDouble() ?? 0.0,
      availability: data?['availability'] ?? false,
      venueType: data?['venueType'] ?? '',
      facilities: List<String>.from(data?['facilities'] ?? []),
      bookingRestrictions: data?['bookingRestrictions'] ?? '',
      eventTypesSuitedFor: List<String>.from(data?['eventTypesSuitedFor'] ?? []),
      size: data?['size'] ?? '',
      layoutOptions: List<String>.from(data?['layoutOptions'] ?? []),
      contactInfo: data?['contactInfo'] ?? '',
      rating: (data?['rating'] as num?)?.toDouble() ?? 0.0,
      additionalServices: List<String>.from(data?['additionalServices'] ?? []),
      transportLinks: List<String>.from(data?['transportLinks'] ?? []),
      nearbyAccommodations: List<String>.from(data?['nearbyAccommodations'] ?? []),
      virtualTourLink: data?['virtualTourLink'] ?? '',
      environmentalInfo: data?['environmentalInfo'] ?? '',
      insuranceRequirements: data?['insuranceRequirements'] ?? '',
      cancellationPolicy: data?['cancellationPolicy'] ?? '',
      photoGallery: List<String>.from(data?['photoGallery'] ?? []),
      reviews: (data?['reviews'] as List<dynamic>?)
          ?.map((reviewMap) => Review.fromMap(reviewMap as Map<String, dynamic>))
          .toList() ?? [],
      allRatings: (data?['allRatings'] as List<dynamic>?)
          ?.map((rating) => rating as double)
          .toList() ?? [],
    );
  }

  // Add available time slot to the calendar
  void addAvailableTimeSlot(DateTime date, TimeSlot timeSlot) {
    venueCalendar.addAvailableTimeSlot(date, timeSlot);
  }

  // Check if the venue is available for a specific date and time
  bool checkAvailability(DateTime date, TimeSlot timeSlot) {
    return venueCalendar.isTimeSlotAvailable(date, timeSlot);
  }

  // Book the venue for a specific date and time
  void bookVenue(DateTime date, TimeSlot timeSlot) {
    if (checkAvailability(date, timeSlot)) {
      venueCalendar.bookTimeSlot(date, timeSlot);
    } else {
      throw Exception('Venue is not available at the specified time.');
    }
  }

  // Clear venue availability for a specific date
  void clearAvailability(DateTime date) {
    venueCalendar.clearTimeSlots(date);
  }
}

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

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'reviewText': reviewText,
      'date': date.toIso8601String(),
      'rating': rating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userID: map['userID'],
      reviewText: map['reviewText'],
      date: DateTime.parse(map['date']),
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }
}