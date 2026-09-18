import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/event_model.dart';

/// Loads campus events from the bundled `assets/events.json` file.
///
/// This replaces the old Ticketmaster network client. The public methods keep
/// the same shape a remote API would have (`fetchEvents`, `fetchEvent`), so if
/// we later move to a backend like Firebase, only this file needs to change.
class EventService {
  static const _assetPath = 'assets/events.json';

  // Cache the parsed list so we only read/decode the asset once.
  static List<Event>? _cache;

  static Future<List<Event>> _loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(_assetPath);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = list.map(Event.fromJson).toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // soonest first
    return _cache!;
  }

  /// Return events, optionally filtered by [category] and a free-text
  /// [keyword] (matched against the name, organizer, and location).
  static Future<List<Event>> fetchEvents({
    String? keyword,
    String? category,
  }) async {
    var events = await _loadAll();

    if (category != null && category.isNotEmpty && category != 'All') {
      events = events.where((e) => e.category == category).toList();
    }

    final q = keyword?.trim().toLowerCase() ?? '';
    if (q.isNotEmpty) {
      events = events
          .where((e) =>
              e.name.toLowerCase().contains(q) ||
              e.organizer.toLowerCase().contains(q) ||
              e.location.toLowerCase().contains(q) ||
              e.category.toLowerCase().contains(q))
          .toList();
    }

    return events;
  }

  /// Fetch a single event by [id].
  static Future<Event> fetchEvent(String id) async {
    final events = await _loadAll();
    return events.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Event not found: $id'),
    );
  }
}
