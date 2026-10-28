import 'package:flutter/material.dart';
import 'prayer.dart';
import 'prayer_screen.dart';
import 'state.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

// A deity the user can follow. `image` points to artwork under
// assets/deities/. If that file isn't there yet, we fall back to `icon`,
// so the app looks fine before you've added the real pictures.
class Deity {
  final String name;
  final IconData icon;
  final String image;
  final String tagline;
  const Deity({
    required this.name,
    required this.icon,
    required this.image,
    required this.tagline,
  });
}

const deities = <Deity>[
  Deity(name: 'Surya', icon: Icons.wb_sunny, image: 'assets/deities/surya.jpg', tagline: 'The Sun, source of light'),
  Deity(name: 'Ganesha', icon: Icons.auto_awesome, image: 'assets/deities/ganesha.jpg', tagline: 'Remover of obstacles'),
  Deity(name: 'Shiva', icon: Icons.self_improvement, image: 'assets/deities/shiva.jpg', tagline: 'Stillness and transformation'),
  Deity(name: 'Krishna', icon: Icons.music_note, image: 'assets/deities/krishna.jpg', tagline: 'Joy, love, and play'),
  Deity(name: 'Vishnu', icon: Icons.shield, image: 'assets/deities/vishnu.jpg', tagline: 'Preserver and protector'),
  Deity(name: 'Lakshmi', icon: Icons.local_florist, image: 'assets/deities/lakshmi.jpg', tagline: 'Abundance and grace'),
  Deity(name: 'Saraswati', icon: Icons.menu_book, image: 'assets/deities/saraswati.jpg', tagline: 'Knowledge and the arts'),
  Deity(name: 'Durga', icon: Icons.bolt, image: 'assets/deities/durga.jpg', tagline: 'Strength and protection'),
  Deity(name: 'Hanuman', icon: Icons.fitness_center, image: 'assets/deities/hanuman.jpg', tagline: 'Courage and devotion'),
  Deity(name: 'Rama', icon: Icons.brightness_7, image: 'assets/deities/rama.jpg', tagline: 'Virtue and duty'),
];

Deity deityByName(String name) =>
    deities.firstWhere((d) => d.name == name, orElse: () => deities.first);

// A round avatar showing the deity's artwork, or its icon if no image yet.
Widget deityAvatar(Deity d, {double radius = 30}) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: _saffron.withValues(alpha: 0.15),
    child: ClipOval(
      child: Image.asset(
        d.image,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            Icon(d.icon, color: _saffron, size: radius),
      ),
    ),
  );
}

// A round deity avatar with its name — reused on Home and in the picker.
class DeityCircle extends StatelessWidget {
  final Deity deity;
  final VoidCallback onTap;
  const DeityCircle({super.key, required this.deity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          deityAvatar(deity, radius: 30),
          const SizedBox(height: 6),
          // One line, shrunk if needed (long name or large phone text), so it
          // never spills out of the fixed-height deity row on Home.
          SizedBox(
            width: 72,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(deity.name,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12, color: _maroon, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}

// The full grid of deities to browse or choose from.
class DeityPickerScreen extends StatelessWidget {
  const DeityPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Choose your deity'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.5,
        children: [
          for (final d in deities)
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DeityScreen(deity: d)),
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _saffron.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    deityAvatar(d, radius: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(d.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: _maroon, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(d.tagline,
                              style: const TextStyle(fontSize: 11, color: Colors.black54),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
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

// A single deity's page: pick it as your favourite, and see its prayers.
class DeityScreen extends StatelessWidget {
  final Deity deity;
  const DeityScreen({super.key, required this.deity});

  @override
  Widget build(BuildContext context) {
    final prayers = prayersForDeity(deity.name);
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text(deity.name),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Center(
            child: Column(
              children: [
                deityAvatar(deity, radius: 44),
                const SizedBox(height: 12),
                Text(deity.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _maroon)),
                const SizedBox(height: 4),
                Text(deity.tagline, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Make this your deity (or unset it if it already is).
          ValueListenableBuilder<String?>(
            valueListenable: favouriteDeity,
            builder: (context, fav, _) {
              final isFav = fav == deity.name;
              return FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: isFav ? _maroon : _saffron,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  favouriteDeity.value = isFav ? null : deity.name;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFav
                          ? '${deity.name} removed as your deity'
                          : '${deity.name} is now your deity'),
                    ),
                  );
                },
                icon: Icon(isFav ? Icons.star : Icons.star_border),
                label: Text(isFav ? 'Your deity' : 'Make ${deity.name} my deity'),
              );
            },
          ),
          const SizedBox(height: 24),

          const Text('Prayers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          if (prayers.isEmpty)
            const Text('More prayers coming soon.', style: TextStyle(color: Colors.black54)),
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
                  subtitle: Text(p.context,
                      maxLines: 1,
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
