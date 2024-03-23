import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key}); // Fix 1: Pass 'key' to the super constructor

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState(); // Fix 2: State class made public
}

class UserProfileScreenState extends State<UserProfileScreen> { // Fix 2: Class name changed to public
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _departmentController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _nameController.text = userProfile['Name'];
      _phoneNumberController.text = userProfile['Phone Number'];
      _departmentController.text = userProfile['Department'];
      // Ensure setState is called to rebuild the widgets with updated data.
      setState(() {});
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateUserProfile() async {
    final localContext = context; // Fix 3: Use a local reference to context
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'Name': _nameController.text,
        'Phone Number': _phoneNumberController.text,
        'Department': _departmentController.text,
      });
      if (mounted) { // Fix 3: Check that the widget is still mounted
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(localContext).showSnackBar(
          SnackBar(
            content: const Text('Your profile updated successfully'),
            action: SnackBarAction(
              label: 'Back to Menu',
              onPressed: () {
                // Navigate back to the main menu
                Navigator.of(localContext).popUntil((route) => route.isFirst);
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

}

