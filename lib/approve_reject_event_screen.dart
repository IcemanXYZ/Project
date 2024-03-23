import 'package:flutter/material.dart';
import 'event_service.dart'; // Import the EventService class
import 'record_successful_update_Screen.dart'; // Import the RecordSuccessfulUpdateScreen class
import 'package:flutter_svg/flutter_svg.dart';

class ApproveRejectEventScreen extends StatelessWidget {
  final String eventId;
  final String eventStatus;
  final EventService eventService = EventService();

  ApproveRejectEventScreen({super.key, 
    required this.eventId,
    required this.eventStatus,
  });

  Future<void> _approveEvent(BuildContext context) async {
    await eventService.approveEvent(eventId);
    _navigateToRecordSuccessfulUpdateScreen(context, 'Event Approved Successfully');
  }

  Future<void> _rejectEvent(BuildContext context) async {
    await eventService.rejectEvent(eventId);
    _navigateToRecordSuccessfulUpdateScreen(context, 'Event Rejected Successfully');
  }

  Future<void> _navigateToRecordSuccessfulUpdateScreen(BuildContext context, String message) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecordSuccessfulUpdateScreen(message: message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve or Reject Event'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/check_circle.svg', // Ensure you have this asset in your project
              width: 100, // Adjust the size as needed
              height: 100, // Adjust the size as needed
            ),
            const SizedBox(height: 24),
            const Text(
              'Approve or Reject Event',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Event ID: $eventId',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Event Status: $eventStatus',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _approveEvent(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Use green for the "Approve" button
                    minimumSize: const Size(160, 50),
                  ),
                  child: const Text('Approve Event'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/eventListScreen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Use blue for the "Back to Event List" button
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text('Back to Event List'),
                ),
                ElevatedButton(
                  onPressed: () => _rejectEvent(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Use red for the "Reject" button
                    minimumSize: const Size(160, 50),
                  ),
                  child: const Text('Reject Event'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
