import 'package:flutter/material.dart';
import 'login_screen.dart'; // Make sure you have this file
import 'registration_screen.dart'; // Make sure you have this file

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView( // Wrap the content in a ListView
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterLogo(size: screenWidth * 0.2),
                  const SizedBox(height: 20),
                  Text(
                    'endowrim Events',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Connect, Engage, Inspire',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SignInButton(
                    text: 'Sign In',
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                    },
                  ),
                  SignInButton(
                    text: 'Sign Up',
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ));
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // Define what happens when skip is pressed
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // Text color
                    ),
                    child: const Text('SKIP'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const SignInButton({
    super.key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

