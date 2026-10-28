import 'package:flutter/material.dart';
import 'prayer.dart';
import 'prayer_screen.dart';
import 'deity_screen.dart';
import 'gita_screen.dart';
import 'mood_screen.dart';
import 'reflection.dart';
import 'share_card_screen.dart';
import 'favorites_screen.dart';
import 'panchang_screen.dart';
import 'i18n.dart';
import 'language_screen.dart';
import 'theme.dart';
import 'onboarding.dart';
import 'profile.dart';
import 'state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Profile.init();
  runApp(const DiyaApp());
}

// Diya's warm devotional palette.
const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);

class DiyaApp extends StatelessWidget {
  const DiyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diya',
      debugShowCheckedModeBanner: false,
      theme: buildDiyaTheme(),
      home: ValueListenableBuilder<AppLang>(
        valueListenable: currentLang,
        builder: (context, _, _) =>
            Profile.onboarded ? const RootPage() : const OnboardingScreen(),
      ),
    );
  }
}

// The main screen with the five bottom-nav tabs.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_tab) {
        0 => const HomeTab(),
        1 => const PrayersTab(),
        3 => const VidyaTab(),
        4 => const PanchangTab(),
        _ => ComingSoon(name: t('tab_playlists')),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: Colors.white,
        indicatorColor: _saffron.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.wb_sunny_outlined), label: t('tab_home')),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), label: t('tab_prayers')),
          NavigationDestination(icon: const Icon(Icons.playlist_play), label: t('tab_playlists')),
          NavigationDestination(icon: const Icon(Icons.auto_stories_outlined), label: t('tab_vidya')),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: t('tab_panchang')),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          // Greeting + profile dot (tap the dot to choose your deity).
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('good_morning'), style: const TextStyle(fontSize: 15, color: Colors.black54)),
                  const SizedBox(height: 2),
                  const Text('Diya',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _maroon)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LanguagePickerScreen()),
                    ),
                    icon: const Icon(Icons.language, color: _maroon),
                    tooltip: 'Language',
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                    ),
                    icon: const Icon(Icons.favorite_border, color: _maroon),
                    tooltip: 'Saved',
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DeityPickerScreen()),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: _saffron,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Streak card.
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_maroon, deepMaroon],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: cardShadow,
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: _saffron, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: streakCount,
                        builder: (context, count, _) => Text(
                          '$count day${count == 1 ? '' : 's'} streak',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text('Keep the light burning',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Verse of the day — tap to open a shareable card.
          _verseOfDayCard(context),
          const SizedBox(height: 24),

          // Explore by deity — tap a face to see that deity's prayers.
          _SectionTitle(t('explore_deity')),
          const SizedBox(height: 12),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final d in deities)
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: DeityCircle(
                      deity: d,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DeityScreen(deity: d)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Today's prayer — follows your chosen deity if you've picked one.
          _SectionTitle(t('todays_prayer')),
          const SizedBox(height: 10),
          ValueListenableBuilder<String?>(
            valueListenable: favouriteDeity,
            builder: (context, fav, _) {
              final forDeity = (fav != null) ? prayersForDeity(fav) : const <Prayer>[];
              final prayer = forDeity.isNotEmpty ? forDeity.first : samplePrayers[0];
              return _PrayerCard(
                prayer: prayer,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PrayerScreen(prayer: prayer)),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Mood picker.
          _SectionTitle(t('how_feeling')),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _MoodChip('Grateful'),
              _MoodChip('Anxious'),
              _MoodChip('Peaceful'),
              _MoodChip('Grieving'),
              _MoodChip('Hopeful'),
            ],
          ),
          const SizedBox(height: 24),

          // Playlists.
          _SectionTitle(t('for_your_day')),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _PlaylistCard('Morning', Icons.wb_twilight),
                _PlaylistCard('Focus', Icons.center_focus_strong),
                _PlaylistCard('Travel', Icons.directions_car),
                _PlaylistCard('Sleep', Icons.nightlight_round),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// The Prayers tab: a scrollable list of every prayer, each opening the
// full 4-layer screen when tapped.
class PrayersTab extends StatelessWidget {
  const PrayersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text(t('prayers_title'),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 16),
          Text(t('find_mantra_for'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in goalCategories)
                ActionChip(
                  label: Text(g),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: _saffron.withValues(alpha: 0.4)),
                  labelStyle: const TextStyle(color: _maroon),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PrayerCollectionScreen(
                      title: g,
                      subtitle: 'Mantras for $g',
                      prayers: prayersForGoal(g),
                    ),
                  )),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(t('all_mantras'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          for (final p in samplePrayers)
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
                  subtitle: Text(p.deity, style: const TextStyle(color: Colors.black54)),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon));
}

class _PrayerCard extends StatelessWidget {
  final Prayer prayer;
  final VoidCallback onTap;
  const _PrayerCard({required this.prayer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _saffron.withValues(alpha: 0.35)),
          boxShadow: cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: _saffron.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.self_improvement, color: _saffron, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prayer.title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _maroon)),
                  const SizedBox(height: 3),
                  Text(prayer.context,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill, color: _saffron, size: 40),
          ],
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String label;
  const _MoodChip(this.label);
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: _saffron.withValues(alpha: 0.4)),
      labelStyle: const TextStyle(color: _maroon),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PrayerCollectionScreen(
            title: 'Feeling $label',
            subtitle: 'A few prayers that may help.',
            prayers: prayersForMood(label),
          ),
        ),
      ),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PlaylistCard(this.label, this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: _saffron, size: 28),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
        ],
      ),
    );
  }
}

// The "verse of the day" card on Home. Tapping opens the shareable card.
Widget _verseOfDayCard(BuildContext context) {
  final item = verseOfTheDay();
  return InkWell(
    onTap: () => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => VerseCardScreen(item: item))),
    borderRadius: BorderRadius.circular(18),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _saffron.withValues(alpha: 0.35)),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: _saffron, size: 18),
              const SizedBox(width: 6),
              Text(t('verse_of_day'),
                  style: const TextStyle(color: _saffron, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text('“${item.quote}”',
              style: const TextStyle(fontSize: 16, color: _maroon, height: 1.4)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(item.source,
                    style: const TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic)),
              ),
              Row(
                children: const [
                  Icon(Icons.share, color: _saffron, size: 16),
                  SizedBox(width: 4),
                  Text('Share',
                      style: TextStyle(color: _saffron, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ComingSoon extends StatelessWidget {
  final String name;
  const ComingSoon({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: _saffron, size: 40),
          const SizedBox(height: 12),
          Text('$name\ncoming soon',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: _maroon, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
