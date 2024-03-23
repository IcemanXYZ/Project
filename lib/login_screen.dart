import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!mounted) return; // Check if the widget is still in the widget tree
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null && mounted) { // Check mounted again because this is after an await
        await _navigateBasedOnStatus(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) { // Check mounted before showing the dialog
        _showErrorDialog(e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      if (mounted) { // Check mounted before showing the dialog
        _showErrorDialog('An unexpected error occurred.');
      }
    } finally {
      if (mounted) { // Check mounted before setting the state
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateBasedOnStatus(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final userRole = userData['Role'] as String? ?? 'unknown';
      final hasCompletedOnboarding = userData['hasCompletedOnboarding'] as bool? ?? false;

      if (!hasCompletedOnboarding) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else {
        _navigateToHomePage(userRole);
      }
    }
  }

  void _navigateToHomePage(String userRole) {
    switch (userRole) {
      case 'Student/Alumni':
        Navigator.of(context).pushReplacementNamed('/studentHomePage');
        break;
      case 'Faculty Member':
        Navigator.of(context).pushReplacementNamed('/facultyHomePage');
        break;
    // Add other cases as needed
      case 'Guest':
        Navigator.of(context).pushReplacementNamed('/guestHomePage');
        break;
      case 'Venue Manager':
        Navigator.of(context).pushReplacementNamed('/venueHomepage');
        break;
      case 'Vendor':
        Navigator.of(context).pushReplacementNamed('/vendorHomePage');
        break;
      case 'Event Manager':
        Navigator.of(context).pushReplacementNamed('/eventHomePage');
        break;
      case 'System Administrator':
        Navigator.of(context).pushReplacementNamed('/sysadminHomePage');
        break;

      case 'Administrator':
        Navigator.of(context).pushReplacementNamed('/adminHomePage');
        break;


    // Default case for unknown or unspecified roles
      default:
        Navigator.of(context).pushReplacementNamed('/defaultHomePage');
        break;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              FlutterLogo(size: MediaQuery.of(context).size.width * 0.15),
              Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onSubmitted: (_) => _login(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/facebook.svg'),
                    onPressed: () {
                      // Implement Facebook Sign-In
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/twitter.svg'),
                    onPressed: () {
                      // Implement Twitter Sign-In
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/google.svg'),
                    onPressed: () {
                      // Implement Google Sign-In
                    },
                  ),
                ],
              ),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
