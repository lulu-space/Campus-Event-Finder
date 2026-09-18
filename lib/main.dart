import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/app_routes.dart';
import 'providers/favorites_provider.dart';
import 'providers/language_provider.dart';
import 'providers/registered_provider.dart';
import 'providers/theme_provider.dart';
import 'services/database_init.dart';
import 'services/local_storage_service.dart';
import 'theme/app_theme.dart';
import 'widgets/aura_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLocalDatabase();
  await LocalStorageService.migrateLegacyListsIfNeeded();

  final themeProvider = ThemeProvider();
  final languageProvider = LanguageProvider();
  final favoritesProvider = FavoritesProvider();
  final registeredProvider = RegisteredProvider();

  await Future.wait([
    themeProvider.load(),
    languageProvider.load(),
    favoritesProvider.load(),
    registeredProvider.load(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: favoritesProvider),
        ChangeNotifierProvider.value(value: registeredProvider),
      ],
      child: const CampusEventFinderApp(),
    ),
  );
}

class CampusEventFinderApp extends StatelessWidget {
  const CampusEventFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final locale = context.watch<LanguageProvider>().locale;

    return MaterialApp(
      title: 'Campus Event Finder',
      debugShowCheckedModeBanner: false,
      locale: locale,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      builder: (context, child) =>
          AuraBackground(child: child ?? const SizedBox()),
      initialRoute: AppRoutes.home,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
