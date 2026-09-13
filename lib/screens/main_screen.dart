import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/language_provider.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'my_events_screen.dart';
import 'profile_screen.dart';

/// Root scaffold: holds the bottom navigation bar and switches between the
/// four main tabs: Home | My Events | Favorites | Profile.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    MyEventsScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;
    final favCount = context.watch<FavoritesProvider>().count;

    return Directionality(
      textDirection: lang.textDirection,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t('home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.event_outlined),
              selectedIcon: const Icon(Icons.event),
              label: t('my_events'),
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: favCount > 0,
                label: Text(favCount.toString()),
                child: const Icon(Icons.favorite_outline),
              ),
              selectedIcon: Badge(
                isLabelVisible: favCount > 0,
                label: Text(favCount.toString()),
                child: const Icon(Icons.favorite),
              ),
              label: t('favorites'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: t('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
