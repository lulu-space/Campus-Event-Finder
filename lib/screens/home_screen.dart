import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../providers/language_provider.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

const List<String> _categories = [
  'All',
  'Music',
  'Sports',
  'Arts & Theatre',
  'Film',
  'Miscellaneous',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Event>> _eventsFuture;
  final _searchController = TextEditingController();
  final _cityController = TextEditingController(text: 'London');
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String get _city =>
      _cityController.text.trim().isEmpty ? 'London' : _cityController.text.trim();

  String? get _keyword {
    final value = _searchController.text.trim();
    return value.isEmpty ? null : value;
  }

  void _load({String? keyword, String? category}) {
    setState(() {
      _eventsFuture = ApiService.fetchEvents(
        keyword: keyword ?? _keyword,
        city: _city,
        category: (category ?? _selectedCategory) == 'All'
            ? null
            : (category ?? _selectedCategory),
      );
    });
  }

  void _onSearch([String? _]) => _load();

  void _onCategoryTap(String cat) {
    setState(() => _selectedCategory = cat);
    _load(category: cat);
  }

  void _openDetails(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => EventDetailsScreen(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('app_title')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSearch,
                  decoration: InputDecoration(
                    hintText: t('search_hint'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _cityController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSearch,
                  decoration: InputDecoration(
                    hintText: t('city_hint'),
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                ),
              ],
            ),
          ),

          // ── Category chips ───────────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final label = cat == 'All' ? t('all') : cat;
                final selected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => _onCategoryTap(cat),
                );
              },
            ),
          ),

          // ── Event list ───────────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  final msg = snapshot.error is ApiException
                      ? snapshot.error.toString()
                      : t('error_network');
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, size: 48),
                          const SizedBox(height: 12),
                          Text(msg, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _load,
                            icon: const Icon(Icons.refresh),
                            label: Text(t('retry')),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final events = snapshot.data ?? [];

                if (events.isEmpty) {
                  return Center(
                    child: Text(t('no_events'),
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    if (index == 0) {
                      // First card = featured (bigger)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: Text(
                              t('featured'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          EventCard(
                            event: event,
                            featured: true,
                            onTap: () => _openDetails(context, event),
                          ),
                          if (events.length > 1)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 16, 4),
                              child: Text(
                                t('upcoming'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      );
                    }

                    return EventCard(
                      event: event,
                      onTap: () => _openDetails(context, event),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
