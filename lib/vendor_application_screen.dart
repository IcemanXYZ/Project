import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'vendor_service.dart'; // Import the VendorService class

class VendorApplicationScreen extends StatefulWidget {
  const VendorApplicationScreen({super.key});

  @override
  _VendorApplicationScreenState createState() =>
      _VendorApplicationScreenState();
}

class _VendorApplicationScreenState extends State<VendorApplicationScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _menuOfferingsController = TextEditingController();
  final TextEditingController _certificationsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VendorService _vendorService = VendorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
            ),
            TextFormField(
              controller: _menuOfferingsController,
              decoration: const InputDecoration(labelText: 'Menu Offerings'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _certificationsController,
              decoration: const InputDecoration(labelText: 'Certifications'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Get the entered data from text controllers
                String businessName = _businessNameController.text;
                String certifications = _certificationsController.text;

                try {
                  // Get the current user
                  User? user = _auth.currentUser;

                  if (user != null) {
                    // You should define these variables with appropriate values
                    String itemName = 'Item Name'; // Example value
                    String itemDescription = 'Item Description'; // Example value
                    double itemPrice = 10.0; // Example value

                    // Create a vendor using the VendorService
                    await _vendorService.createVendor(
                      user.uid,
                      businessName,
                      certifications,
                    );

                    // Create a menu offering using the VendorService
                    await _vendorService.addMenuItem(
                      user.uid, // userId
                      itemName,
                      itemDescription,
                      itemPrice,
                    );

                    // Optionally, you can display a confirmation message to the user.
                    // You can also navigate the user back to their dashboard or show a confirmation dialog.
                  } else {
                    // Handle the case where the user is not authenticated.
                    // You can show an error message or prompt the user to log in.
                  }
                } catch (e) {
                  // Handle any errors that occur during data submission.
                  print('Error submitting vendor application: $e');
                  // Optionally, display an error message to the user.
                }
              },
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}
