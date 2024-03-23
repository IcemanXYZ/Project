import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'upgrade_request_form.dart';
import 'upgrade_request_service.dart';

class FacultyHomePage extends StatefulWidget {
  const FacultyHomePage({super.key});

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
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
                  title: const Text('Add an event', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),
                ListTile(
                  title: const Text('My events', style: TextStyle(fontSize: 11)),
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
              title: const Text('MANAGE INVITATIONS', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Send Invites', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),
                ListTile(
                  title: const Text('Pending Invites', style: TextStyle(fontSize: 11)),
                  onTap: () {
/*
                // Close the drawer before navigating to the next screen. Options to view,edit,delete,process(accept/reject)
				Navigator.of(context).pop();
                //Navigate to SearchEventsScreen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchEventsScreen()),
                );
*/                  },
                ),


                ListTile(
                  title: const Text('Notifications', style: TextStyle(fontSize: 11)),
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


                ListTile(
                  title: const Text('Communicate with Vendors / Event Managers', style: TextStyle(fontSize: 11)),
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
              title: const Text('PAYMENTS', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Invoice Generation', style: TextStyle(fontSize: 11)),
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
                ListTile(
                  title: const Text('Refunds Management', style: TextStyle(fontSize: 11)),
                  onTap: () {
/*
                // Close the drawer before navigating to the next screen. Options to view,edit,delete,process(accept/reject)
				Navigator.of(context).pop();
                //Navigate to SearchEventsScreen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchEventsScreen()),
                );
*/                  },
                ),
                ListTile(
                  title: const Text('Payment Tracking', style: TextStyle(fontSize: 11)),
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
                ListTile(
                  title: const Text('Discounts and Promotions', style: TextStyle(fontSize: 11)),
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
                ListTile(
                  title: const Text('Payment Reminders', style: TextStyle(fontSize: 11)),
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
              title: const Text('ANALYTICS & INSIGHTS', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Event Analytics', style: TextStyle(fontSize: 11)),
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
                ListTile(
                  title: const Text('Attendance Review', style: TextStyle(fontSize: 11)),
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
                ListTile(
                  title: const Text('Engagement Metrics', style: TextStyle(fontSize: 11)),
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
              title: const Text('LIVESTREAMING', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Facebook', style: TextStyle(fontSize: 11)),
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
                ListTile(
                  title: const Text('Youtube', style: TextStyle(fontSize: 11)),
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
      child: Text('Welcome, Faculty Member!'),
    ),
    );
  }
}

void main() => runApp(const MaterialApp(
  home: FacultyHomePage(),
  // Define routes for other screens as needed
  routes: {
    // '/login': (context) => LoginScreen(), // Replace with your actual login screen
    // ... other routes
  },
));