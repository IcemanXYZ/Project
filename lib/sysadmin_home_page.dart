import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_screen.dart';
import 'upgrade_requests_list.dart';
import 'upgrade_request_service.dart';

class SysadminHomePage extends StatefulWidget {
  const SysadminHomePage({super.key});

  @override
  _SysadminHomePageState createState() => _SysadminHomePageState();
}

class _SysadminHomePageState extends State<SysadminHomePage> {
  User? currentUser;
  String name = '';
  String userRole = '';
  String profilePicUrl = 'assets/images/default_user.png';
  late UpgradeRequestService upgradeRequestService;

  @override
  void initState() {
    super.initState();
    upgradeRequestService = UpgradeRequestService();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var userDocument = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
        var profilePicture = userDocument.data()?['ProfilePicture'];

        setState(() {
          name = '${userDocument.data()?['First Name'] ?? ''} ${userDocument.data()?['Last Name'] ?? ''}';
          userRole = userDocument.data()?['Role'] ?? '';
          profilePicUrl = profilePicture != null && profilePicture.isNotEmpty ? profilePicture : 'assets/images/default_user.png';
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
      // Handle error gracefully, e.g., show error message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR SYSTEMS ADMIN DASHBOARD'),
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
              title: const Text('Manage Your Profile', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                );
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('USER PROFILE MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Reset User Password', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to reset user password
                  },
                ),
                ListTile(
                  title: const Text('Update User Permissions', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to update user permissions
                  },
                ),
                ListTile(
                  title: const Text('Approve Role Changes', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UpgradeRequestsList(currentUserRole: userRole, upgradeRequestService: upgradeRequestService)),
                    );
                  },
                  trailing: const Stack(
                    children: [
                      Icon(Icons.notification_important), // Replace with your icon
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '3', // Replace with actual count
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('VENDOR MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Review Vendor Application Forms', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to review vendor application forms
                  },
                ),
                ListTile(
                  title: const Text('Vendor List', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to vendor list
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
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Show loading indicator while fetching data
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SysadminHomePage(),
    routes: {
      // Define routes for other screens as needed
      // '/login': (context) => LoginScreen(),
      // ... other routes
    },
  ));
}
