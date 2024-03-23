import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecordSuccessfulUpdateScreen extends StatelessWidget {
  final String message;
  final String backRoute;
  final String ctaButtonText; // Accepts the CTA button text

  const RecordSuccessfulUpdateScreen({
    super.key,
    required this.message,
    required this.backRoute,
    this.ctaButtonText = 'Back to Homepage', // Default value if not provided
  });

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
              'assets/icons/check_circle.svg', // Ensure this asset exists in your project
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, backRoute),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
              child: Text(ctaButtonText), // Uses the provided CTA button text
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
