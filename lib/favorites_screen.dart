import 'package:flutter/material.dart';
import 'prayer.dart';
import 'prayer_screen.dart';
import 'gita_screen.dart';
import 'profile.dart';
import 'state.dart';
import 'i18n.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

// A heart toggle for saving/unsaving an item by its id.
class FavoriteButton extends StatelessWidget {
  final String id;
  final Color color;
  const FavoriteButton({super.key, required this.id, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favorites,
      builder: (context, favs, _) {
        final isFav = favs.contains(id);
        return IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: color),
          tooltip: isFav ? 'Remove from saved' : 'Save',
          onPressed: () => Profile.toggleFavorite(id),
        );
      },
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text(t('saved')),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: favorites,
        builder: (context, favs, _) {
          if (favs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Nothing saved yet.\n\nTap the heart on any prayer or Gita verse to keep it here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
                ),
              ),
            );
          }
          final prayerFavs = favs.where((f) => f.startsWith('prayer:')).toList();
          final gitaFavs = favs.where((f) => f.startsWith('gita:')).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              if (prayerFavs.isNotEmpty) ...[
                const _Header('Prayers'),
                for (final id in prayerFavs) _prayerTile(context, id),
                const SizedBox(height: 12),
              ],
              if (gitaFavs.isNotEmpty) ...[
                const _Header('Gita verses'),
                for (final id in gitaFavs) _gitaTile(context, id),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _prayerTile(BuildContext context, String id) {
    final title = id.substring('prayer:'.length);
    final matches = samplePrayers.where((p) => p.title == title);
    if (matches.isEmpty) return const SizedBox.shrink();
    final p = matches.first;
    return _tile(
      leadingText: null,
      icon: Icons.self_improvement,
      title: p.title,
      subtitle: p.deity,
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PrayerScreen(prayer: p))),
    );
  }

  Widget _gitaTile(BuildContext context, String id) {
    final ref = id.substring('gita:'.length); // "C.V"
    final parts = ref.split('.');
    if (parts.length != 2) return const SizedBox.shrink();
    final chapter = int.tryParse(parts[0]);
    final verse = int.tryParse(parts[1]);
    if (chapter == null || verse == null) return const SizedBox.shrink();
    final verses = versesForChapter(chapter);
    final index = verses.indexWhere((v) => v.verse == verse);
    if (index < 0) return const SizedBox.shrink();
    final v = verses[index];
    return _tile(
      leadingText: '$chapter.$verse',
      icon: null,
      title: v.inShort.isNotEmpty ? v.inShort : 'Bhagavad Gita $chapter.$verse',
      subtitle: 'Bhagavad Gita $chapter.$verse',
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => GitaVerseScreen(chapter: chapter, index: index))),
    );
  }

  Widget _tile({
    String? leadingText,
    IconData? icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: _saffron.withValues(alpha: 0.22)),
          ),
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: _saffron.withValues(alpha: 0.15),
            child: leadingText != null
                ? Text(leadingText,
                    style: const TextStyle(color: _saffron, fontWeight: FontWeight.bold, fontSize: 12))
                : Icon(icon, color: _saffron, size: 20),
          ),
          title: Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
          subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.chevron_right, color: _saffron),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
      );
}
