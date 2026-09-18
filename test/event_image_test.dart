import 'package:flutter_test/flutter_test.dart';

import 'package:campus_event_finder/models/event_model.dart';

void main() {
  test('skips Ticketmaster fallback images', () {
    final url = Event.pickImageUrl([
      {
        'ratio': '16_9',
        'width': 2048,
        'fallback': true,
        'url': 'https://example.com/black.jpg',
      },
      {
        'ratio': '16_9',
        'width': 1024,
        'fallback': false,
        'url': 'https://example.com/real.jpg',
      },
    ]);
    expect(url, 'https://example.com/real.jpg');
  });

  test('returns empty when only fallback art exists', () {
    final url = Event.pickImageUrl([
      {
        'ratio': '16_9',
        'width': 2048,
        'fallback': true,
        'url': 'https://example.com/black.jpg',
      },
    ]);
    expect(url, isEmpty);
  });
}
