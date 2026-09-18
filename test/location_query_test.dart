import 'package:flutter_test/flutter_test.dart';

import 'package:campus_event_finder/services/location_query.dart';

void main() {
  test('empty location defaults to London', () {
    final query = LocationQuery.parse('  ');
    expect(query.city, 'London');
    expect(query.countryCode, isNull);
  });

  test('UK maps to country code GB', () {
    final query = LocationQuery.parse('UK');
    expect(query.city, isNull);
    expect(query.countryCode, 'GB');
  });

  test('United Kingdom maps to GB', () {
    final query = LocationQuery.parse('United Kingdom');
    expect(query.countryCode, 'GB');
    expect(query.city, isNull);
  });

  test('city names stay city searches', () {
    final query = LocationQuery.parse('Manchester');
    expect(query.city, 'Manchester');
    expect(query.countryCode, isNull);
  });

  test('London, UK sends city and country', () {
    final query = LocationQuery.parse('London, UK');
    expect(query.city, 'London');
    expect(query.countryCode, 'GB');
  });

  test('USA maps to US', () {
    expect(LocationQuery.parse('USA').countryCode, 'US');
    expect(LocationQuery.parse('united states').countryCode, 'US');
  });
}
