class EventSchedule {
  String sessionName;
  DateTime startTime;
  DateTime endTime;
  String sessionDescription;
  String location;
  String speaker;
  String sessionType;
  String audienceTarget;
  List<String> materialsResources;
  List<String> agenda;

  EventSchedule({
    required this.sessionName,
    required this.startTime,
    required this.endTime,
    required this.sessionDescription,
    required this.location,
    required this.speaker,
    required this.sessionType,
    required this.audienceTarget,
    required this.materialsResources,
    required this.agenda,
  }) {
    // Validate that start and end times are within start and end dates
    if (startTime.isAfter(endTime) || startTime.isBefore(DateTime.now()) ||
        endTime.isBefore(DateTime.now())) {
      throw ArgumentError("Invalid start and end times for the event schedule.");
    }
  }
}
