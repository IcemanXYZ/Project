import 'package:flutter/material.dart';
import 'event.dart'; // Import the Event class
import 'package:intl/intl.dart'; // Import the intl package

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.eventName),
            const SizedBox(height: 16.0),
            const Text(
              'Start Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('yyyy-MM-dd HH:mm').format(event.startDate)),
            const SizedBox(height: 16.0),
            const Text(
              'End Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('yyyy-MM-dd HH:mm').format(event.endDate)),
            const SizedBox(height: 16.0),
            const Text(
              'Event Organizer Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.eventOrganiserName),
            const SizedBox(height: 16.0),
            const Text(
              'Event Organizer Email:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.eventOrganiserEmail),
            const SizedBox(height: 16.0),
            const Text(
              'Location:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.selectedLocation),
            const SizedBox(height: 16.0),
            const Text(
              'Event Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.selectedEventType),
            const SizedBox(height: 16.0),
            const Text(
              'Number of Attendees:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.numberOfAttendees.toString()),
            const SizedBox(height: 16.0),
            const Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(event.status),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the Event List screen
                Navigator.pop(context);
              },
              child: const Text('Back to Event List'),
            ),
          ],
        ),
      ),
    );
  }
}
