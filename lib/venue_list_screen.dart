import 'package:flutter/material.dart';
import 'venue.dart';
import 'add_venue_screen.dart';
import 'edit_venue_screen.dart';
import 'delete_venue_screen.dart'; // Make sure to import the correct file
import 'venue_service.dart';
import 'venue_detail_screen.dart';


class VenueListScreen extends StatefulWidget {
  final List<Venue> venues;

  // Use 'super' for the 'key' parameter.
  const VenueListScreen({super.key, required this.venues});

  @override
  VenueListScreenState createState() => VenueListScreenState();
}

class VenueListScreenState extends State<VenueListScreen> {
  final VenueService _venueService = VenueService();
  List<Venue> _venues = [];

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  void _loadVenues() async {
    // Replace with actual data fetching logic from your VenueService
    var fetchedVenues = await _venueService.getVenues();
    setState(() {
      _venues = fetchedVenues;
    });
  }

  // ... _showOptions and _confirmDelete methods remain the same
  void _showOptions(BuildContext context, Venue venue) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EditVenueScreen(venue: venue, venueService: VenueService()),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                  // Code to handle deletion
                  // For example, you could navigate to a delete confirmation screen or show a dialog to confirm
                  _confirmDelete(context, venue);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Venue venue) {
    // Show a dialog to confirm deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${venue.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // Navigate to the DeleteVenueScreen with the selected venue
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteVenueScreen(venue: venue),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue List'),
      ),
      body: ListView.builder(
        itemCount: _venues.length,
        itemBuilder: (context, index) {
          final venue = _venues[index];
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  Expanded(child: Text(venue.name)),
                  Expanded(child: Text(venue.location)),
                  Expanded(child: Text('${venue.capacity}')),
                  Expanded(child: Text('${venue.maxOccupancy}')),
                  Expanded(child: Text(venue.rating.toStringAsFixed(1))),
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VenueDetailScreen(venue: venue),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showOptions(context, venue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(context, venue),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddVenueScreen(),
            ),
          );

          // If the add operation indicates a change (e.g., new venue added), reload venues
          if (result == true) {
            _loadVenues();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}