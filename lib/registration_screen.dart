import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'registration_successful_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _departmentController = TextEditingController();
  final _eventPreferencesController = TextEditingController();
  final _genderController = TextEditingController();
  //final _birthMonthController = TextEditingController();
  //final _birthDayController = TextEditingController();
  //final _birthYearController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String _userRole = 'Guest';
  XFile? _userPhoto;
  bool _agreedToTerms = false;

//other variables:
  String _countryCode = '+263'; // Default country code, you can set this to an initial value.

  // Define the list of gender options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Variable to hold the selected gender
  String? _selectedGender;

  // Initialize the selected gender in the initState method
  @override

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    _eventPreferencesController.dispose();
    _genderController.dispose();
//    _birthMonthController.dispose();
//    _birthDayController.dispose();
//    _birthYearController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmailPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('The passwords do not match.');
      return;
    }

    if (!_agreedToTerms) {
      _showErrorDialog('You must agree to the Terms of Service and Privacy Policy to sign up.');
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _userRole = determineUserRole(_emailController.text);
      User? user = userCredential.user;

      if (user != null) {
        String? photoURL;
        if (_userPhoto != null) {
          photoURL = await uploadProfilePicture(user.uid);
        }

        await _firestore.collection('users').doc(user.uid).set({
          'First Name': _firstNameController.text,
          'Last Name': _firstNameController.text,
          'Email': user.email,
          'Role': _userRole,
          'Phone Number': _phoneNumberController.text,
          'Department': _departmentController.text,
          'Event Preferences': _eventPreferencesController.text,
          'Gender': _selectedGender,
          'Birth Month': _selectedMonth,
          'Birth Day': _selectedDay,
          'Birth Year': _selectedYear,
          'ProfilePicture': photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'hasCompletedOnboarding': false,
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const RegistrationSuccessfulScreen()));
      }
    } on FirebaseAuthException catch (authError) {
      _showErrorDialog('Firebase Auth Error: ${authError.message}');
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: ${e.toString()}');
    }
  }
// State variables
  String? _selectedMonth;
  String? _selectedDay;
  String? _selectedYear;

// List of months
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Initialize the dropdown selections
  @override
/*  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year.toString();
    _selectedMonth = _months[now.month - 1]; // Months are 0-indexed, so subtract 1
    _selectedDay = now.day.toString();
  }
  void initState() {
    super.initState();
    // Set default gender here if you like, for example:
    _selectedGender = _genderOptions.first;
    // ... other initState code
  }*/
  void initState() {
    super.initState();
    _selectedGender = _genderOptions.first; // Set default gender
    final now = DateTime.now();
    _selectedYear = now.year.toString();
    _selectedMonth = _months[now.month - 1];
    _selectedDay = now.day.toString();
  }

// Function to determine if the year is a leap year
  bool _isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

// Function to get the list of days based on the selected month and year
  List<String> _getDaysInMonth(String? selectedMonth, String? selectedYear) {
    Map<String, int> monthDays = {
      'January': 31, 'February': _isLeapYear(int.parse(selectedYear ?? DateTime.now().year.toString())) ? 29 : 28,
      'March': 31, 'April': 30, 'May': 31, 'June': 30,
      'July': 31, 'August': 31, 'September': 30,
      'October': 31, 'November': 30, 'December': 31,
    };

    int numOfDays = monthDays[selectedMonth] ?? 31;
    return List<String>.generate(numOfDays, (index) => (index + 1).toString());
  }

// Function to get the list of years from 1900 to the current year
  List<String> _getYearsList() {
    int currentYear = DateTime.now().year;
    return List<String>.generate(currentYear - 1899, (index) => (1900 + index).toString());
  }

  // Update the state when a new month or year is selected
  void _onMonthChanged(String? newMonth) {
    setState(() {
      _selectedMonth = newMonth;
      _selectedDay = '1'; // Reset to the first day of the new month
    });
  }

  void _onYearChanged(String? newYear) {
    setState(() {
      _selectedYear = newYear;
      // Optionally, you could also reset the day here if the previous selection was February 29th
    });
  }

  // ... [Other methods like determineUserRole, uploadProfilePicture, takePhoto, pickImageFromGallery, _showErrorDialog]

  String determineUserRole(String email) {
    if (email.contains("@students.wua.ac.zw")) {
      return 'Student/Alumni';
    } else if (email.contains("@sysadmin.wua.ac.zw")) {
      return 'System Administrator';
    } else if (email.contains("@wua.ac.zw")) {
      return 'Faculty Member';
    } else {
      return 'Guest';
    }
  }

  // ... [UploadProfilePicture, takePhoto, pickFile methods]

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<String?> uploadProfilePicture(String userId) async {
    return null;

    // Implement the method to upload the profile picture to Firebase Storage
    // Return the URL of the uploaded image
  }

  Future<void> pickFile() async {
    // Implement the method to pick a file using FilePicker
    // Handle the picked file as needed
  }

  Future<void> takePhoto() async {
    // Implement the method to take a photo using ImagePicker
    // Handle the taken photo as needed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showPhotoOptions(),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _userPhoto != null ? FileImage(File(_userPhoto!.path)) : null,
                child: _userPhoto == null ? const Icon(Icons.add_a_photo, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Provides spacing between the text fields
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Create your password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Correct parameter for text obscuring
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm your password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Correct parameter for text obscuring
            ),
            const SizedBox(height: 10),
//TextField(
//  controller: _phoneNumberController,
//  decoration: InputDecoration(
//    labelText: 'Phone Number',
//    border: OutlineInputBorder(),
//  ),
//),

            Row(
              children: <Widget>[
                CountryCodePicker(
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'ZW', // Set the initial selection
                  favorite: const ['+263','ZW'], // List of country codes you want to show at the top of the list
                  // Assign a function to execute when selection changes.
                  onChanged: (CountryCode countryCode) {
                    // Update the state to the selected country code
                    setState(() {
                      _countryCode = countryCode.dialCode!;
                    });
                  },
                  // Showing flag, name and dial code in the picker.
                  showFlag: true,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone, // Show phone keyboard
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Add DropdownButtonFormField for gender selection
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: _genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (newValue) {
                // Update the state to the selected gender
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
            const SizedBox(height: 10),

            Row(
              children: <Widget>[
                Expanded(
                  flex: 2, // This gives the month dropdown more space
                  child: DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    items: _months.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // Update the selected month and reset the selected day
                      setState(() {
                        _selectedMonth = newValue;
                        _selectedDay = null; // Reset the day
                        // Update the days list based on the new month if necessary
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8), // Provides spacing between the dropdowns
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDay,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      border: OutlineInputBorder(),
                    ),
                    items: _getDaysInMonth(_selectedMonth, _selectedYear).map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDay = newValue;
                      });
                    },
                  ),
                ),


                const SizedBox(width: 8), // Provides spacing between the dropdowns
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    items: _getYearsList().map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedYear = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _departmentController,
              decoration: const InputDecoration(
                labelText: 'Department or Major',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _eventPreferencesController,
              decoration: const InputDecoration(
                labelText: 'Event Notification Preferences',
                border: OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              title: GestureDetector(
                onTap: () {
                  // TODO: Navigate to Terms of Service and Privacy Policy page/document
                },
                child: const Text(
                  'I agree to the Terms of Service and Privacy Policy',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              value: _agreedToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreedToTerms = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            ElevatedButton(
              onPressed: signUpWithEmailPassword, // Fixed here to call the sign-up method
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      pickFile();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      takePhoto();
                      Navigator.of(context). pop();
                    }),
              ],
            ),
          );
        });
  }
}
