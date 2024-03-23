import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'upgrade_request_form.dart';
import 'upgrade_request_service.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
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
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var userDocument = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      setState(() {
        name = userDocument['Name'];
        userRole = userDocument['Role'];
        profilePicUrl = userDocument['ProfilePicture'] ?? 'default_profile_pic_url';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
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
              title: const Text('EVENT MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Search Events', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),
                ListTile(
                  title: const Text('My Events', style: TextStyle(fontSize: 11)),
                  onTap: () {
/*
                // Close the drawer before navigating to the next screen
				Navigator.of(context).pop();
                //Navigate to SearchEventsScreen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchEventsScreen()),
                );
*/                  },
                ),
              ],
            ),


            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('EVENT VOLUNTEER MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Apply to Volunteer', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),
                ListTile(
                  title: const Text('Volunteering Deregister', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to volunteering deregister
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Event Check-in', style: TextStyle(fontSize: 11)),
              onTap: () {
                // Navigate to Event Check-in
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback & Surveys', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Feedback on Events', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to provide feedback on events
                  },
                ),
                ListTile(
                  title: const Text('Feedback on Venues', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to provide feedback on venues or services
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Surveys', style: TextStyle(fontSize: 11)),
              onTap: () {
                // Navigate to provide feedback on venues or services
              },
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
      child: Text('Welcome, Student!'),
    ),
    );
  }
}

void main() => runApp(const MaterialApp(
  home: StudentHomePage(),
  // Define routes for other screens as needed
  routes: {
    // '/login': (context) => LoginScreen(), // Replace with your actual login screen
    // ... other routes
  },
));