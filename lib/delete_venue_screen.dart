import 'venue_service.dart'; // Import the VenueService class
import 'package:flutter/material.dart';
import 'venue.dart'; // Import the Venue class from venue.dart

class DeleteVenueScreen extends StatefulWidget {
  final Venue venue; // Pass the venue to be deleted to this screen

  const DeleteVenueScreen({super.key, required this.venue});

  @override
  DeleteVenueScreenState createState() => DeleteVenueScreenState();
}

class DeleteVenueScreenState extends State<DeleteVenueScreen> {
  @override // This line is added to fix the warning

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Venue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Are you sure you want to delete this venue?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Venue Name: ${widget.venue.name}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Venue Location: ${widget.venue.location}',
              style: const TextStyle(fontSize: 16),
            ),
            // Display other venue information...

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () {
                showDeleteConfirmationDialog(context);
              },
              child: const Text('Delete Venue'),
            ),
          ],
        ),
      ),
    );
  }

// Show a confirmation dialog before deleting the venue
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this venue?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
// Check if the venue is attached to any active events or reservations
                if (!await VenueService().isVenueInUse(widget.venue.venueID)) {
// If not in use, proceed with the deletion
                  await VenueService().deleteVenue(widget.venue.venueID);
                  if (mounted) {
                    Navigator.pop(context); // Close the confirmation dialog
                    Navigator.pop(context); // Navigate back to the previous screen
                  }
                } else {
// Venue is in use, show a warning message
                  if (mounted) {
                    Navigator.of(context).pop(); // Close the confirmation dialog
                    showWarningDialog(context);
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

// Show a warning dialog if the venue is in use
  void showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('This venue is attached to an active event or reservation. It cannot be deleted at this time.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the warning dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}