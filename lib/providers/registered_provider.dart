import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/local_storage_service.dart';

class RegisteredProvider extends ChangeNotifier {
  List<Event> _registered = [];

  List<Event> get registered => List.unmodifiable(_registered);

  bool isRegistered(String eventId) =>
      _registered.any((e) => e.id == eventId);

  Future<void> load() async {
    _registered = await LocalStorageService.loadRegistered();
    notifyListeners();
  }

  Future<void> register(Event event) async {
    if (!isRegistered(event.id)) {
      _registered.add(event);
      await LocalStorageService.saveRegistered(_registered);
      notifyListeners();
    }
  }

  Future<void> unregister(String eventId) async {
    _registered.removeWhere((e) => e.id == eventId);
    await LocalStorageService.saveRegistered(_registered);
    notifyListeners();
  }
}
