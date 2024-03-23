import 'package:flutter/material.dart';
import 'event_service.dart'; // Import the EventService class
import 'event.dart'; // Import the Event class
import 'event_details_screen.dart'; // Import the EventDetailsScreen class

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final EventService _eventService = EventService(); // Create an instance of EventService
  late List<Event> _events; // List to hold events

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events when the widget initializes
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _eventService.getAllEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      // Handle errors, e.g., show an error message to the user
      print('Error loading events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
      ),
      body: _events != null
          ? ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ListTile(
            title: Text(event.eventName),
            subtitle: Text(event.selectedLocation),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    // Delete the event when the delete button is pressed
                    await _eventService.deleteEvent(event.id ?? '');
                    // Reload the events after deletion
                    _loadEvents();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    // Implement your approval logic here
                    // You can update the event status to "Approved" in Firestore
                    await _eventService.approveEvent(event.id ?? '');
                    // Reload the events after approval
                    _loadEvents();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    // Navigate to a new screen to view event details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(event: event),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
