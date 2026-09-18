import 'dart:convert';

class Event {
  final String id;
  final String name;
  final String date; // e.g. "2026-10-15"
  final String time; // e.g. "19:00:00"
  final String venue;
  final String city;
  final String imageUrl;
  final String category;
  final String ticketUrl;
  final String? info;

  const Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.venue,
    required this.city,
    required this.imageUrl,
    required this.category,
    required this.ticketUrl,
    this.info,
  });

  /// Build an Event from a Ticketmaster Discovery API event JSON object.
  factory Event.fromJson(Map<String, dynamic> json) {
    final dates = json['dates'] as Map<String, dynamic>? ?? {};
    final start = dates['start'] as Map<String, dynamic>? ?? {};

    final embedded = json['_embedded'] as Map<String, dynamic>? ?? {};
    final venues =
        (embedded['venues'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final venueMap = venues.isNotEmpty ? venues[0] : <String, dynamic>{};

    // Prefer a real poster. Ticketmaster `fallback: true` images are generic
    // category art (often black / empty) and should not be shown as the event photo.
    final images =
        (json['images'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final imageUrl = Event.pickImageUrl(images);

    final classifications =
        (json['classifications'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final segment = classifications.isNotEmpty
        ? ((classifications[0]['segment'] as Map?)?['name'] as String? ??
            'Event')
        : 'Event';

    return Event(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Event',
      date: start['localDate'] as String? ?? '',
      time: start['localTime'] as String? ?? '',
      venue: venueMap['name'] as String? ?? 'TBA',
      city: (venueMap['city'] as Map?)?['name'] as String? ?? '',
      imageUrl: imageUrl,
      category: segment,
      ticketUrl: json['url'] as String? ?? '',
      info: json['info'] as String?,
    );
  }

  /// For persisting to SharedPreferences.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date,
        'time': time,
        'venue': venue,
        'city': city,
        'imageUrl': imageUrl,
        'category': category,
        'ticketUrl': ticketUrl,
        'info': info,
      };

  /// Restore from a SharedPreferences-stored map.
  factory Event.fromStoredJson(Map<String, dynamic> json) => Event(
        id: json['id'] as String,
        name: json['name'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        venue: json['venue'] as String,
        city: json['city'] as String,
        imageUrl: json['imageUrl'] as String,
        category: json['category'] as String,
        ticketUrl: json['ticketUrl'] as String,
        info: json['info'] as String?,
      );

  /// Human-readable date: "Oct 15, 2026"
  String get formattedDate {
    if (date.isEmpty) return 'TBA';
    try {
      final parts = date.split('-');
      final dt = DateTime(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return date;
    }
  }

  /// Human-readable time: "7:00 PM"
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

  /// Real Ticketmaster artwork only. Generic `fallback` images are skipped.
  static String pickImageUrl(List<Map<String, dynamic>> images) {
    bool isReal(Map<String, dynamic> image) {
      final url = image['url'] as String? ?? '';
      return url.isNotEmpty && image['fallback'] != true;
    }

    var pool = images.where(isReal).toList();
    if (pool.isEmpty) return '';

    final wide = pool.where((image) => image['ratio'] == '16_9').toList();
    if (wide.isNotEmpty) pool = wide;

    pool.sort((a, b) {
      int widthOf(Map<String, dynamic> image) {
        final width = image['width'];
        if (width is int) return width;
        if (width is num) return width.toInt();
        return 0;
      }

      return widthOf(b).compareTo(widthOf(a));
    });
    return pool.first['url'] as String? ?? '';
  }

  String encode() => jsonEncode(toJson());

  static Event decode(String source) =>
      Event.fromStoredJson(jsonDecode(source) as Map<String, dynamic>);
}
