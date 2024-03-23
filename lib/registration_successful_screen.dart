  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';

  class RegistrationSuccessfulScreen extends StatelessWidget {
    const RegistrationSuccessfulScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              SvgPicture.asset(
                'assets/check_circle.svg', // Ensure you have this asset in your project
                width: 100, // Adjust the size as needed
                height: 100, // Adjust the size as needed
              ),
              const SizedBox(height: 24),
              const Text(
                'User Registration Successful',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Text(
                  'Congratulations! You\'ve successfully registered your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // This assumes that your MaterialApp widget has a named route for the login screen.
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // This is the text color
                  minimumSize: const Size(double.infinity, 50), // Button size
                ),
                child: const Text('Back to Login'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    }
  }
