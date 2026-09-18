import 'package:flutter/material.dart';

/// Visual identity (color + icon) for each campus event category.
///
/// Used to color-code cards, banners, and category chips so events are easy to
/// scan at a glance without relying on photos.
class CategoryStyle {
  final Color color;
  final IconData icon;

  const CategoryStyle(this.color, this.icon);

  static const Map<String, CategoryStyle> _map = {
    'Tech Talk': CategoryStyle(Color(0xFF6C5CE7), Icons.memory),
    'Seminar': CategoryStyle(Color(0xFF0984E3), Icons.school),
    'Workshop': CategoryStyle(Color(0xFF00B894), Icons.handyman),
    'Debate': CategoryStyle(Color(0xFFE17055), Icons.record_voice_over),
    'Science Fair': CategoryStyle(Color(0xFF00A8A8), Icons.science),
    'Club Activity': CategoryStyle(Color(0xFFE84393), Icons.groups),
    'Competition': CategoryStyle(Color(0xFFF39C12), Icons.emoji_events),
    'Sports': CategoryStyle(Color(0xFFD63031), Icons.sports_basketball),
  };

  /// All selectable categories, in display order (with "All" first).
  static const List<String> categories = [
    'All',
    'Tech Talk',
    'Seminar',
    'Workshop',
    'Debate',
    'Science Fair',
    'Club Activity',
    'Competition',
    'Sports',
  ];

  /// Look up the style for a category, falling back to a neutral default.
  static CategoryStyle of(String category) =>
      _map[category] ?? const CategoryStyle(Color(0xFF636E72), Icons.event);
}
