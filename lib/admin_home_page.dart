import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'sponsor_management.dart';
import 'upgrade_request_form.dart';
import 'upgrade_request_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
        title: const Text('YOUR ADMIN DASHBOARD'),
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
            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('USER PROFILE MANAGEMENT',
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

                ListTile(
                  title: const Text(
                      'Approve or Reject User Profile Upgrade', style: TextStyle(fontSize: 11)),
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
                    'Authorise Sponsors/Partners',
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
                      'Sponsors/Partners List', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Handle the tap for 'My Sponsors/Partners'
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
  home: AdminHomePage(),
  // Define routes for other screens as needed
  routes: {
    // '/login': (context) => LoginScreen(), // Replace with your actual login screen
    // ... other routes
  },
));