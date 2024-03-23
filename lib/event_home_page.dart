import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'event_capture_form.dart';
import 'event_list.dart';
import 'sponsor_management.dart';
import 'upgrade_request_form.dart';

class EventHomePage extends StatefulWidget {
  const EventHomePage({super.key});

  @override
  _EventHomePageState createState() => _EventHomePageState();
}

class _EventHomePageState extends State<EventHomePage> {
  User? currentUser;
  late String name;
  late String userRole;
  late String profilePicUrl;

  @override
  void initState() {
    super.initState();
    name = ''; // Provide an empty string as a default value
    userRole = ''; // Provide an empty string as a default value
    profilePicUrl = 'assets/images/default_user.png'; // Updated to use a local asset

    fetchUserInfo().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> fetchUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      var profilePicture = userDocument.data()?['ProfilePicture'];

      setState(() {
        name = userDocument.data()?['Name'] ?? ''; // Default to empty string if not found
        userRole = userDocument.data()?['Role'] ?? ''; // Default to empty string if not found
        // Check if profilePicture is not null and not empty; otherwise, use the default asset path
        profilePicUrl = profilePicture != null && profilePicture.isNotEmpty ? profilePicture : 'assets/images/default_user.png';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR DASHBOARD'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(userRole),
              currentAccountPicture: CircleAvatar(
                backgroundImage: profilePicUrl.startsWith('http')
                    ? NetworkImage(profilePicUrl)
                    : AssetImage(profilePicUrl) as ImageProvider,
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
                  MaterialPageRoute(
                      builder: (context) => const UserProfileScreen()),
                );
              },
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('MANAGE YOUR PROFILE',
                  style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text(
                    'Update my profile',
                    style: TextStyle(fontSize: 11), // Updated fontSize for better readability
                  ),
                  onTap: () {
                    // Use Navigator to push SponsorManagement onto the navigation stack
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'Upgrade my role', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'Upgrade my Role'
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpgradeRequestForm(userRole: userRole)),
                    );
                  },
                ),
              ],
            ),


            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('SPONSORS / PARTNERS MANAGEMENT',
                  style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text(
                    'Manage Sponsors',
                    style: TextStyle(fontSize: 11), // Updated fontSize for better readability
                  ),
                  onTap: () {
                    // Use Navigator to push SponsorManagement onto the navigation stack
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SponsorManagement()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'My Sponsors/Partners', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My Sponsors/Partners'
                  },
                ),
              ],
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text(
                  'EVENT MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text(
                      'Add an event', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventCaptureForm()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'My events', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),

                ListTile(
                  title: const Text('Manage Merchandise and Memorabilia', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // will include options for viewing and registering for events. registering will navigate to payments.
                  },
                ),


                ListTile(
                  title: const Text(
                      'Social Media Integration', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),

              ],
            ),


            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text(
                  'ANALYTICS', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text(
                      'Event Attendance', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventCaptureForm()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'Event Feedback', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'Ticket sales', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'Sponsorships', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),

                ListTile(
                  title: const Text(
                      'Expenses', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),
              ],
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text(
                  'VOLUNTEER MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text(
                      'Assign a Volunteer', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventCaptureForm()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                      'Scheduling', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My events'
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to EventCaptureForm
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EventList()),
                    );
                  },
                ),
              ],
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('FEEDBACK & ANALYSIS', style: TextStyle(fontSize: 11)),
              children: [

                ListTile(
                  title: const Text('Event Feedback & Analysis', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),

                ListTile(
                  title: const Text('Venue Feedback & Analysis', style: TextStyle(fontSize: 11)),
                  onTap: () {

                    // Close the drawer before navigating to the next screen. Options to view,edit,delete,process(accept/reject)

                  },
                ),

                ListTile(
                  title: const Text('Ratings Reviews', style: TextStyle(fontSize: 11)),
                  onTap: () {

                    // Close the drawer before navigating to the next screen. Options to view,edit,delete,process(accept/reject)

                  },
                ),
              ],
            ),

            // Add more ExpansionTiles and ListTiles as needed...

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('LOG OUT', style: TextStyle(fontSize: 11)),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: currentUser != null
            ? Text('Welcome, $name!')
            : const Text('User not logged in'), // Correctly handle the case when currentUser is null
      ),
    );
  }
}

void main() => runApp(const MaterialApp(
  home: EventHomePage(),
  // Define routes for other screens as needed
  routes: {
    // '/login': (context) => LoginScreen(), // Replace with your actual login screen
    // ... other routes
  },
));