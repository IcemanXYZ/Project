import 'package:cloud_firestore/cloud_firestore.dart';
import 'upgrade_request.dart'; // Ensure this import points to where your UpgradeRequest class is defined

class UpgradeRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUpgradeRequest(UpgradeRequest upgradeRequest) async {
    try {
      DocumentReference ref = await _firestore.collection('roleUpgradeRequest').add(upgradeRequest.toMap());
      print("Upgrade Request Created with ID: ${ref.id}");
    } catch (e) {
      throw Exception('Error creating upgrade request: $e');
    }
  }

  Future<void> updateUpgradeRequest(String requestId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection('roleUpgradeRequest').doc(requestId).update(updateData);
      print("Upgrade Request Updated: $requestId");
    } catch (e) {
      throw Exception('Error updating upgrade request: $e');
    }
  }

  // Method to fetch upgrade requests, possibly for admin review
  Stream<List<UpgradeRequest>> fetchUpgradeRequests() {
    return _firestore.collection('roleUpgradeRequest').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UpgradeRequest.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Method to update the status and review notes of an upgrade request
  Future<void> updateStatusAndReviewNotes(String requestId, String status, String reviewNotes) async {
    try {
      await _firestore.collection('roleUpgradeRequest').doc(requestId).update({
        'status': status,
        'reviewNotes': reviewNotes,
      });
      print("Status and Review Notes Updated for Request: $requestId");
    } catch (e) {
      throw Exception('Error updating status and review notes: $e');
    }
  }

  // Method to fetch upgrade requests for System Administrator
  Stream<List<UpgradeRequest>> fetchUpgradeRequestsForSysAdmin() {
    return _firestore
        .collection('roleUpgradeRequest')
        .where('desiredRole', isEqualTo: "Faculty Administrator")
        .where('status', isEqualTo: "Pending")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UpgradeRequest.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Method to fetch upgrade requests for Faculty Administrator
  Stream<List<UpgradeRequest>> fetchUpgradeRequestsForFacultyAdmin() {
    return _firestore
        .collection('roleUpgradeRequest')
        .where('desiredRole', isNotEqualTo: "Faculty Administrator")
        .where('status', isEqualTo: "Pending")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UpgradeRequest.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Method to approve or reject an upgrade request and optionally update user role
  Future<void> reviewUpgradeRequest(
      String requestId,
      String status, {
        String? newRole,
        String? userId,
        String? reviewNotes,
      }) async {
    // Basic validation (consider enforcing this in your UI or before calling this method for immediate user feedback)
    if ((status == "Rejected" || status == "RequireMoreInfo") && (reviewNotes == null || reviewNotes.isEmpty)) {
      throw Exception('Review notes are required for Rejected or RequireMoreInfo statuses.');
    }

    WriteBatch batch = _firestore.batch();

    // Update the upgrade request with status and optionally review notes
    DocumentReference requestRef = _firestore.collection('roleUpgradeRequest').doc(requestId);
    var updateData = {
      'status': status,
    };
    if (reviewNotes != null) updateData['reviewNotes'] = reviewNotes;

    batch.update(requestRef, updateData);

    // If approved and a new role is provided, also update the user's role
    if (status == "Approved" && newRole != null && userId != null) {
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Fetch the current role of the user
      var userDocument = await _firestore.collection('users').doc(userId).get();
      var currentRole = userDocument.data()?['Role'];

      // Update the user's document with the new role and add the old role to previousRole
      batch.update(userRef, {
        'Role': newRole, // Use 'Role' with a capital 'R' if that is what your user document field is called
        'previousRole': FieldValue.arrayUnion([currentRole]), // Adds the current role to the previousRole array
      });
    }

    // Commit the batch update
    await batch.commit();
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    try {
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDocument.data();
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<bool> hasActiveUpgradeRequest(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('roleUpgradeRequest')
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['Pending', 'RequireMoreInfo']) // Consider other statuses as active if needed
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking for active upgrade request: $e');
    }
  }

  // Method to get the count of pending upgrade requests
  Stream<int> getPendingUpgradeRequestsCount() {
    return _firestore
        .collection('roleUpgradeRequest')
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Method to update the user's current role
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({'Role': newRole});
    } catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }

  // Method to update the user's desired role
  Future<void> updateDesiredRole(String userId, String desiredRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({'desiredRole': desiredRole});
    } catch (e) {
      throw Exception('Error updating desired role: $e');
    }
  }

  // Method to fetch user details including first name and last name
  Future<Map<String, dynamic>?> fetchUserDetailsWithNames(String userId) async {
    try {
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDocument.data();
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

}
