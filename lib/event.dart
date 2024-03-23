import 'package:cloud_firestore/cloud_firestore.dart';

class EventSchedule {
  String sessionName;
  DateTime scheduleStartDateTime;
  DateTime scheduleEndDateTime;
  String sessionDescription;
  String location;
  String speaker;
  String sessionType;
  String audienceTarget;
  List<String> materialsResources;

  EventSchedule({
    required this.sessionName,
    required this.scheduleStartDateTime,
    required this.scheduleEndDateTime,
    required this.sessionDescription,
    required this.location,
    required this.speaker,
    required this.sessionType,
    required this.audienceTarget,
    required this.materialsResources,
  });
}

class Event {
  String? id; // Make id optional
  String eventName;
  DateTime startDate;
  DateTime endDate;
  String eventOrganiserName;
  String eventOrganiserEmail;
  String selectedLocation;
  String selectedEventType;
  int numberOfAttendees;
  String status; // Status field for event management

  List<EventSchedule> eventSchedule;

  Event({
    this.id, // Make id optional
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.eventOrganiserName,
    required this.eventOrganiserEmail,
    required this.selectedLocation,
    required this.selectedEventType,
    required this.numberOfAttendees,
    required this.status,
    required this.eventSchedule,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      eventName: data['eventName'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      eventOrganiserName: data['eventOrganiserName'] ?? '',
      eventOrganiserEmail: data['eventOrganiserEmail'] ?? '',
      selectedLocation: data['selectedLocation'] ?? '',
      selectedEventType: data['selectedEventType'] ?? '',
      numberOfAttendees: data['numberOfAttendees'] ?? 0,
      status: data['status'] ?? '',
      eventSchedule: (data['eventSchedule'] as List).map((scheduleData) => EventSchedule(
        sessionName: scheduleData['sessionName'] ?? '',
        scheduleStartDateTime: (scheduleData['scheduleStartDateTime'] as Timestamp).toDate(),
        scheduleEndDateTime: (scheduleData['scheduleEndDateTime'] as Timestamp).toDate(),
        sessionDescription: scheduleData['sessionDescription'] ?? '',
        location: scheduleData['location'] ?? '',
        speaker: scheduleData['speaker'] ?? '',
        sessionType: scheduleData['sessionType'] ?? '',
        audienceTarget: scheduleData['audienceTarget'] ?? '',
        materialsResources: List<String>.from(scheduleData['materialsResources'] ?? []),
      )).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'eventOrganiserName': eventOrganiserName,
      'eventOrganiserEmail': eventOrganiserEmail,
      'selectedLocation': selectedLocation,
      'selectedEventType': selectedEventType,
      'numberOfAttendees': numberOfAttendees,
      'status': status,
      'eventSchedule': eventSchedule.map((schedule) => {
        'sessionName': schedule.sessionName,
        'scheduleStartDateTime': Timestamp.fromDate(schedule.scheduleStartDateTime),
        'scheduleEndDateTime': Timestamp.fromDate(schedule.scheduleEndDateTime),
        'sessionDescription': schedule.sessionDescription,
        'location': schedule.location,
        'speaker': schedule.speaker,
        'sessionType': schedule.sessionType,
        'audienceTarget': schedule.audienceTarget,
        'materialsResources': schedule.materialsResources,
      }).toList(),
    };
  }

  void addEventSchedule(EventSchedule schedule) {
    eventSchedule ??= [];
    eventSchedule.add(schedule);
  }

  void updateEventSchedule(int index, EventSchedule updatedSchedule) {
    final length = eventSchedule.length;
    if (index >= 0 && index < length) {
      eventSchedule[index] = updatedSchedule;
    }
    }

  void deleteEventSchedule(int index) {
    final length = eventSchedule.length;
    if (index >= 0 && index < length) {
      eventSchedule.removeAt(index);
    }
    }
}
