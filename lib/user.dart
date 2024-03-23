import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String profilePicUrl;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.profilePicUrl,
  });
}

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to reset user password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      rethrow;
    }
  }

  // Function to disable user account
  Future<void> disableAccount(String uid) async {
    try {
      await _auth.updateUser(uid: uid, disabled: true);
    } catch (error) {
      rethrow;
    }
  }

  // Function to delete user account
  Future<void> deleteAccount(String uid) async {
    try {
      await _auth.deleteUser(uid: uid);
    } catch (error) {
      rethrow;
    }
  }
}
