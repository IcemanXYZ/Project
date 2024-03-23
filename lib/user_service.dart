import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String department,
    required String eventPreferences,
    required DateTime birthdate,
    required String gender,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'department': department,
        'eventPreferences': eventPreferences,
        'profilePictureURL': '', // Initialize with an empty URL or add logic to upload profile picture
        'createdAt': FieldValue.serverTimestamp(),
        'hasCompletedOnboarding': false,
        'birthdate': birthdate.toIso8601String(),
        'gender': gender,
      });
    } catch (e) {
      print('Error creating user: $e');
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  Future<void> updateUser({
    required String uid,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String department,
    required String eventPreferences,
    required DateTime birthdate,
    required String gender,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'department': department,
        'eventPreferences': eventPreferences,
        'birthdate': birthdate.toIso8601String(),
        'gender': gender,
      });
    } catch (e) {
      print('Error updating user: $e');
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _auth.currentUser?.delete();
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  Future<void> submitRoleUpgradeRequest({
    required String uid,
    required String desiredRole,
    required Map<String, dynamic> additionalInfo, // Additional information specific to the role upgrade request
  }) async {
    try {
      await _firestore.collection('roleUpgradeRequests').add({
        'userId': uid,
        'desiredRole': desiredRole,
        'status': 'Pending',
        'additionalInfo': additionalInfo,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error submitting role upgrade request: $e');
      rethrow;
    }
  }

  Future<void> updateUserRole({
    required String uid,
    required String newRole,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': newRole,
      });
    } catch (e) {
      print('Error updating user role: $e');
      rethrow;
    }
  }

  // Add a method to fetch the current user's role
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
        return (userDoc.data() as Map<String, dynamic>)['role'] ?? 'guest'; // Default to 'guest' if not specified
      }
      return 'guest'; // Default role if user document does not exist
    } catch (e) {
      print('Error fetching user role: $e');
      throw Exception('Failed to fetch user role');
    }
  }

}
