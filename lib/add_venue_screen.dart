import 'package:flutter/material.dart';
import 'venue.dart';
import 'venue_service.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  _AddVenueScreenState createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _maxOccupancyController = TextEditingController();
  final _costController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _venueTypeController = TextEditingController();
  final _facilitiesController = TextEditingController();
  final _bookingRestrictionsController = TextEditingController();
  final _eventTypesSuitedForController = TextEditingController();
  final _sizeController = TextEditingController();
  final _layoutOptionsController = TextEditingController();
  final _contactInfoController = TextEditingController();
  final _ratingController = TextEditingController();
  final _additionalServicesController = TextEditingController();
  final _transportLinksController = TextEditingController();
  final _nearbyAccommodationsController = TextEditingController();
  final _virtualTourLinkController = TextEditingController();
  final _environmentalInfoController = TextEditingController();
  final _insuranceRequirementsController = TextEditingController();
  final _cancellationPolicyController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      int capacity = int.tryParse(_capacityController.text) ?? 0;
      int maxOccupancy = int.tryParse(_maxOccupancyController.text) ?? 0;
      double cost = double.tryParse(_costController.text) ?? 0.0;
      bool availability = _availabilityController.text.toLowerCase() == 'true';

      // Initialize these variables with placeholder values
      double rating = 0.0;
      List<String> facilities = [];
      List<String> layoutOptions = [];
      List<String> eventTypesSuitedFor = [];
      List<String> additionalServices = [];
      List<String> transportLinks = [];
      List<String> nearbyAccommodations = [];

      // Create a new Venue object with initialized variables
      Venue newVenue = Venue(
        venueID: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        location: _locationController.text,
        capacity: capacity,
        maxOccupancy: maxOccupancy,
        cost: cost,
        availability: availability,
        venueType: _venueTypeController.text,
        facilities: facilities,
        bookingRestrictions: _bookingRestrictionsController.text,
        eventTypesSuitedFor: eventTypesSuitedFor,
        size: _sizeController.text,
        layoutOptions: layoutOptions,
        contactInfo: _contactInfoController.text,
        rating: rating,
        additionalServices: additionalServices,
        transportLinks: transportLinks,
        nearbyAccommodations: nearbyAccommodations,
        virtualTourLink: _virtualTourLinkController.text,
        environmentalInfo: _environmentalInfoController.text,
        insuranceRequirements: _insuranceRequirementsController.text,
        cancellationPolicy: _cancellationPolicyController.text,
      );
      try {
        await VenueService().addVenue(newVenue);
        // Optionally, you can clear the form fields after successful submission
        _nameController.clear();
        _locationController.clear();
        _capacityController.clear();
        _maxOccupancyController.clear();
        _costController.clear();
        _availabilityController.clear();
        _venueTypeController.clear();
        _facilitiesController.clear();
        _bookingRestrictionsController.clear();
        _eventTypesSuitedForController.clear();
        _sizeController.clear();
        _layoutOptionsController.clear();
        _contactInfoController.clear();
        _ratingController.clear();
        _additionalServicesController.clear();
        _transportLinksController.clear();
        _nearbyAccommodationsController.clear();
        _virtualTourLinkController.clear();
        _environmentalInfoController.clear();
        _insuranceRequirementsController.clear();
        _cancellationPolicyController.clear();

        // Show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Document Saved Successfully'),
        ));
      } catch (e) {
        // Handle errors and show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error adding venue: $e'),
        ));
      }
    }
  }

  @override
  void dispose() {
    // Dispose of your TextEditingController instances here
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _maxOccupancyController.dispose();
    _costController.dispose();
    _availabilityController.dispose();
    _venueTypeController.dispose();
    _facilitiesController.dispose();
    _bookingRestrictionsController.dispose();
    _eventTypesSuitedForController.dispose();
    _sizeController.dispose();
    _layoutOptionsController.dispose();
    _contactInfoController.dispose();
    _ratingController.dispose();
    _additionalServicesController.dispose();
    _transportLinksController.dispose();
    _nearbyAccommodationsController.dispose();
    _virtualTourLinkController.dispose();
    _environmentalInfoController.dispose();
    _insuranceRequirementsController.dispose();
    _cancellationPolicyController.dispose();

    super.dispose();
  }

  // Add boolean variables for expansion panels
  bool _generalInfoExpanded = false;
  bool _facilitiesExpanded = false;

  // Function to toggle expansion
  void _toggleGeneralInfoExpansion() {
    setState(() {
      _generalInfoExpanded = !_generalInfoExpanded;
    });
  }

  void _toggleFacilitiesExpansion() {
    setState(() {
      _facilitiesExpanded = !_facilitiesExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Venue')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (index == 0) {
                      _generalInfoExpanded = !isExpanded;
                    } else if (index == 1) {
                      _facilitiesExpanded = !isExpanded;
                    }
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: const Text(
                          'General Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () => setState(() => _generalInfoExpanded = !_generalInfoExpanded),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the venue name';
                              }
                              return null;
                            },
                          ),
                          // Add more TextFormField widgets for general info fields...
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(labelText: 'Location'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the venue location';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _venueTypeController,
                            decoration: const InputDecoration(labelText: 'Venue Type'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the venue type';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _bookingRestrictionsController,
                            decoration: const InputDecoration(labelText: 'Booking Restrictions'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the booking restrictions';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _sizeController,
                            decoration: const InputDecoration(labelText: 'Size'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the size';
                              }
                              final int? size = int.tryParse(value);
                              if (size == null || size <= 0) {
                                return 'Please enter a valid size';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _contactInfoController,
                            decoration: const InputDecoration(labelText: 'Contact Info'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the contact info';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _ratingController,
                            decoration: const InputDecoration(labelText: 'Rating'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a rating';
                              }
                              final double? rating = double.tryParse(value);
                              if (rating == null || rating < 0 || rating > 5) {
                                return 'Please enter a valid rating between 0 and 5';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _virtualTourLinkController,
                            decoration: const InputDecoration(labelText: 'Virtual Tour Link'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the virtual tour link';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _cancellationPolicyController,
                            decoration: const InputDecoration(labelText: 'Cancellation Policy'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the cancellation policy';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _environmentalInfoController,
                            decoration: const InputDecoration(labelText: 'Environmental Info'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the environmental info';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _insuranceRequirementsController,
                            decoration: const InputDecoration(labelText: 'Insurance Requirements'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the insurance requirements';
                              }
                              return null;
                            },
                          ),

                          // Your TextFormFields for General Information...
                        ],
                      ),
                    ),
                    isExpanded: _generalInfoExpanded,
                  ),
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: const Text(
                          'Facilities',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () => setState(() => _facilitiesExpanded = !_facilitiesExpanded),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _facilitiesController,
                            decoration: const InputDecoration(labelText: 'Facilities'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the facilities';
                              }
                              return null;
                            },
                          ),
                          // Add more TextFormField widgets for facilities fields...
                          TextFormField(
                            controller: _layoutOptionsController,
                            decoration: const InputDecoration(labelText: 'Layout Options'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter layout options';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _transportLinksController,
                            decoration: const InputDecoration(labelText: 'Transport Links'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the transport links';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _nearbyAccommodationsController,
                            decoration: const InputDecoration(labelText: 'Nearby Accommodations'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter nearby accommodations';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _additionalServicesController,
                            decoration: const InputDecoration(labelText: 'Additional Services'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter additional services';
                              }
                              return null;
                            },
                          ),
                          // Add more TextFormField widgets for facilities fields...

                          // Your TextFormFields for Facilities...
                        ],
                      ),
                    ),
                    isExpanded: _facilitiesExpanded,
                  ),
                  // ... Other ExpansionPanels if any...
                ],
              ),
      ElevatedButton(
        onPressed: _submitForm,
        child: const Text('Save'),
      ),
      ],
    ),
    ),
    ),
    );
  }
}
