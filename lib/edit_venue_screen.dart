import 'package:flutter/material.dart';
import 'venue.dart'; // Import your Venue model
import 'venue_service.dart'; // Import your VenueService

class EditVenueScreen extends StatefulWidget {
/*  final Venue venue;
  final VenueService venueService;

  //const EditVenueScreen({super.key, required this.venue, required this.venueService});
  const EditVenueScreen({Key? key, required this.venue}) : super(key: key);
  @override
  _EditVenueScreenState createState() => _EditVenueScreenState();*/
  final Venue venue;
  final VenueService venueService;

  const EditVenueScreen({super.key, required this.venue, required this.venueService});

  @override
  _EditVenueScreenState createState() => _EditVenueScreenState();
}

class _EditVenueScreenState extends State<EditVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _maxOccupancyController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _venueTypeController = TextEditingController();
  // Add more controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.venue.name;
    _locationController.text = widget.venue.location;
    _capacityController.text = widget.venue.capacity.toString();
    _maxOccupancyController.text = widget.venue.maxOccupancy.toString();
    _costController.text = widget.venue.cost.toString();
    _venueTypeController.text = widget.venue.venueType;
    // Initialize other controllers with existing venue data
  }

  @override

  Widget build(BuildContext context) {

      return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Venue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Venue Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Venue Location'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid capacity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxOccupancyController,
                decoration: const InputDecoration(labelText: 'Max Occupancy'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter max occupancy';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid max occupancy';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cost';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _venueTypeController,
                decoration: const InputDecoration(labelText: 'Venue Type'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a venue type';
                  }
                  return null;
                },
              ),
              // Add more TextFormField widgets for other fields
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update venue data with new values
                    final updatedVenue = Venue(
                      venueID: widget.venue.venueID,
                      name: _nameController.text,
                      location: _locationController.text,
                      capacity: int.parse(_capacityController.text),
                      maxOccupancy: int.parse(_maxOccupancyController.text),
                      cost: double.parse(_costController.text),
                      availability: widget.venue.availability,
                      venueType: _venueTypeController.text,
                      facilities: widget.venue.facilities,
                      bookingRestrictions: widget.venue.bookingRestrictions,
                      eventTypesSuitedFor: widget.venue.eventTypesSuitedFor,
                      size: widget.venue.size,
                      layoutOptions: widget.venue.layoutOptions,
                      contactInfo: widget.venue.contactInfo,
                      rating: widget.venue.rating,
                      additionalServices: widget.venue.additionalServices,
                      transportLinks: widget.venue.transportLinks,
                      nearbyAccommodations: widget.venue.nearbyAccommodations,
                      virtualTourLink: widget.venue.virtualTourLink,
                      environmentalInfo: widget.venue.environmentalInfo,
                      insuranceRequirements: widget.venue.insuranceRequirements,
                      cancellationPolicy: widget.venue.cancellationPolicy,
                      photoGallery: widget.venue.photoGallery,
                      reviews: widget.venue.reviews,
                      allRatings: widget.venue.allRatings,
                      // Include all required parameters here
                    );

                    // Call the updateVenue method from VenueService
                    widget.venueService.updateVenue(updatedVenue);

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _maxOccupancyController.dispose();
    _costController.dispose();
    _venueTypeController.dispose();
    // Dispose of other controllers as needed
    super.dispose();
  }
}
