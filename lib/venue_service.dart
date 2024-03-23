    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'venue.dart'; // Import your Venue model

    class VenueService {
      final CollectionReference _venueCollection = FirebaseFirestore.instance.collection('venues');

      // Create a new venue
      Future<void> addVenue(Venue venue) async {
        try {
          if (_validateVenue(venue)) {
            await _venueCollection.doc(venue.venueID).set(venue.toMap());
          } else {
            throw Exception('Invalid venue data');
          }
        } catch (e) {
          // Handle exceptions (e.g., network issues, Firebase rules)
          rethrow; // Consider how to handle errors in your UI
        }
      }

      // Read (fetch) a single venue by ID
      Future<Venue?> getVenue(String venueID) async {
        try {
          var snapshot = await _venueCollection.doc(venueID).get();
          if (snapshot.exists) {
            return Venue.fromMap(snapshot.data() as Map<String, dynamic>);
          }
          return null;
        } catch (e) {
          // Handle exceptions
          rethrow; // Consider how to handle errors in your UI
        }
      }

      // Update an existing venue
      Future<void> updateVenue(Venue venue) async {
        try {
          if (_validateVenue(venue)) {
            await _venueCollection.doc(venue.venueID).update(venue.toMap());
          } else {
            throw Exception('Invalid venue data');
          }
        } catch (e) {
          // Handle exceptions
          rethrow; // Consider how to handle errors in your UI
        }
      }
    // Check if the venue is in use (e.g., has events or bookings)
      Future<bool> isVenueInUse(String venueID) async {
        try {
    // Replace 'events' with the actual name of the collection that references venues.
          var eventsCollection = FirebaseFirestore.instance.collection('events');
          var querySnapshot = await eventsCollection.where('venueID', isEqualTo: venueID).limit(1).get();
    // If there's at least one document, the venue is in use
          return querySnapshot.docs.isNotEmpty;
        } catch (e) {
    // Handle exceptions
          rethrow; // Consider how to handle errors in your UI
        }
      }
      // Delete a venue
      Future<void> deleteVenue(String venueID) async {
        try {
          await _venueCollection.doc(venueID).delete();
        } catch (e) {
          // Handle exceptions
          rethrow; // Consider how to handle errors in your UI
        }
      }

      // Fetch all venues as a stream for real-time updates
      Stream<List<Venue>> getVenuesStream() {
        return _venueCollection.snapshots().map((snapshot) =>
            snapshot.docs.map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>)).toList());
      }

      // Validate venue data
      bool _validateVenue(Venue venue) {
        // Implement validation logic (e.g., check for null or empty fields)
        // Example: return venue.name.isNotEmpty && venue.location.isNotEmpty;
        // Add more validation as per your data structure and requirements
        return true; // Placeholder validation
      }

      Future<void> addRatingToVenue(String venueID, double newRating) async {
        // Get a reference to the Firestore document
        DocumentReference venueDoc = FirebaseFirestore.instance.collection('venues').doc(venueID);

        // Get the current venue data
        DocumentSnapshot docSnapshot = await venueDoc.get();
        Venue venue = Venue.fromSnapshot(docSnapshot);

        // Add the new rating
        venue.addRating(newRating);

        // Update the venue document with the new average rating
        await venueDoc.update({'rating': venue.rating, 'allRatings': venue.allRatings}).catchError((error) {
          print('Error updating venue rating: $error');
          // Handle any errors here
        });
      }

      Future<List<Venue>> getVenues() async {
        try {
          // Attempt to fetch the list of venues from Firestore.
          QuerySnapshot querySnapshot = await _venueCollection.get();

          // Map the documents to Venue objects.
          List<Venue> venues = querySnapshot.docs
              .map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return venues;
        } catch (e) {
          // If an exception occurs, log the error and return an empty list.
          print('Error getting venues: $e');
          return []; // Return an empty list to satisfy the non-null return type.
        }
      }

      Future<Venue?> getVenueByName(String venueName) async {
        try {
          // Query Firestore to find the venue with the specified name
          var querySnapshot = await _venueCollection.where('name', isEqualTo: venueName).get();

          if (querySnapshot.docs.isNotEmpty) {
            // Get the first document matching the name (assuming venue names are unique)
            var doc = querySnapshot.docs.first;
            return Venue.fromMap(doc.data() as Map<String, dynamic>);
          }

          // Venue not found with the given name
          return null;
        } catch (e) {
          // Handle exceptions
          rethrow; // Consider how to handle errors in your UI
        }
      }

    }
