import 'package:flutter/material.dart';
import 'vendor_service.dart'; // Make sure this import points to your VendorService
import 'record_successful_update_screen.dart'; // Ensure correct import path
import 'package:firebase_auth/firebase_auth.dart';

class VendorUpgradeRequestForm extends StatefulWidget {
  const VendorUpgradeRequestForm({super.key});

  @override
  _VendorUpgradeRequestFormState createState() => _VendorUpgradeRequestFormState();
}

class _VendorUpgradeRequestFormState extends State<VendorUpgradeRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final VendorService _vendorService = VendorService();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _certificationsController = TextEditingController();
  bool _isLoading = false; // Local state for loading indicator

  @override
  void dispose() {
    _businessNameController.dispose();
    _certificationsController.dispose();
    super.dispose();
  }

  Future<void> submitUpgradeRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final String businessName = _businessNameController.text.trim();
      final String certifications = _certificationsController.text.trim();
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      try {
        await _vendorService.createVendor(userId, businessName, certifications);

        // Navigate to the RecordSuccessfulUpdateScreen with customized CTA button text
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RecordSuccessfulUpdateScreen(
              message: 'Your request to upgrade to a vendor profile has been submitted successfully and is pending review.',
              backRoute: '/vendorHomePage', // Assuming this is the route name for VendorHomePage
              ctaButtonText: 'Back to Homepage', // Custom CTA button text
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting upgrade request: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Upgrade Request'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your business name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _certificationsController,
              decoration: const InputDecoration(labelText: 'Certifications'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your certifications';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitUpgradeRequest,
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
