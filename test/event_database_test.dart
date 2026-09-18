import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:campus_event_finder/models/event_model.dart';
import 'package:campus_event_finder/services/event_database.dart';

void main() {
  late EventDatabase db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    db = EventDatabase(pathOverride: inMemoryDatabasePath);
  });

  tearDown(() async {
    await db.close();
  });

  Event sample(String id) => Event(
        id: id,
        name: 'Campus Night $id',
        date: '2026-10-15',
        time: '19:00:00',
        venue: 'Hall A',
        city: 'London',
        imageUrl: 'https://example.com/$id.jpg',
        category: 'Music',
        ticketUrl: 'https://example.com/tickets/$id',
        info: 'Live show',
      );

  test('saves and loads favorites from SQLite', () async {
    await db.saveFavorites([sample('1'), sample('2')]);
    final loaded = await db.loadFavorites();
    expect(loaded.map((e) => e.id), ['1', '2']);
    expect(loaded.first.name, 'Campus Night 1');
  });

  test('replaces registered events on save', () async {
    await db.saveRegistered([sample('a')]);
    await db.saveRegistered([sample('b')]);
    final loaded = await db.loadRegistered();
    expect(loaded, hasLength(1));
    expect(loaded.single.id, 'b');
  });
}
