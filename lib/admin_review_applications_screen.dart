import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReviewApplicationsScreen extends StatelessWidget {
  const AdminReviewApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Review Applications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream to listen for changes in the "vendor_applications" collection with "Pending" status
        stream: FirebaseFirestore.instance
            .collection('vendor_applications')
            .where('status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // No pending applications
            return const Center(
              child: Text('No pending vendor applications.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final application = snapshot.data!.docs[index];
              final applicationId = application.id;
              final businessName = application['businessName'] as String;
              final menuOfferings = application['menuOfferings'] as String;
              final certifications = application['certifications'] as String;
              final applicantEmail = application['applicantEmail'] as String; // Assuming you store the applicant's email

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Business Name: $businessName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Menu Offerings: $menuOfferings'),
                      Text('Certifications: $certifications'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          // Approve the application and change the status to 'Approved'
                          _updateApplicationStatus(applicationId, 'Approved', applicantEmail);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          // Reject the application and change the status to 'Rejected'
                          _updateApplicationStatus(applicationId, 'Rejected', applicantEmail);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateApplicationStatus(String applicationId, String status, String applicantEmail) async {
    try {
      // Update the status of the vendor application in Firestore
      await FirebaseFirestore.instance
          .collection('vendor_applications')
          .doc(applicationId)
          .update({'status': status});

      // Trigger a Cloud Function to send the email notification to the user
      await _triggerEmailNotification(applicationId, status, applicantEmail);

      // Optionally, you can show a confirmation message to the administrator.
    } catch (e) {
      // Handle any errors that occur during status update.
      print('Error updating application status: $e');
      // Optionally, display an error message to the administrator.
    }
  }

  Future<void> _triggerEmailNotification(String applicationId, String status, String applicantEmail) async {
    try {
      // Trigger the Cloud Function here to send email notifications.
      // Pass necessary information like the applicationId, status, and applicantEmail to the Cloud Function.
      // You can call an HTTP endpoint in your Cloud Function that sends emails using a third-party email service.

      // Optionally, you can show a confirmation message to the administrator.
    } catch (e) {
      // Handle any errors that occur during email notification triggering.
      print('Error triggering email notification: $e');
      // Optionally, display an error message to the administrator.
    }
  }
}
