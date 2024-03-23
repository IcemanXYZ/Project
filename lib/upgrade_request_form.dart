import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'upgrade_request.dart';
import 'upgrade_request_service.dart';
import 'record_successful_update_Screen.dart';
import 'user_service.dart';


class UpgradeRequestForm extends StatefulWidget {
  final String userRole; // Add this line

  const UpgradeRequestForm({super.key, required this.userRole}); // Modify this line

  @override
  _UpgradeRequestFormState createState() => _UpgradeRequestFormState();
}

class _UpgradeRequestFormState extends State<UpgradeRequestForm> {
  int _currentPage = 1;
  final _formKey = GlobalKey<FormState>();
  // ... other variables ...
  final UpgradeRequestService _upgradeRequestService = UpgradeRequestService();
  final UserService _userService = UserService(); // Instance of UserService

  // This will hold the initial current role passed from the previous page.
  late String _currentRole;
  String _desiredRole = '';
  // ... other variables ...
  String _reasonForUpgrade = '';
  final Map<String, dynamic> _additionalInfo = {};

  // Page 3 field
  bool _agreedToTerms = false;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future<void> uploadFile(PlatformFile file) async {
    final path = 'files/${file.name}';
    final fileBytes = file.bytes;
    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putData(fileBytes!);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    setState(() {
      uploadTask = null; // Reset the upload task after completion
    });
  }

