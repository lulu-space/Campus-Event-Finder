import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/event_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/language_provider.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../widgets/event_poster.dart';
import '../navigation/app_routes.dart';

const _circleIconStyle = ButtonStyle(
  visualDensity: VisualDensity.compact,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  minimumSize: WidgetStatePropertyAll(Size.square(40)),
  maximumSize: WidgetStatePropertyAll(Size.square(40)),
  padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
  iconSize: WidgetStatePropertyAll(20),
  fixedSize: WidgetStatePropertyAll(Size.square(40)),
);

class _CircleAppBarButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _CircleAppBarButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton.filledTonal(
          style: _circleIconStyle,
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      ),
    );
  }
}

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event _event;
  bool _loadingDetails = true;
  String? _detailsError;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _loadingDetails = true;
      _detailsError = null;
    });
    try {
      final fresh = await ApiService.fetchEvent(widget.event.id);
      if (!mounted) return;
      setState(() {
        _event = fresh;
        _loadingDetails = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingDetails = false;
        _detailsError = error is ApiException
            ? error.message
            : context.read<LanguageProvider>().t('error_network');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(_event.id);
    final colorScheme = Theme.of(context).colorScheme;
    // Keep the Hero tag and cover on the list image so the animation matches.
    final heroImageUrl = widget.event.imageUrl.isNotEmpty
        ? widget.event.imageUrl
        : _event.imageUrl;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            leadingWidth: 56,
            leading: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: _CircleAppBarButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () => Navigator.maybePop(context),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: _CircleAppBarButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFav ? const Color(0xFFFF6B8A) : null,
                  ),
                  onPressed: () =>
                      context.read<FavoritesProvider>().toggle(_event),
                  tooltip: t('favorites'),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'event_image_${widget.event.id}',
                    child: EventPoster(
                      imageUrl: heroImageUrl,
                      fit: BoxFit.cover,
                      iconSize: 80,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x660B0B14),
                          Color(0x000B0B14),
                          Color(0xCC0B0B14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_loadingDetails)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(t('loading_details'),
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  if (_detailsError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _detailsError!,
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                          TextButton(
                            onPressed: _loadDetails,
                            child: Text(t('retry')),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_event.category,
                        style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _event.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(
                      icon: Icons.calendar_today,
                      label: t('date'),
                      value: _event.formattedDate),
                  _InfoRow(
                      icon: Icons.access_time,
                      label: t('time'),
                      value: _event.formattedTime),
                  _InfoRow(
                      icon: Icons.location_on,
                      label: t('venue'),
                      value: _event.venue),
                  if (_event.city.isNotEmpty)
                    _InfoRow(
                        icon: Icons.location_city,
                        label: t('city'),
                        value: _event.city),
                  if (_event.info != null && _event.info!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(_event.info!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.register,
                          arguments: _event,
                        );
                      },
                      icon: const Icon(Icons.app_registration),
                      label: Text(t('register')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_event.ticketUrl.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(_event.ticketUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: Text(t('get_tickets')),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 10),
          Text('$label: ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                  )),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
