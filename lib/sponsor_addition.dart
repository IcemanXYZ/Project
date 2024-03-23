import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'sponsor.dart';
import 'sponsor_service.dart';
import 'record_successful_update_screen.dart';

class SponsorAddition extends StatefulWidget {
  final Sponsor? sponsor; // Sponsor to edit or view, null when adding a new sponsor
  final String mode; // 'view', 'edit', or 'add'

  const SponsorAddition({super.key, this.sponsor, required this.mode});

  @override
  State<SponsorAddition> createState() => _SponsorAdditionState();
}

class _SponsorAdditionState extends State<SponsorAddition> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final SponsorService _sponsorService = SponsorService();

  // Define TextEditingControllers for each field
  final TextEditingController _entityNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  //final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _logoUrlController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _sponsorshipAmountController = TextEditingController();
  final TextEditingController _contributionTypeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Define a variable for salutation dropdown
  String? _selectedSalutation;

  @override
  void initState() {
    super.initState();
    if (widget.sponsor != null) {
      // Initialize controllers with existing sponsor data
      _entityNameController.text = widget.sponsor!.entityName ?? '';
      _firstNameController.text = widget.sponsor!.firstName ?? '';
      //  _middleNameController.text = widget.sponsor!.middleName ?? '';
      _lastNameController.text = widget.sponsor!.lastName ?? '';
      _logoUrlController.text = widget.sponsor!.logoUrl;
      _websiteController.text = widget.sponsor!.website;
      _contactInfoController.text = widget.sponsor!.contactInfo;
      _categoryController.text = widget.sponsor!.category;
      _sponsorshipAmountController.text =
          widget.sponsor!.sponsorshipAmount.toString();
      _contributionTypeController.text = widget.sponsor!.contributionType;
      _notesController.text = widget.sponsor!.notes ?? '';
      _selectedSalutation = widget.sponsor!.salutation;
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _entityNameController.dispose();
    _firstNameController.dispose();
    // _middleNameController.dispose();
    _lastNameController.dispose();
    _logoUrlController.dispose();
    _websiteController.dispose();
    _contactInfoController.dispose();
    _categoryController.dispose();
    _sponsorshipAmountController.dispose();
    _contributionTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == 'add' ? 'Add Sponsor' : widget.mode == 'edit'
            ? 'Edit Sponsor'
            : 'View Sponsor'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildForm(),
    );
  }

  Widget buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _selectedSalutation,
            hint: const Text('--None--'),
            onChanged: (value) {
              setState(() {
                _selectedSalutation = value;
              });
            },
            items: ['Mr', 'Ms', 'Mrs', 'Dr']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
                .toList(),
          ),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
/*          TextFormField(
            controller: _middleNameController,
            decoration: const InputDecoration(labelText: 'Middle Name'),
          ),*/
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last Name is required.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _entityNameController,
            decoration: const InputDecoration(labelText: 'Entity Name'),
          ),
          TextFormField(
            controller: _logoUrlController,
            decoration: const InputDecoration(labelText: 'Logo URL'),
          ),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(labelText: 'Website'),
          ),
          TextFormField(
            controller: _contactInfoController,
            decoration: const InputDecoration(labelText: 'Contact Info'),
          ),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          TextFormField(
            controller: _sponsorshipAmountController,
            decoration: const InputDecoration(labelText: 'Sponsorship Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Sponsorship Amount is required.';
              }
              if (double.tryParse(value) == null) {
                return 'Invalid Sponsorship Amount format';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _contributionTypeController,
            decoration: const InputDecoration(labelText: 'Contribution Type'),
          ),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: null, // Allow multiple lines for notes
          ),
          if (widget.mode != 'view')
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                  widget.mode == 'add' ? 'Create Sponsor' : 'Update Sponsor'),
            ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final double parsedSponsorshipAmount = double.tryParse(_sponsorshipAmountController.text) ?? 0.0;

      // Initialize successMessage with a default value
      String successMessage = 'Operation Completed'; // Default message

      final newSponsor = Sponsor(
        id: widget.sponsor?.id ?? FirebaseFirestore.instance
            .collection('sponsors')
            .doc()
            .id,
        // Generate new ID if adding
        personEntity: 'Person',
        salutation: _selectedSalutation,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        entityName: _entityNameController.text,
        logoUrl: _logoUrlController.text,
        website: _websiteController.text,
        contactInfo: _contactInfoController.text,
        category: _categoryController.text,
        sponsorshipAmount: parsedSponsorshipAmount,
        contributionType: _contributionTypeController.text,
        eventParticipation: [],
        agreementDate: DateTime.now(),
        notes: _notesController.text,
        status: 'Active',
      );

      try {
        if (widget.mode == 'add') {
          await _sponsorService.addSponsor(newSponsor);
          successMessage = 'Sponsor Added Successfully';
        } else if (widget.mode == 'edit') {
          await _sponsorService.editSponsor(widget.sponsor!.id, newSponsor.toMap());
          successMessage = 'Sponsor Updated Successfully';
        } else if (widget.mode == 'delete') { // Assuming you have a 'delete' mode
          await _sponsorService.deleteSponsor(widget.sponsor!.id);
          successMessage = 'Sponsor Deleted Successfully';
        }
        _navigateToSuccessScreen(successMessage, context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to process sponsor data. Please try again. Error: $e'),
        ));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToSuccessScreen(String successMessage, BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecordSuccessfulUpdateScreen(
              message: successMessage,
              backRoute: '/sponsorManagement', // Ensure this is your correct route for managing sponsors
              ctaButtonText: 'Back to Sponsor Management', // Custom CTA button text
            ),
      ),
    );
  }
}