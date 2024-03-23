import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RoleReversalScreen extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  const RoleReversalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (previous code)

    void _reverseUserRole(String vendorId) async {
      try {
        // Retrieve the user's previous role from Firestore
        final userDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(vendorId)
            .get();

        final previousRole = userDocument['previousRole'] as String;

        // Update the user's role in Firestore to their previous role
        await FirebaseFirestore.instance
            .collection('users')
            .doc(vendorId)
            .update({'role': previousRole});

        // Notify the vendor about the role reversal through push notification
        await _sendRoleReversalNotification(vendorId, previousRole);

        // Optionally, you can show a confirmation message to the administrator.
      } catch (e) {
        // Handle any errors that occur during role reversal.
        print('Error reversing user role: $e');
        // Optionally, display an error message to the administrator.
      }
    }

    Future<void> _sendRoleReversalNotification(String userId, String newRole) async {
      try {
        // Get the user's FCM token from Firestore
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        final fcmToken = userSnapshot['fcmToken'] as String;

        // Send a push notification to the user
        await _firebaseMessaging.sendToTopic(fcmToken, {
          'notification': {
            'title': 'Role Reversal',
            'body': 'Your role has been reversed to $newRole.',
          },
          'data': {
            'type': 'role_reversal',
            'role': newRole,
          },
        });
      } catch (e) {
        print('Error sending push notification: 