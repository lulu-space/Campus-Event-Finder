import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/local_storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Event> _favorites = [];

  List<Event> get favorites => List.unmodifiable(_favorites);
  int get count => _favorites.length;

  bool isFavorite(String eventId) =>
      _favorites.any((e) => e.id == eventId);

  Future<void> load() async {
    _favorites = await LocalStorageService.loadFavorites();
    notifyListeners();
  }

  Future<void> toggle(Event event) async {
    if (isFavorite(event.id)) {
      _favorites.removeWhere((e) => e.id == event.id);
    } else {
      _favorites.add(event);
    }
    await LocalStorageService.saveFavorites(_favorites);
    notifyListeners();
  }
}
