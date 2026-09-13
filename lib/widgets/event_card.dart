import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../providers/favorites_provider.dart';

/// A card that displays an event summary.
/// [featured] makes the card taller (hero banner style).
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: featured
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: featured ? 6 : 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image with Hero ─────────────────────────────────────────────
            Hero(
              tag: 'event_image_${event.id}',
              child: CachedNetworkImage(
                imageUrl: event.imageUrl,
                height: featured ? 200 : 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: featured ? 200 : 140,
                  color: colorScheme.surfaceVariant,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: featured ? 200 : 140,
                  color: colorScheme.surfaceVariant,
                  child: Icon(Icons.event,
                      size: 60, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),

            // ── Info ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: featured ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Date + venue row
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(event.formattedDate,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined,
                          size: 13, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.venue,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
