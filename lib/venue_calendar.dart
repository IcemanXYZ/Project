class VenueCalendar {
  final String venueId; // Unique identifier for the venue
  final Map<DateTime, List<TimeSlot>> calendar;

  VenueCalendar(this.venueId) : calendar = {};

  // Add an available time slot to the calendar
  void addAvailableTimeSlot(DateTime date, TimeSlot timeSlot) {
    calendar.putIfAbsent(date, () => []).add(timeSlot);
  }

  // Check if a time slot is available for a specific date
  bool isTimeSlotAvailable(DateTime date, TimeSlot timeSlot) {
    final timeSlots = calendar[date];
    if (timeSlots != null) {
      return !timeSlots.contains(timeSlot);
    }
    return true;
  }

  // Book a time slot for a specific date
  void bookTimeSlot(DateTime date, TimeSlot timeSlot) {
    if (isTimeSlotAvailable(date, timeSlot)) {
      throw Exception('Time slot is not available');
    }
    calendar[date]!.add(timeSlot);
  }

  // Get all available time slots for a specific date
  List<TimeSlot>? getAvailableTimeSlots(DateTime date) {
    return calendar[date];
  }

  // Initialize the calendar with available time slots for a date range
  void initializeCalendar(DateTime startDate, DateTime endDate, TimeSlot timeSlot) {
    for (var date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      addAvailableTimeSlot(date, timeSlot);
    }
  }

  // Clear all time slots for a specific date
  void clearTimeSlots(DateTime date) {
    calendar.remove(date);
  }
}

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot(this.startTime, this.endTime);
}

