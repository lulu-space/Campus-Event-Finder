import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/event_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/language_provider.dart';
import '../theme/category_style.dart';
import '../widgets/event_card.dart';
import 'register_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(event.id);
    final style = CategoryStyle.of(event.category);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.redAccent : Colors.white,
                onPressed: () =>
                    context.read<FavoritesProvider>().toggle(event),
                tooltip: t('favorites'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: EventBanner(event: event, height: 240),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoryChip(style: style, label: event.category),
                  const SizedBox(height: 12),
                  Text(
                    event.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(
                      icon: Icons.calendar_today,
                      label: t('date'),
                      value: event.formattedDate,
                      color: style.color),
                  _InfoRow(
                      icon: Icons.access_time,
                      label: t('time'),
                      value: event.formattedTime,
                      color: style.color),
                  _InfoRow(
                      icon: Icons.place,
                      label: t('location'),
                      value: event.location,
                      color: style.color),
                  if (event.organizer.isNotEmpty)
                    _InfoRow(
                        icon: Icons.groups,
                        label: t('organizer'),
                        value: event.organizer,
                        color: style.color),
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(t('about'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(event.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: style.color,
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegisterScreen(event: event)),
                        );
                      },
                      icon: const Icon(Icons.app_registration),
                      label: Text(t('register')),
                    ),
                  ),
                  if (event.registrationUrl != null &&
                      event.registrationUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(event.registrationUrl!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: Text(t('register_link')),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryStyle style;
  final String label;

  const _CategoryChip({required this.style, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 16, color: style.color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: style.color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
