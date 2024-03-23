import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'error_screen.dart';
import 'splash_screen.dart';  // Assuming you have a file named splash_screen.dart
import 'signin_page.dart';    // Assuming you have a file named signin_page.dart
import 'student_home_page.dart';
import 'faculty_home_page.dart';
import 'guest_home_page.dart';
import 'onboarding_screen.dart';
import 'venue_homepage.dart';
import 'vendor_home_page.dart';
import 'event_home_page.dart';
import 'sysadmin_home_page.dart';
import 'sponsor_management.dart';
import 'vendor_upgrade_request_form.dart';
import 'admin_home_page.dart';
//import 'upgrade_requests_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // Your Firebase configuration
      apiKey: "AIzaSyBvmPQ06uDFHE1NQT9b6qBGiHp3tTAmBCc",
      authDomain: "endowrim-24dbd.firebaseapp.com",
      projectId: "endowrim-24dbd",
      storageBucket: "endowrim-24dbd.appspot.com      ",
      messagingSenderId: "487879313721", // Add the missing double quote
      appId: "1:487879313721:android:e7aa99095461ddf6b700e8",
      // messagingSenderId: "168513249340",
      //appId: "1:168513249340:android:ee108e1ebf823418e1e339",

    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'endowrim Events',
      theme: ThemeData(
        // Your theme data here
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0), // Default text style
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Adjust the scale factor as needed
          ),
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const SignInPage(),
        '/login': (context) => const LoginScreen(),
//        '/upgradeRequestReview': (context) => UpgradeRequestList(),
        '/register': (context) => const RegistrationScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/studentHomePage': (context) => const StudentHomePage(),
        '/adminHomePage': (context) => const AdminHomePage(),
        '/facultyHomePage': (context) => const FacultyHomePage(),
        '/sponsorManagement': (context) => const SponsorManagement(),
        '/vendorUpgradeRequestForm': (context) => const VendorUpgradeRequestForm(),
        '/guestHomePage': (context) => const GuestHomePage(),
        '/venueHomepage': (context) => const VenueHomePage(),
        '/vendorHomePage': (context) => const VendorHomePage(),
        '/eventHomePage': (context) => const EventHomePage(),
        '/sysadminHomePage': (context) => const SysadminHomePage(),

        // Define other routes here
      },        onUnknownRoute: (settings) => MaterialPageRoute(
      builder: (context) => const ErrorScreen(error: 'Page not found'),
    ),
    );
  }
}