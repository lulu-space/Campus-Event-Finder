import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../theme/category_style.dart';

/// A card that displays a campus event summary.
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
    final style = CategoryStyle.of(event.category);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: featured ? 8 : 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: featured ? 5 : 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventBanner(event: event, height: featured ? 150 : 110),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _IconLine(
                    icon: Icons.calendar_today_outlined,
                    text: '${event.formattedDate}  ·  ${event.formattedTime}',
                    color: style.color,
                  ),
                  const SizedBox(height: 4),
                  _IconLine(
                    icon: Icons.place_outlined,
                    text: event.location,
                    color: style.color,
                  ),
                  if (event.organizer.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _IconLine(
                      icon: Icons.groups_outlined,
                      text: event.organizer,
                      color: style.color,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The color-coded header for an event. Shows the event image if one is
/// provided, otherwise a category gradient with the category icon and label.
class EventBanner extends StatelessWidget {
  final Event event;
  final double height;

  const EventBanner({super.key, required this.event, required this.height});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(event.category);

    return Hero(
      tag: 'event_image_${event.id}',
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: event.imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: event.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => _gradient(style),
                errorWidget: (_, __, ___) => _gradient(style, showIcon: true),
              )
            : _gradient(style, showIcon: true),
      ),
    );
  }

  Widget _gradient(CategoryStyle style, {bool showIcon = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            style.color,
            Color.lerp(style.color, Colors.black, 0.35) ?? style.color,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -12,
            child: Icon(style.icon,
                size: 110, color: Colors.white.withValues(alpha: 0.18)),
          ),
          Positioned(
            left: 14,
            top: 14,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(style.icon, size: 15, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    event.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _IconLine({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
