import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_screen.dart';
import 'vendor_upgrade_request_form.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  User? currentUser;
  String name = ''; // Initialize with default empty string
  String userRole = ''; // Initialize with default empty string
  String profilePicUrl = 'default_profile_pic_url'; // Default URL or empty string

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
        title: const Text('YOUR VENDOR DASHBOARD'),
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

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'MANAGE YOUR BUSINESS PROFILE',
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

            ExpansionTile(
              leading: const Icon(Icons.group),
              title: const Text('VENDOR SERVICE MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Profile Upgrade Request', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Close the drawer before navigating to the next screen
                    Navigator.of(context).pop();
                    // Navigate to UserProfileScreen
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const VendorUpgradeRequestForm()),
                    );
                  },
                ),

                ListTile(
                  title: const Text('Add a Service', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),
                ListTile(
                  title: const Text('Service Filtering', style: TextStyle(fontSize: 11)),
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
              title: const Text('SERVICE REQUEST MANAGEMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Request List/Inbox', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    // Navigate to apply for volunteering
                  },
                ),
                ListTile(
                  title: const Text('Request Filtering', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Scheduling Integration', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Contract Generation', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Communicate with Event Organizers', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Analytics & Insights', style: TextStyle(fontSize: 11)),
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
              title: const Text('SERVICE FULFILMENT', style: TextStyle(fontSize: 11)),
              children: [
                ListTile(
                  title: const Text('Schedule Management', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Logistics Coordination', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Communicate with Event Organizers', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Documentation and Contracts', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Feedback Collection', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Issue Resolution', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Earnings Summary', style: TextStyle(fontSize: 11)),
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
                  title: const Text('Outstanding Amounts', style: TextStyle(fontSize: 11)),
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
      child: Text('Welcome, Vendor!'),
    ),
    );
  }
}

void main() => runApp(const MaterialApp(
  home: VendorHomePage(),
  // Define routes for other screens as needed
  routes: {
    // '/login': (context) => LoginScreen(), // Replace with your actual login screen
    // ... other routes
  },
));