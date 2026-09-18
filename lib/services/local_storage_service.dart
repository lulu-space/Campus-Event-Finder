import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';
import 'event_database.dart';

/// Settings stay in SharedPreferences. Favorites and registrations use SQLite
/// on mobile/desktop. Web has no SQLite plugin, so those lists use prefs there.
class LocalStorageService {
  static const _keyFavorites = 'favorites';
  static const _keyRegistered = 'registered';
  static const _keyTheme = 'theme_mode';
  static const _keyLanguage = 'language';

  static Future<void> migrateLegacyListsIfNeeded() async {
    if (kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await _migrateList(
      prefs,
      key: _keyFavorites,
      existing: () => EventDatabase.instance.loadFavorites(),
      save: EventDatabase.instance.saveFavorites,
    );
    await _migrateList(
      prefs,
      key: _keyRegistered,
      existing: () => EventDatabase.instance.loadRegistered(),
      save: EventDatabase.instance.saveRegistered,
    );
  }

  static Future<void> _migrateList(
    SharedPreferences prefs, {
    required String key,
    required Future<List<Event>> Function() existing,
    required Future<void> Function(List<Event>) save,
  }) async {
    final raw = prefs.getStringList(key) ?? [];
    if (raw.isEmpty) return;
    if ((await existing()).isNotEmpty) {
      await prefs.remove(key);
      return;
    }
    final events = raw
        .map((s) => Event.fromStoredJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    await save(events);
    await prefs.remove(key);
  }

  static Future<List<Event>> loadFavorites() {
    if (kIsWeb) return _loadListFromPrefs(_keyFavorites);
    return EventDatabase.instance.loadFavorites();
  }

  static Future<void> saveFavorites(List<Event> events) {
    if (kIsWeb) return _saveListToPrefs(_keyFavorites, events);
    return EventDatabase.instance.saveFavorites(events);
  }

  static Future<List<Event>> loadRegistered() {
    if (kIsWeb) return _loadListFromPrefs(_keyRegistered);
    return EventDatabase.instance.loadRegistered();
  }

  static Future<void> saveRegistered(List<Event> events) {
    if (kIsWeb) return _saveListToPrefs(_keyRegistered, events);
    return EventDatabase.instance.saveRegistered(events);
  }

  static Future<List<Event>> _loadListFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(key) ?? [];
    return raw
        .map((s) => Event.fromStoredJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _saveListToPrefs(String key, List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      events.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme) ?? 'light';
  }

  static Future<void> saveTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode);
  }

  static Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, lang);
  }
}
