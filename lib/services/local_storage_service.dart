import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';

/// Persists favorites, registered events, theme mode, and language to device.
class LocalStorageService {
  static const _keyFavorites = 'favorites';
  static const _keyRegistered = 'registered';
  static const _keyTheme = 'theme_mode';
  static const _keyLanguage = 'language';

  // ── Favorites ──────────────────────────────────────────────────────────────

  static Future<List<Event>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyFavorites) ?? [];
    return raw
        .map((s) => Event.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveFavorites(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _keyFavorites, events.map((e) => jsonEncode(e.toJson())).toList());
  }

  // ── Registered events ──────────────────────────────────────────────────────

  static Future<List<Event>> loadRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyRegistered) ?? [];
    return raw
        .map((s) => Event.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveRegistered(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _keyRegistered, events.map((e) => jsonEncode(e.toJson())).toList());
  }

  // ── Theme ──────────────────────────────────────────────────────────────────

  static Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme) ?? 'light';
  }

  static Future<void> saveTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode);
  }

  // ── Language ───────────────────────────────────────────────────────────────

  static Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, lang);
  }
}
