import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildOnboardingPages() {
    // Define your onboarding content here
    return [
      const Center(child: Text("Welcome to Endowrim Events Onboarding")),
      const Center(child: Text("Get Connected, Engaged, and Inspired',")),
    ];
  }

  void _completeOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'hasCompletedOnboarding': true,
      });

      // Fetch the user's role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String userRole = userDoc['Role'];

      // Navigate to the appropriate home page based on the user's role
      switch (userRole) {
        case 'Student/Alumni':
          Navigator.of(context).pushReplacementNamed('/studentHomePage');
          break;
        case 'Faculty Member':
          Navigator.of(context).pushReplacementNamed('/facultyHomePage');
          break;
        case 'Venue Manager':
          Navigator.of(context).pushReplacementNamed('/venueHomePage');
          break;

        default:  // Assumes 'Guest' or any other role
          Navigator.of(context).pushReplacementNamed('/guestHomePage');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: _buildOnboardingPages(),
      ),
      bottomSheet: _currentPage == _buildOnboardingPages().length - 1
          ? ElevatedButton(
        onPressed: _completeOnboarding,
        child: const Text('Get Started'),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: _completeOnboarding,
            child: const Text('Skip'),
          ),
          Row(
            children: List.generate(
              _buildOnboardingPages().length,
                  (index) => _buildPageIndicator(index == _currentPage),
            ),
          ),
          TextButton(
            child: const Text('Next'),
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 8.0,
      width: isCurrentPage ? 10.0 : 8.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
