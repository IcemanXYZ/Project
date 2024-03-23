import 'package:flutter/material.dart';
import 'upgrade_request.dart';
import 'upgrade_request_service.dart';

class UpgradeRequestUpdate extends StatefulWidget {
  final String userId;
  final UpgradeRequest request;

  const UpgradeRequestUpdate({super.key, required this.userId, required this.request});

  @override
  _UpgradeRequestUpdateState createState() => _UpgradeRequestUpdateState();
}

class _UpgradeRequestUpdateState extends State<UpgradeRequestUpdate> {
  final UpgradeRequestService _service = UpgradeRequestService();
  final _formKey = GlobalKey<FormState>();
  late String _status;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set _status to 'Approved' if the initial status is 'Pending'
    _status = widget.request.status == 'Pending' ? 'Approved' : widget.request.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Upgrade Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: _service.fetchUserDetails(widget.request.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error fetching user details: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    final String fullName = '${user['First Name'] ?? ''} ${user['Last Name'] ?? ''}';
                    final String email = user['Email'] ?? '';
                    final String phoneNumber = user['Phone Number'] ?? '';
                    final String currentRole = widget.request.currentRole;
                    final String desiredRole = widget.request.desiredRole;
                    // You would retrieve the URL of the profile image from your user model
                    // For this example, let's assume the profile image URL is stored under 'ProfilePicture' key
                    final String profilePictureUrl = user['ProfilePicture'] ?? 'default_profile_pic_url';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the profile picture
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePictureUrl),
                          radius: 50, // Adjust the size to fit your design
                        ),
                        const SizedBox(height: 8),
                        // Display the full name
                        Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        // Display the email
                        Text(email, style: const TextStyle(fontSize: 16)),
                        // Display the phone number
                        Text(phoneNumber, style: const TextStyle(fontSize: 16)),
                        // Display the user role
                        Text('Role: $currentRole', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    // In case there is no user data available
                    return const Text('No user data available.');
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _status = newValue;
                    });
                  }
                },
                items: <String>['Approved', 'Rejected', 'RequireMoreInfo'] // 'Pending' removed from here
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if ((_status == 'Rejected' || _status == 'RequireMoreInfo') && (value == null || value.isEmpty)) {
                    return 'Notes are required for this status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _service.reviewUpgradeRequest(
                          widget.request.id,
                          _status,
                          newRole: _status == 'Approved' ? widget.request.desiredRole : widget.request.currentRole,
                          userId: widget.request.userId,
                          reviewNotes: _notesController.text,
                        ).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted successfully')));
                          Navigator.of(context).pop(); // Go back after submitting
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting review: $error')));
                        });
                      }
                    },
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
