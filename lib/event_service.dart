import 'event.dart'; // Import the Event class
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch all events
  Future<List<Event>> getAllEvents() async {
    try {
      var eventsQuerySnapshot = await _firestore.collection('events').get();
      List<Event> events = eventsQuerySnapshot.docs.map((doc) {
        return Event.fromFirestore(doc);
      }).toList();
      return events;
    } catch (e) {
      rethrow;
    }
  }

  // Method to create a new event
  Future<void> createEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).set(event.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Method to update an existing event
  Future<void> updateEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Method to delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Method to register an attendee for an event
  Future<void> registerAttendee(String eventId, String attendeeId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'attendeeList': FieldValue.arrayUnion([attendeeId])
      });
    } catch (e) {
      rethrow;
    }
  }

  // Method to deregister an attendee from an event
  Future<void> deregisterAttendee(String eventId, String attendeeId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'attendeeList': FieldValue.arrayRemove([attendeeId])
      });
    } catch (e) {
      rethrow;
    }
  }

  // Method to approve an event
  Future<void> approveEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'status': 'Approved'
      });
    } catch (e) {
      rethrow;
    }
  }

  // Method to reject an event
  Future<void> rejectEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'status': 'Rejected'
      });
    } catch (e) {
      rethrow;
    }
  }

// Add more methods as required for your application's functionality
}
