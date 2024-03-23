import 'package:flutter/material.dart';
import 'venue.dart'; // Import your Venue model
import 'venue_service.dart';
import 'venue_calendar.dart';
import 'event.dart'; // Make sure this import is correct

class VenueSelectionScreen extends StatefulWidget {
  final Event eventDetails; // Use the Event class instead of Map

  const VenueSelectionScreen({super.key, required this.eventDetails});

  @override
  _VenueSelectionScreenState createState() => _VenueSelectionScreenState();
}

class _VenueSelectionScreenState extends State<VenueSelectionScreen> {
  String selectedVenue = ''; // Variable to store selected venue
  bool isVenueAvailable = true; // Variable to track venue availability
  // Define availableVenues with the available venues in your app
  List<String> availableVenues = ['Venue A', 'Venue B', 'Venue C'];

  TimeSlot? selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    // Initialize selectedTimeSlot inside the initState method
    selectedTimeSlot = TimeSlot(
      widget.eventDetails.startDate,
      widget.eventDetails.endDate,
    );
  }

  // Rest of your code...

// Function to perform venue availability check
  void checkVenueAvailability(String selectedVenue) async {
    try {
      // Assuming you have an instance of VenueService.
      VenueService venueService = VenueService();

      // Retrieve the Venue object by name
      Venue? venue = await venueService.getVenueByName(selectedVenue);

      if (venue != null) {
        DateTime selectedStartDate = widget.eventDetails.startDate; // Check property name
        DateTime selectedEndDate = widget.eventDetails.endDate; // Check property name

        // Ensure selectedTimeSlot is not null before using it
        if (selectedTimeSlot != null) {
          // Check venue availability for the selected date and time range
          bool isAvailable = true; // Initialize as available (for the sake of this example)

          for (DateTime date = selectedStartDate; date.isBefore(selectedEndDate); date = date.add(const Duration(days: 1))) {
            // Assuming you have a VenueCalendar class to represent venue availability
            bool isSlotAvailable = venue.checkAvailability(date, selectedTimeSlot!); // Use ! to assert non-null

            // Update isAvailable based on the availability of this slot
            if (!isSlotAvailable) {
              isAvailable = false;
              break; // No need to check further if one slot is unavailable
            }
          }

          setState(() {
            isVenueAvailable = isAvailable;
          });
        } else {
          // Handle the case when selectedTimeSlot is null
          print('Selected time slot is null.');
        }
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Selection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Event Details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Start Date: ${widget.eventDetails.startDate}'), // Replace with the correct property name
            Text('End Date: ${widget.eventDetails.endDate}'), // Replace with the correct property name
            Text('Number of Attendees: ${widget.eventDetails.attendeeList.length}'), // Replace with the correct property name and logic
            // Add more event details here

            const SizedBox(height: 16.0),

            const Text(
              'Select Venue:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: selectedVenue,
              onChanged: (value) {
                setState(() {
                  selectedVenue = value!;
                });
              },
              items: availableVenues.map((venue) {
                return DropdownMenuItem<String>(
                  value: venue,
                  child: Text(venue),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Available Venues',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8.0),

            ElevatedButton(
              onPressed: () {
                // Perform venue availability check
                checkVenueAvailability(selectedVenue);
              },
              child: const Text('Check Venue Availability'),
            ),

            const SizedBox(height: 16.0),

            if (isVenueAvailable)
              const Text(
                'Venue is available for the chosen date and time.',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Venue is not available for the chosen date and time.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Display conflict resolution options here
                  // You can provide alternative dates or venues
                ],
              ),
          ],
        ),
      ),
    );
  }
}

