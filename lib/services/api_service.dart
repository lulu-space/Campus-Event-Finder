import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/event_model.dart';
import 'api_config.dart';
import 'api_exception.dart';

class ApiService {
  // ── Helpers ────────────────────────────────────────────────────────────────

  static Map<String, dynamic> _decode(http.Response response) {
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const ApiException('Unexpected response format');
    }
    return body;
  }

  static Never _throwError(http.Response response) {
    final message = switch (response.statusCode) {
      401 => 'Invalid API key. Check api_config.dart.',
      404 => 'Resource not found.',
      429 => 'Rate limit exceeded. Try again in a moment.',
      >= 500 => 'Server error. Please try again later.',
      _ => 'Request failed (${response.statusCode}).',
    };
    throw ApiException(message, statusCode: response.statusCode);
  }

  // ── Events list ────────────────────────────────────────────────────────────

  /// Search events by [keyword], [city] and/or [countryCode], optionally
  /// filtered by [category] (e.g. "Music", "Sports", "Arts & Theatre").
  static Future<List<Event>> fetchEvents({
    String? keyword,
    String? city,
    String? countryCode,
    String? category,
    int size = 20,
  }) async {
    final params = <String, String>{
      'apikey': ApiConfig.apiKey,
      'size': size.toString(),
      'sort': 'date,asc',
    };
    if (keyword != null && keyword.trim().isNotEmpty) {
      params['keyword'] = keyword.trim();
    }
    if (countryCode != null && countryCode.trim().isNotEmpty) {
      params['countryCode'] = countryCode.trim().toUpperCase();
    }
    if (city != null && city.trim().isNotEmpty) {
      params['city'] = city.trim();
    }
    if (params['countryCode'] == null && params['city'] == null) {
      params['city'] = 'London';
    }
    if (category != null && category != 'All') {
      params['classificationName'] = category;
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/events.json')
        .replace(queryParameters: params);

    final response = await http.get(uri, headers: {'Accept': 'application/json'});

    if (response.statusCode != 200) _throwError(response);

    final body = _decode(response);
    final embedded = body['_embedded'] as Map<String, dynamic>?;
    if (embedded == null) return []; // no results

    final events = (embedded['events'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return events.map(Event.fromJson).toList();
  }

  // ── Single event ───────────────────────────────────────────────────────────

  /// Fetch full details for a single event by [id].
  static Future<Event> fetchEvent(String id) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/events/$id.json')
        .replace(queryParameters: {'apikey': ApiConfig.apiKey});

    final response = await http.get(uri, headers: {'Accept': 'application/json'});

    if (response.statusCode != 200) _throwError(response);

    return Event.fromJson(_decode(response));
  }
}
