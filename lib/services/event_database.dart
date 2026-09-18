import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/event_model.dart';

/// SQLite store for favorites and registrations (the main app data).
class EventDatabase {
  EventDatabase({this.pathOverride});

  /// Test or custom file path. Null uses the app documents database.
  final String? pathOverride;

  static final EventDatabase instance = EventDatabase();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = pathOverride ??
        p.join(await getDatabasesPath(), 'campus_event_finder.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute(_tableSql('favorites'));
        await db.execute(_tableSql('registered'));
      },
    );
  }

  static String _tableSql(String name) => '''
    CREATE TABLE $name (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      date TEXT NOT NULL,
      time TEXT NOT NULL,
      venue TEXT NOT NULL,
      city TEXT NOT NULL,
      imageUrl TEXT NOT NULL,
      category TEXT NOT NULL,
      ticketUrl TEXT NOT NULL,
      info TEXT
    )
  ''';

  Future<List<Event>> loadFavorites() => _load('favorites');

  Future<void> saveFavorites(List<Event> events) =>
      _save('favorites', events);

  Future<List<Event>> loadRegistered() => _load('registered');

  Future<void> saveRegistered(List<Event> events) =>
      _save('registered', events);

  Future<List<Event>> _load(String table) async {
    final db = await database;
    final rows = await db.query(table);
    return rows
        .map((row) => Event.fromStoredJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<void> _save(String table, List<Event> events) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(table);
      for (final event in events) {
        await txn.insert(
          table,
          event.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
