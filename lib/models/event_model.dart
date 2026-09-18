import 'dart:convert';

/// A campus event: a tech talk, seminar, workshop, debate, competition,
/// sports fixture, club activity, and so on.
///
/// The same shape is used everywhere in the app, whether the event comes from
/// the bundled `assets/events.json` file or (later) a backend such as Firebase.
class Event {
  final String id;
  final String name;
  final String description;
  final String date; // ISO date, e.g. "2026-10-15"
  final String time; // 24h time, e.g. "14:00"
  final String location; // building / room, e.g. "Auditorium A, IT Building"
  final String organizer; // hosting club / department / faculty
  final String imageUrl; // optional; empty means "use the category banner"
  final String category; // one of the campus categories
  final String? registrationUrl; // optional external sign-up link

  const Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.category,
    this.imageUrl = '',
    this.registrationUrl,
  });

  /// Build an Event from a JSON object (the bundled asset uses this exact
  /// shape, so the same parser works for stored data too).
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Untitled Event',
        description: json['description'] as String? ?? '',
        date: json['date'] as String? ?? '',
        time: json['time'] as String? ?? '',
        location: json['location'] as String? ?? 'TBA',
        organizer: json['organizer'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        category: json['category'] as String? ?? 'Event',
        registrationUrl: json['registrationUrl'] as String?,
      );

  /// Convert to a plain map for JSON storage (favorites / registrations).
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'organizer': organizer,
        'imageUrl': imageUrl,
        'category': category,
        'registrationUrl': registrationUrl,
      };

  /// Human-readable date: "Oct 15, 2026".
  String get formattedDate {
    if (date.isEmpty) return 'TBA';
    try {
      final parts = date.split('-');
      final dt = DateTime(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return date;
    }
  }

  /// Human-readable time: "2:00 PM".
  String get formattedTime {
    if (time.isEmpty) return 'TBA';
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '$hour:$minute $period';
    } catch (_) {
      return time;
    }
  }

  String encode() => jsonEncode(toJson());

  static Event decode(String source) =>
      Event.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
