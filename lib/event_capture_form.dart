import 'package:flutter/material.dart';
import 'event_service.dart'; // Import the EventService class
import 'event.dart';
import 'record_successful_update_Screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create a new Event Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EventCaptureForm(),
    );
  }
}

class EventCaptureForm extends StatefulWidget {
  const EventCaptureForm({super.key});

  @override
  _EventCaptureFormState createState() => _EventCaptureFormState();
}

class _EventCaptureFormState extends State<EventCaptureForm> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  String selectedLocation = 'Location A';
  String selectedEventType = 'Type 1';
  String eventOrganiserName = '';
  String eventOrganiserEmail = '';
  int numberOfAttendees = 0;
  String eventName = '';

  List<EventSchedule>? eventSchedule;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event Form'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildMandatoryField(
                labelText: 'Event Name*',
                hintText: 'Enter Event Name',
                controller: TextEditingController(text: eventName),
                onSaved: (value) {
                  eventName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildDateTimeField(
                labelText: 'Start Date Time*',
                selectedDate: startDate,
                selectedTime: startTime,
                hintText: 'Select Start Date Time',
                onChangedDate: (date) {
                  setState(() {
                    startDate = date!;
                  });
                },
                onChangedTime: (time) {
                  setState(() {
                    startTime = time!;
                  });
                },
                validator: (date, time) {
                  if (date == null || time == null) {
                    return 'Start Date Time is required';
                  }
                  final selectedDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                  if (selectedDateTime.isBefore(DateTime.now())) {
                    return 'Start Date Time cannot be in the past';
                  }
                  if (selectedDateTime.isAfter(endDate)) {
                    return 'Start Date Time cannot be after End Date Time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildDateTimeField(
                labelText: 'End Date Time*',
                selectedDate: endDate,
                selectedTime: endTime,
                hintText: 'Select End Date Time',
                onChangedDate: (date) {
                  setState(() {
                    endDate = date!;
                  });
                },
                onChangedTime: (time) {
                  setState(() {
                    endTime = time!;
                  });
                },
                validator: (date, time) {
                  if (date == null || time == null) {
                    return 'End Date Time is required';
                  }
                  final selectedDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                  if (selectedDateTime.isBefore(startDate)) {
                    return 'End Date Time cannot be before Start Date Time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildMandatoryField(
                labelText: 'Event Organiser Name',
                hintText: 'Enter Event Organiser Name (optional)',
                controller: TextEditingController(text: eventOrganiserName),
                onSaved: (value) {
                  eventOrganiserName = value ?? '';
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!isAlphabetic(value)) {
                      return 'Event Organiser Name should only contain alphabetic characters';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildMandatoryField(
                labelText: 'Event Organiser Email',
                hintText: 'Enter Event Organiser Email (optional)',
                controller: TextEditingController(text: eventOrganiserEmail),
                onSaved: (value) {
                  eventOrganiserEmail = value ?? '';
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!isValidEmail(value)) {
                      return 'Invalid Email Format';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildMandatoryDropdownField(
                labelText: 'Select Location*',
                hintText: 'Select Location',
                value: selectedLocation,
                items: ['Location A', 'Location B', 'Location C'],
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildMandatoryDropdownField(
                labelText: 'Select Event Type*',
                hintText: 'Select Event Type',
                value: selectedEventType,
                items: ['Type 1', 'Type 2', 'Type 3'],
                onChanged: (value) {
                  setState(() {
                    selectedEventType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event Type is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              _buildMandatoryField(
                labelText: 'Number of Attendees*',
                hintText: 'Enter Number of Attendees',
                controller: TextEditingController(text: numberOfAttendees.toString()),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  numberOfAttendees = int.tryParse(value ?? '') ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number of Attendees is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final startDateTime = DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      startTime.hour,
                      startTime.minute,
                    );
                    final endDateTime = DateTime(
                      endDate.year,
                      endDate.month,
                      endDate.day,
                      endTime.hour,
                      endTime.minute,
                    );
                    final BuildContext context = this.context; // Capture the context

                    try {
                      // Create an Event instance from the form data with status 'Pending'
                      Event newEvent = Event(
                        eventName: eventName,
                        startDate: startDate,
                        endDate: endDate,
                        eventOrganiserName: eventOrganiserName,
                        eventOrganiserEmail: eventOrganiserEmail,
                        selectedLocation: selectedLocation,
                        selectedEventType: selectedEventType,
                        numberOfAttendees: numberOfAttendees,
                        status: 'Pending', // Set the status here
                        eventSchedule: [], // Initialize with an empty list or provide appropriate data
                      );
                      // Create an instance of the EventService class
                      final eventService = EventService();

                      // Use the EventService to create the event in Firestore
                      await eventService.createEvent(newEvent);

                      // Navigate to the success screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordSuccessfulUpdateScreen(
                            message: "Event Created Successfully",
                           backRoute: "/eventCaptureForm", // Provide the actual back route
                            ctaButtonText: 'Back to Event Capture Form', // Custom CTA button text
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Error updating record: $e');
                      // Handle the error, e.g., show an error message to the user
                    }
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isAlphabetic(String input) {
    final alphabeticPattern = RegExp(r'^[a-zA-Z ]+$');
    return alphabeticPattern.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final emailPattern =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailPattern.hasMatch(input);
  }

  Widget _buildMandatoryField({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
    ValueChanged<String?>? onSaved,
    ValueChanged<String?>? onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    GestureTapCallback? onTap,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      controller: controller,
      keyboardType: keyboardType,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
    );
  }

  Widget _buildMandatoryDropdownField({
    required String labelText,
    required String hintText,
    required String value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(location),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimeField({
    required String labelText,
    required String hintText,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    ValueChanged<DateTime?>? onChangedDate,
    ValueChanged<TimeOfDay?>? onChangedTime,
    String? Function(DateTime?, TimeOfDay?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  DateTime? selectedDateNew = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: selectedDate.add(const Duration(days: 365)),
                  );
                  if (selectedDateNew != null) {
                    onChangedDate?.call(selectedDateNew);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: const OutlineInputBorder(),
                    errorText: validator?.call(selectedDate, selectedTime),
                  ),
                  child: Text(
                    selectedDate.toLocal().toString().split(' ')[0],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: InkWell(
                onTap: () async {
                  TimeOfDay? selectedTimeNew = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (selectedTimeNew != null) {
                    onChangedTime?.call(selectedTimeNew);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Select Time',
                    border: const OutlineInputBorder(),
                    errorText: validator?.call(selectedDate, selectedTime),
                  ),
                  child: Text(
                    selectedTime.format(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
