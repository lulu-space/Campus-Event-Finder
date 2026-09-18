import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../screens/event_details_screen.dart';
import '../screens/main_screen.dart';
import '../screens/register_screen.dart';

/// Named routes from the course work plan (Home → Details → Register).
class AppRoutes {
  static const home = '/';
  static const details = '/event';
  static const register = '/register';
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const MainScreen(),
      );
    case AppRoutes.details:
      final event = settings.arguments as Event;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => EventDetailsScreen(event: event),
      );
    case AppRoutes.register:
      final event = settings.arguments as Event;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => RegisterScreen(event: event),
      );
  }
  return null;
}
