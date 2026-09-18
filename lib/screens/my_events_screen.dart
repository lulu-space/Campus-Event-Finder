import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/app_routes.dart';
import '../providers/language_provider.dart';
import '../providers/registered_provider.dart';
import '../widgets/event_poster.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;
    final registered = context.watch<RegisteredProvider>().registered;

    return Scaffold(
      appBar: AppBar(title: Text(t('my_events')), centerTitle: true),
      body: registered.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    t('no_registered'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: registered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final event = registered[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: EventPoster(
                        imageUrl: event.imageUrl,
                        width: 72,
                        height: 72,
                      ),
                    ),
                    title: Text(event.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                        '${event.formattedDate}  •  ${event.venue}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.secondary),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.details,
                      arguments: event,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
