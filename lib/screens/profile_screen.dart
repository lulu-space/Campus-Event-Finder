import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/language_provider.dart';
import '../providers/registered_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;
    final theme = context.watch<ThemeProvider>();
    final favCount = context.watch<FavoritesProvider>().count;
    final regCount = context.watch<RegisteredProvider>().registered.length;

    return Scaffold(
      appBar: AppBar(title: Text(t('profile')), centerTitle: true),
      body: ListView(
        children: [
          // ── Stats ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    child: _StatCard(
                  icon: Icons.favorite,
                  value: favCount,
                  label: t('favorites'),
                  color: const Color(0xFFFF6B8A),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _StatCard(
                  icon: Icons.event_available,
                  value: regCount,
                  label: t('my_events'),
                  color: const Color(0xFF2DD4BF),
                )),
              ],
            ),
          ),

          const Divider(),

          // ── Dark mode ──────────────────────────────────────────────────
          SwitchListTile(
            secondary: Icon(
                theme.isDark ? Icons.dark_mode : Icons.light_mode),
            title: Text(t('dark_mode')),
            value: theme.isDark,
            onChanged: (_) => context.read<ThemeProvider>().toggle(),
          ),

          const Divider(),

          // ── Language ───────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t('language')),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LangButton(
                  label: 'EN',
                  selected: !lang.isArabic,
                  onTap: () {
                    if (lang.isArabic) {
                      context.read<LanguageProvider>().toggle();
                    }
                  },
                ),
                const SizedBox(width: 8),
                _LangButton(
                  label: 'ع',
                  selected: lang.isArabic,
                  onTap: () {
                    if (!lang.isArabic) {
                      context.read<LanguageProvider>().toggle();
                    }
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // ── App info ───────────────────────────────────────────────────
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Campus Event Finder'),
            subtitle: Text('v1.0.0 · Layan Diab · Al-Quds Abu Dis'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;

  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final fill = Color.alphaBlend(
      color.withValues(alpha: isDark ? 0.18 : 0.10),
      isDark ? const Color(0xFF14141C) : const Color(0xFFFFFBFF),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: fill,
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.4),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(value.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
