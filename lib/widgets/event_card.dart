import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../providers/favorites_provider.dart';
import 'event_poster.dart';

/// Event poster card. Featured cards use a full-bleed image with Aura overlay.
class EventCard extends StatelessWidget {
  final Event event;
  final bool featured;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return featured ? _FeaturedCard(event: event, onTap: onTap) : _RowCard(event: event, onTap: onTap);
  }
}

class _FeaturedCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _FeaturedCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(event.id);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.22),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'event_image_${event.id}',
                    child: EventPoster(
                      imageUrl: event.imageUrl,
                      fit: BoxFit.cover,
                      iconSize: 64,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x330B0B14),
                          Color(0x000B0B14),
                          Color(0xE60B0B14),
                        ],
                        stops: [0, 0.35, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _FavoriteButton(
                      isFav: isFav,
                      onPressed: () => context.read<FavoritesProvider>().toggle(event),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryPill(label: event.category, onImage: true),
                        const SizedBox(height: 10),
                        Text(
                          event.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Color(0x990B0B14),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${event.formattedDate}  ·  ${event.venue}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xD9FFFFFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _RowCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(event.id);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Material(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Hero(
                  tag: 'event_image_${event.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: EventPoster(
                      imageUrl: event.imageUrl,
                      width: 92,
                      height: 92,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryPill(label: event.category, onImage: false),
                        const SizedBox(height: 6),
                        Text(
                          event.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${event.formattedDate}  ·  ${event.venue}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                _FavoriteButton(
                  isFav: isFav,
                  onPressed: () => context.read<FavoritesProvider>().toggle(event),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool onImage;

  const _CategoryPill({required this.label, required this.onImage});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: onImage
            ? const Color(0xCC7C6CF0)
            : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: onImage ? Colors.white : scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFav;
  final VoidCallback onPressed;

  const _FavoriteButton({required this.isFav, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? const Color(0xFFFF6B8A) : Colors.white,
      ),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0x660B0B14),
        foregroundColor: Colors.white,
      ),
    );
  }
}
