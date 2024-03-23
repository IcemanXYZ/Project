import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'upgrade_request_form.dart';
import 'upgrade_request_service.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  _GuestHomePageState createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  User? currentUser;
  late String name;
  late String userRole;
  late String profilePicUrl;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var userDocument = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
        if (userDocument.exists) {
          setState(() {
            name = userDocument.data()?['Name'] ?? '';
            userRole = userDocument.data()?['Role'] ?? '';
            profilePicUrl = userDocument.data()?['ProfilePicture'] ?? 'default_profile_pic_url';
          });
        } else {
          // Handle case where user document does not exist
          print("Document does not exist!");
        }
      }
    } catch (e) {
      // Handle any errors that occur during fetch
      print("Error fetching user info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR GUEST DASHBOARD'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name.isNotEmpty ? name : 'Loading...'),
              accountEmail: Text(userRole),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(profilePicUrl),
              ),
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('MANAGE MY PROFILE', style: TextStyle(fontSize: 11)),
              children: [

                ListTile(
                  title: const Text('Update my Profile', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to UserProfileScreen
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                    );
                  },
                ),

                ListTile(
                  title: const Text('Apply for a Role Upgrade', style: TextStyle(fontSize: 11)),
                  onTap: () async {
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();

                    // Check if the user has an active upgrade request
                    if(currentUser != null){
                      bool hasActiveRequest = await UpgradeRequestService().hasActiveUpgradeRequest(currentUser!.uid);

                      // If the user has an active upgrade request, show a message
                      if (hasActiveRequest) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You already have an active upgrade request. Please complete or close the existing request before applying for a new one.')),
                        );
                      } else {
                        // If there is no active upgrade request, navigate to UpgradeRequestForm
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UpgradeRequestForm(userRole: userRole)),
                        );
                      }
                    } else {
                      // Handle the case when currentUser is null
                      print('Current user is null.');
                    }
                  },
                ),

              ],
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('EVENTS', style: TextStyle(fontSize: 11)),
              children: [

                ListTile(
                  title: const Text('View Upcoming Events', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // will include options for viewing and registering for events. registering will navigate to payments.
                  },
                ),

                ListTile(
                  title: const Text('Event Check-in', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // will include options for viewing and registering for events. registering will navigate to payments.
                  },
                ),

                ListTile(
                  title: const Text('Merchandise and Memorabilia', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // will include options for viewing and registering for events. registering will navigate to payments.
                  },
                ),

                ListTile(
                  title: const Text('Access Events Materials', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                  },
                ),

                ListTile(
                  title: const Text('Livestreaming', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                  },
                ),

                ListTile(
                  title: const Text('Feedback & Surveys', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Provide Feedback & Analysis on evens/
                  },
                ),


                ListTile(
                  title: const Text('Video on Demand [VOD]', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
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
              ],
            ),

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('INTERACTIVE MAPS & DIRECTIONS', style: TextStyle(fontSize: 11)),
              children: [

                ListTile(
                  title: const Text('Campus Navigation', style: TextStyle(fontSize: 11)),
                  onTap: () {
                  },
                ),

              ],
            ),

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
      ),      body: const Center(
      child: Text('WELCOME, GUEST!'),
    ),
    );
  }
}

void main() => runApp(const MaterialApp(
  home: GuestHomePage(),
  // Define routes for other screens as needed
  routes: {
    // '/login': (context) => LoginScreen(), // Replace with your actual login screen
    // ... other routes
  },
));