import 'package:cloud_firestore/cloud_firestore.dart';
import 'sponsor.dart'; // Make sure this path is correct
import 'dart:developer' as developer; // Import for logging

class SponsorService {
  final CollectionReference _sponsorsCollection = FirebaseFirestore.instance.collection('sponsors');
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('events');

  // Add a Sponsor/Partner
  Future<void> addSponsor(Sponsor sponsor) async {
    try {
      await _sponsorsCollection.doc(sponsor.id).set(sponsor.toMap());
    } catch (e) {
      developer.log("Error adding sponsor: $e", name: 'SponsorService.addSponsor');
      rethrow; // Re-throw the error
    }
  }

  // Edit a Sponsor/Partner
  Future<void> editSponsor(String sponsorId, Map<String, dynamic> updatedData) async {
    try {
      await _sponsorsCollection.doc(sponsorId).update(updatedData);
    } catch (e) {
      developer.log("Error updating sponsor: $e", name: 'SponsorService.editSponsor');
      rethrow; // Re-throw the error
    }
  }

  // Delete a Sponsor/Partner
  Future<bool> deleteSponsor(String sponsorId) async {
    try {
      final querySnapshot = await _eventsCollection
          .where('sponsorId', isEqualTo: sponsorId)
          .where('status', isNotEqualTo: 'cancelled')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _sponsorsCollection.doc(sponsorId).delete();
        return true; // Successfully deleted
      } else {
        return false; // Deletion not allowed
      }
    } catch (e) {
      developer.log("Error deleting sponsor: $e", name: 'SponsorService.deleteSponsor');
      return false; // Error occurred
    }
  }

  // Retrieve Sponsors/Partners
  Stream<List<Sponsor>> retrieveSponsors() {
    return _sponsorsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Sponsor.fromMap(data, doc.id); // Corrected to include document ID
      }).toList();
    });
  }
}
