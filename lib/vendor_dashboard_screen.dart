// VendorDashboardScreen.dart

import 'package:flutter/material.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Vendor Profile Management screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => VendorProfileScreen()),
                );
              },
              child: const Text('Manage Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Menu Management screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MenuManagementScreen()),
                );
              },
              child: const Text('Manage Menu'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Pricing Management screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PricingManagementScreen()),
                );
              },
              child: const Text('Set Pricing'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Communication screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CommunicationScreen()),
                );
              },
              child: const Text('Communicate with Event Organizers'),
            ),
          ],
        ),
      ),
    );
  }
}

// VendorProfileScreen.dart (Vendor Profile Management Screen)
// Implement this screen similarly to VendorDashboardScreen for managing the vendor's profile.

// MenuManagementScreen.dart (Menu Management Screen)
// Implement this screen for managing the vendor's menu offerings.

// PricingManagementScreen.dart (Pricing Management Screen)
// Implement this screen for setting or adjusting pricing details.

// CommunicationScreen.dart (Communication Screen)
// Implement this screen for communication with event organizers.