  Widget buildProgressIndicator() {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return LinearProgressIndicator(value: progress);
        } else {
          return Container(); // Return an empty container when there's no upload
        }
      },
    );
  }


  @override
  void initState() {
    super.initState();
    // Set the _currentRole with the role passed from the navigation
    _currentRole = widget.userRole;
    // Initialize the desiredRole based on the current role.
    _desiredRole = getInitialDesiredRole(_currentRole);
  }
  // ... other methods ...
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _page1(),
      _page2(),
      _page3(),
    ];

    int totalNumberOfPages = pages.length;
    String pageHeader;
    double percentageComplete = (_currentPage / totalNumberOfPages) * 100;

    switch (_currentPage) {
      case 1:
        pageHeader = "Basic Information";
        break;
      case 2:
        pageHeader = "Role Specific Information";
        break;
      case 3:
        pageHeader = "Terms and Documentation";
        break;
      default:
        pageHeader = "Page $_currentPage";
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column
          crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally
          children: <Widget>[
            const Text(
              'Upgrade Request Form',
              textAlign: TextAlign.center, // Center the text
            ),
            Text(
              pageHeader,
              textAlign: TextAlign.center, // Center the text
            ),
          ],
        ),
        centerTitle: true, // Center the column widget itself within the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: percentageComplete / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Page $_currentPage of $totalNumberOfPages'),
                  Text('${percentageComplete.toStringAsFixed(0)}% Complete'),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: pages[_currentPage - 1], // Render the current page
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputBorder _createBorder(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: _createBorder(Colors.blue, 1.0),
      enabledBorder: _createBorder(Colors.blue, 1.0),
      focusedBorder: _createBorder(Colors.blue, 2.0),
      errorBorder: _createBorder(Colors.red, 1.0),
      focusedErrorBorder: _createBorder(Colors.red, 2.0),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  void _submitForm() async {
    print('Submitting with currentRole: $_currentRole');
    print('Submitting with desiredRole: $_desiredRole');

    if (!_formKey.currentState!.validate() || !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields and agree to the terms.')),
      );
      return;
    }
    _formKey.currentState!.save();
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? '';

    // Fetch the current user's role
    String userRole = await _userService.getUserRole(uid); // Use the UserService instance to fetch the role

    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Fetch user details including first name and last name dynamically
      Map<String, dynamic>? userDetails = await _upgradeRequestService.fetchUserDetailsWithNames(uid);

      if (userDetails != null) {
        String firstName = userDetails['First Name'] ?? ''; // Get the first name or use a default value
        String lastName = userDetails['Last Name'] ?? ''; // Get the last name or use a default value

        // Create an UpgradeRequest with the fetched first name and last name
        UpgradeRequest request = UpgradeRequest(
          userId: uid,
          currentRole: _currentRole,
          desiredRole: _desiredRole,
          reasonForUpgrade: _reasonForUpgrade,
          createdAt: DateTime.now(),
          additionalInfo: _additionalInfo,
          firstName: firstName,
          lastName: lastName,
        );

        // Create the upgrade request
        await _upgradeRequestService.createUpgradeRequest(request);

        // Determine the message and routing based on the role
        String message;
        String backRoute;
        String ctaButtonText;

        // Define a generic part of the message that will be the same for every role
        String genericMessagePart = 'Your application to upgrade your profile to ';

        // Use the desired role for the switch statement
        switch (userRole) {
          case 'Vendor':
            backRoute = '/vendorHomePage'; // Adjust as needed for your application's routing
            break;
          case 'Venue Manager':
            backRoute = '/venueHomepage'; // Adjust as needed
            break;
          case 'Events Manager':
            backRoute = '/eventHomePage'; // Adjust as needed
            break;
          case 'Faculty Administrator':
            backRoute = '/adminHomePage'; // Adjust as needed
            break;
          case 'Systems Admin':
            backRoute = '/sysadminHomePage'; // Adjust as needed
            break;
          case 'Guest':
            backRoute = '/guestHomePage'; // Adjust as needed
            break;
          default:
            backRoute = '/studentHomePage'; // Default or fallback route
            break;
        }

        // Construct the message with the dynamic role part
        ctaButtonText = 'Back to $userRole Dashboard';
        message = '$genericMessagePart$_desiredRole has been submitted successfully and is pending review.';

        // Navigate to the success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecordSuccessfulUpdateScreen(
              message: message,
              backRoute: backRoute,
              ctaButtonText: ctaButtonText,
            ),
          ),
        );
      } else {
        // Handle the case when user details are not available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching user details')),
        );
      }
    } catch (e) {
      // Show error message if an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting upgrade request: $e')),
      );
    }
  }

  // Now when building your widget tree, you can use _currentRole to determine the options.
  Widget _page1() {
    List<String> desiredRoleOptions = getDesiredRoleOptions(_currentRole);
    // ... rest of your widget build method ...
    if (_currentRole == "Faculty Member") {
      desiredRoleOptions = ["Faculty Administrator", "Venue Manager", "Events Manager", "System Admin"];
    } else if (_currentRole == "Student/Alumni") {
      desiredRoleOptions = ["Events Manager", "Venue Manager", "Vendor"];
    } else {
      // For any other roles or if currentRole hasn't been set, you may choose to have default values or keep it empty
      // If no default options should be available for other roles, simply leave the array empty or adjust as needed.
      desiredRoleOptions = []; // This ensures no options are mistakenly added for roles not explicitly handled above.
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // If there's a form field or mechanism to set/change _currentRole, ensure it's present and correctly updates state
        DropdownButtonFormField<String>(
          decoration: _inputDecoration('Please Select Your Desired Role'),
          value: _desiredRole.isNotEmpty ? _desiredRole : null,
          // Generate dropdown menu items based on desiredRoleOptions
          items: desiredRoleOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            // Ensure to update the state to reflect the new selection
            setState(() {
              _desiredRole = newValue!;
            });
          },
          validator: (value) => value == null || value.isEmpty ? 'Desired role is required.' : null,
          onSaved: (value) => _desiredRole = value!,
        ),
        const SizedBox(height: 20),
        // Add other form fields or widgets as needed...
        TextFormField(
          decoration: _inputDecoration('Reason for Upgrade'),
          keyboardType: TextInputType.multiline, // Set keyboard type for multiline text
          maxLines: null, // Allows the input to expand and take up as many lines as needed
          maxLength: 1000, // Sets the maximum length of input to 1000 characters
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a reason for the upgrade.';
            }
            return null;
          },
          onSaved: (value) => _reasonForUpgrade = value!,
        ),
        const SizedBox(height: 20),  // Add space between the fields

        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () => _navigateToNextPage(2),
            child: const Text('Next Page'),
          ),
        ),
      ],
    );
  }

  // Helper method to get desired role options based on current user role
  List<String> getDesiredRoleOptions(String currentRole) {
    switch (currentRole) {
      case "Faculty Member":
        return ["Faculty Administrator", "Venue Manager", "Events Manager", "System Admin"];
      case "Student/Alumni":
        return ["Events Manager", "Venue Manager", "Vendor"];
      default:
        return ["Vendor"]; // or include default roles if any
    }
  }

