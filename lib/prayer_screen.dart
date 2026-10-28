import 'package:flutter/material.dart';
import 'prayer.dart';
import 'favorites_screen.dart';
import 'jaap_screen.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

// The full prayer view: for each line we show the script, the pronunciation,
// and the meaning — plus a plain-English summary and the reason to chant it.
class PrayerScreen extends StatelessWidget {
  final Prayer prayer;
  const PrayerScreen({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text(prayer.title),
        actions: [FavoriteButton(id: 'prayer:${prayer.title}')],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          // Deity + context.
          Row(
            children: [
              const Icon(Icons.brightness_low, color: _saffron, size: 20),
              const SizedBox(width: 6),
              Text(prayer.deity,
                  style: const TextStyle(color: _saffron, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Text(prayer.context, style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.4)),
          const SizedBox(height: 18),

          // "In short" — a warm paraphrase, the emotional heart for newcomers.
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _saffron.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _saffron.withValues(alpha: 0.30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb_outline, color: _saffron, size: 18),
                    SizedBox(width: 6),
                    Text('In short',
                        style: TextStyle(color: _saffron, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(prayer.inShort,
                    style: const TextStyle(
                        fontSize: 16, color: _maroon, height: 1.5, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Play button (audio comes later).
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: _saffron,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio coming soon 🎧')),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play & chant along'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: _maroon,
              side: BorderSide(color: _saffron.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => JaapScreen(
                title: prayer.title,
                lines: prayer.lines,
              ),
            )),
            icon: const Icon(Icons.radio_button_checked),
            label: const Text('Count jaap (108)'),
          ),
          const SizedBox(height: 24),

          // One card per line, showing all three layers.
          for (final line in prayer.lines) _LineCard(line: line),

          const SizedBox(height: 8),

          // "Why we chant this" — the traditional + psychological reason.
          Row(
            children: const [
              Icon(Icons.self_improvement, color: _saffron, size: 22),
              SizedBox(width: 6),
              Text('Why we chant this',
                  style: TextStyle(color: _maroon, fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
          const SizedBox(height: 8),
          Text(prayer.whyWeChant,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}

class _LineCard extends StatelessWidget {
  final PrayerLine line;
  const _LineCard({required this.line});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _saffron.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layer 1: the script.
          Text(line.native,
              style: const TextStyle(fontSize: 22, color: _maroon, height: 1.5, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          // Layer 2: how to say it.
          Text(line.transliteration,
              style: const TextStyle(fontSize: 16, color: _saffron, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Layer 3: what it means.
          Text(line.meaning, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
        ],
      ),
    );
  }
}
