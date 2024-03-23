import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_venue_screen.dart';
import 'edit_venue_screen.dart';
//import 'delete_venue_screen.dart';
import 'venue_list_screen.dart';
import 'venue.dart';
import 'venue_service.dart';
import 'user_profile_screen.dart';

class VenueHomePage extends StatefulWidget {
  const VenueHomePage({super.key});

  @override
  _VenueHomePageState createState() => _VenueHomePageState();
}

class _VenueHomePageState extends State<VenueHomePage> {
  User? currentUser;
  late String name;
  late String userRole;
  late String profilePicUrl;

  final VenueService _venueService = VenueService();

  List<Venue> venues = []; // Declare the venues list

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Stream<List<Venue>> streamVenues() {
    return _venueService.getVenuesStream(); // Use the VenueService method
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  Future<void> fetchUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var userDocument = await FirebaseFirestore.instance.collection('users')
          .doc(currentUser!.uid)
          .get();
      setState(() {
        name = userDocument['Name'];
        userRole = userDocument['Role'];
        profilePicUrl =
            userDocument['ProfilePicture'] ?? 'default_profile_pic_url';
      });
    }
  }

  Future<bool> showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this venue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false; // If the dialog is dismissed without selection, return false
  }

  void editSelectedVenue(Venue venue) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditVenueScreen(venue: venue, venueService: _venueService),
    ));
  }

  Future<void> deleteSelectedVenue(Venue venue) async {
    bool confirmDelete = await showDeleteConfirmationDialog();
    if (confirmDelete) {
      try {
        await _venueService.deleteVenue(venue.venueID);
        showSuccessMessage('Venue deleted successfully');
        refreshVenuesList();
      } catch (e) {
        print('Error deleting venue: $e');
        showErrorDialog('An error occurred while deleting the venue.');
      }
    }
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void refreshVenuesList() {
    setState(() {}); // Trigger a rebuild of the StreamBuilder
  }


  // Fetch all venues as a stream for real-time updates
  Stream<List<Venue>> getVenuesStream() {
    return _venueService.getVenuesStream(); // Use the VenueService method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Management Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(userRole),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(profilePicUrl),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'MANAGE YOUR PROFILE',
                style: TextStyle(fontSize: 11),
              ),
              onTap: () {
                // Close the drawer before navigating to the next screen
                Navigator.of(context).pop();
                // Navigate to UserProfileScreen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                );
              },
            ),
            buildVenueProfileManagementExpansionTile(),
            buildBookingAndReservationManagementExpansionTile(),
            buildResourceAllocationAndManagementExpansionTile(),
            buildPricingAndFinancialFunctionsExpansionTile(),
            buildCustomerServiceAndCommunicationExpansionTile(),
            buildReportingAndAnalyticsExpansionTile(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Log Out',
                style: TextStyle(fontSize: 11),
              ),
              onTap: () {
                // Handle user log out
                FirebaseAuth.instance.signOut();
                // Optionally navigate the user to the login screen
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      body: currentUser != null
          ? buildDashboard(currentUser!) // Display the dashboard for the logged-in user
          : StreamBuilder<List<Venue>>(
        stream: _venueService.getVenuesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No venues found'));
          } else {
            venues = snapshot.data!; // Assign the list of venues
            return ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, index) {
                Venue venue = venues[index];
                return ListTile(
                  title: Text(venue.name),
                  // ... Additional ListTile properties
                  onTap: () => editSelectedVenue(venue),
                  onLongPress: () => deleteSelectedVenue(venue),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildDashboard(User user) {
    return SingleChildScrollView(  // Use SingleChildScrollView for a scrollable dashboard
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              //'${_getGreeting()}, ${user.displayName ?? "User"}', // Display greeting with user's name
              '${_getGreeting()}, $name', // Display greeting with user's name
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          // Add dashboard widgets here
          // Example: Overview of bookings, upcoming events, etc.
        ],
      ),
    );
  }
  // ... Other expansion tiles ...

  ExpansionTile buildVenueProfileManagementExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.business),
      title: const Text(
        'VENUE PROFILE MANAGEMENT ',
        style: TextStyle(fontSize: 11),
      ),
      children: [
        ListTile(
          title: const Text(
            'Add Venue',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Add Venue Page
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AddVenueScreen()));
          },
        ),
        ListTile(
          title: const Text(
            'Venues List',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Venues List Page
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => VenueListScreen(venues: venues)));
          },
        ),
        ListTile(
          title: const Text(
            'Ratings and Reviews',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Ratings and Reviews Page
          },
        ),
        ListTile(
          title: const Text(
            'Calendar Integration',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Calendar Integration Page
          },
        ),
        ListTile(
          title: const Text(
            'Photo Gallery Feature',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Photo Gallery Feature Page
          },
        ),
      ],
    );
  }

  // ... Other expansion tiles ...

  ExpansionTile buildBookingAndReservationManagementExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.book_online),
      title: const Text(
        'BOOKING & RESERVATION MANAGEMENT',
        style: TextStyle(fontSize: 11),
      ),
      children: [
        ListTile(
          title: const Text(
            'Pending Bookings and Reservations',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Pending Bookings and Reservations Page
          },
        ),
        ListTile(
          title: const Text(
            'Bookings & Reservations List',
            style: TextStyle(fontSize: 11),
          ),
          onTap: () {
            // Navigate to Bookings & Reservations List Page
          },
        ),
      ],
    );
  }

// ... Other expansion tiles ...

// Implement other expansion tiles in a similar way
  ExpansionTile buildResourceAllocationAndManagementExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.category),
      title: const Text('RESOURCE ALLOCATION & MANAGEMENT',
        style: TextStyle(fontSize: 11), // Set the font size to 11
      ),
      children: [
        ListTile(
          title: const Text('Manage Resources',
            style: TextStyle(fontSize: 11), // Set the font size to 11
          ),
          onTap: () {
            // Navigate to Manage Resources Page
          },
        ),
      ],
    );
  }

  ExpansionTile buildPricingAndFinancialFunctionsExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.attach_money),
      title: const Text('PRICING & FINANCIAL FUNCTIONS',
        style: TextStyle(fontSize: 11), // Set the font size to 11
      ),
      children: [
        ListTile(
          title: const Text('Set Pricing',
            style: TextStyle(fontSize: 11), // Set the font size to 11
          ),
          onTap: () {
            // Navigate to Set Pricing Page
          },
        ),
        ListTile(
          title: const Text('Process Payments',
            style: TextStyle(fontSize: 11), // Set the font size to 11
          ),
          onTap: () {
            // Navigate to Process Payments Page
          },
        ),
      ],
    );
  }

  ExpansionTile buildCustomerServiceAndCommunicationExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.support_agent),
      title: const Text('CUSTOMER SERVICE & COMMUNICATION',
        style: TextStyle(fontSize: 11), // Set the font size to 11
      ),
      children: [
        ListTile(
          title: const Text('Support and Queries',
            style: TextStyle(fontSize: 11), // Set the font size to 11
          ),
          onTap: () {
            // Navigate to Support and Queries Page
          },
        ),
      ],
    );
  }

  ExpansionTile buildReportingAndAnalyticsExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.bar_chart),
      title: const Text('REPORTING & ANALYTICS',
        style: TextStyle(fontSize: 11), // Set the font size to 11
      ),
      children: [
        ListTile(
          title: const Text('Venue Usage Reports',
            style: TextStyle(fontSize: 11), // Set the font size to 11
          ),
          onTap: () {
            // Navigate to Venue Usage Reports Page
          },
        ),
      ],
    );
  }

}

void main() => runApp(const MaterialApp(home: VenueHomePage()));