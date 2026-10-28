import 'package:flutter/material.dart';
import 'prayer.dart';
import 'prayer_screen.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

// A titled list of prayers — used for mood results and goal/need results.
class PrayerCollectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Prayer> prayers;
  const PrayerCollectionScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.prayers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: prayers.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('More mantras coming soon for this.',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                for (final p in prayers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: _saffron.withValues(alpha: 0.25)),
                        ),
                        leading: const Icon(Icons.self_improvement, color: _saffron),
                        title: Text(p.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
                        subtitle: Text(p.inShort,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54)),
                        trailing: const Icon(Icons.chevron_right, color: _saffron),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PrayerScreen(prayer: p)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