// Page 2: Role Specific Information
  Widget _page2() {
    // Adjust the layout based on the desired role
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_desiredRole == "Vendor") ..._vendorSpecificFields() else
          ..._otherRolesFields(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToNextPage(1),
              child: const Text('Back Page'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToNextPage(3),
              child: const Text('Next Page'),
            ),
          ],
        ),
      ],
    );
  }

// Page 3: Terms and Documentation
  Widget _page3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload Supporting Documentation"),
        ElevatedButton(
          onPressed: selectFile,
          child: const Text('Choose File'),
        ),
        if (pickedFile != null) ...[
          Text('Selected file: ${pickedFile!.name}'),
          ElevatedButton(
            onPressed: () => uploadFile(pickedFile!),
            child: const Text('Upload File'),
          ),
          const SizedBox(
            height: 10,
          ),
          // Show progress indicator while the file is being uploaded
          if (uploadTask != null) buildProgressIndicator(),
        ],

        // Implement your document upload widget here
        CheckboxListTile(
          title: const Text("I agree to the terms and conditions."),
          value: _agreedToTerms,
          onChanged: (bool? newValue) {
            setState(() {
              _agreedToTerms = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToNextPage(2),
              child: const Text('Back Page'),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit Form'),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToNextPage(int page) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _currentPage = page;
      });
    }
  }

  List<Widget> _vendorSpecificFields() {
    return [

      TextFormField(
        decoration: _inputDecoration('Current Role'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Business name is required.';
          }
          return null;
        },
        onSaved: (value) => _additionalInfo['businessName'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Business Type'),
        items: <String>['Catering', 'Deco', 'Videography']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          // Update some state if necessary
        },
        onSaved: (value) => _additionalInfo['businessType'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields
      TextFormField(
        decoration: _inputDecoration('Business Address'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Business address is required.';
          }
          return null;
        },
        onSaved: (value) => _additionalInfo['businessAddress'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      TextFormField(
        decoration: _inputDecoration('Contact Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Contact Name is required.';
          }
          return null;
        },        onSaved: (value) => _additionalInfo['contactName'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      TextFormField(
        decoration: _inputDecoration('Business Phone Number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Business phone number is required.';
          }
          return null;
        },
        onSaved: (value) => _additionalInfo['businessPhoneNumber'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      TextFormField(
        decoration: _inputDecoration('Company Registration Number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Company registration number is required.';
          }
          return null;
        },
        onSaved: (value) => _additionalInfo['companyRegistrationNumber'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      TextFormField(
        decoration: _inputDecoration('Tax Reference Number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Tax reference number is required.';
          }
          return null;
        },
        onSaved: (value) => _additionalInfo['taxReferenceNumber'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      TextFormField(
        decoration: _inputDecoration('Proposed Services'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty.';
          }
          // Add more specific validation rules here if necessary
          return null;
        },
        onSaved: (value) => _additionalInfo['proposedServices'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields
    ];
  }

  List<Widget> _otherRolesFields() {
    return [
      TextFormField(
        decoration: _inputDecoration('Proposed Services'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty.';
          }
          // Add more specific validation rules here if necessary
          return null;
        },
        onSaved: (value) => _additionalInfo['proposedServices'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields

      TextFormField(
        decoration: _inputDecoration('Business Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Business name is required.';
          }
          return null;
        },
        onSaved: (value) => _additionalInfo['businessName'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields
      DropdownButtonFormField<String>(
        decoration: _inputDecoration('Business Type'),
        items: <String>['Catering', 'Venue Decorations', 'Videography']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          // Update some state if necessary
        },
        onSaved: (value) => _additionalInfo['businessType'] = value,
      ),
      const SizedBox(height: 20),  // Add space between the fields
      // Add more TextFormField widgets for additional fields as necessary
    ];
  }

  // Use the current role to determine the initial desired role
  String getInitialDesiredRole(String currentRole) {
    // Implement your logic to return the initial desired role based on the current role
    // For example, you might want to return the next logical role in your role hierarchy
    // This is a placeholder logic
    switch (currentRole) {
      case "Student/Alumni":
        return "Faculty Member"; // Example next role
    // ... handle other roles ...
      default:
        return ""; // or some default role if applicable
    }
  }

// ... rest of the class ...
}