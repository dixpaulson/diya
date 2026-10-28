import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'festivals.dart';
import 'i18n.dart';
import 'locations.dart';
import 'panchang.dart';
import 'state.dart';
import 'weekday.dart';

const _saffron = Color(0xFFEB7A1D);
const _maroon = Color(0xFF6E1E1E);
const _cream = Color(0xFFFDF6EC);

const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];
const _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _formatDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
String _formatDateShort(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

String _formatTime(DateTime local) {
  final m = local.minute.toString().padLeft(2, '0');
  final ampm = local.hour >= 12 ? 'PM' : 'AM';
  var hh = local.hour % 12;
  if (hh == 0) hh = 12;
  return '$hh:$m $ampm';
}

String _relativeDays(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day).difference(today).inDays;
  if (d == 0) return 'Today';
  if (d == 1) return 'Tomorrow';
  return 'in $d days';
}

class PanchangTab extends StatelessWidget {
  const PanchangTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text(t('panchang_title'),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 4),
          Text(_formatDate(now), style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),
          _WeekdayCard(),
          const SizedBox(height: 14),
          ValueListenableBuilder<String?>(
            valueListenable: selectedCityName,
            builder: (context, cityName, _) {
              final city = cityByName(cityName);
              return Column(
                children: [
                  _LocationCard(city: city),
                  if (city != null) ...[
                    const SizedBox(height: 14),
                    _SunCard(now: now, city: city),
                    const SizedBox(height: 14),
                    _AuspiciousCard(now: now, city: city),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text('Festivals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 10),
          _FestivalPeek(),
          const SizedBox(height: 16),
          const Text(
            'Festival dates and timings follow the traditional calendar and can vary slightly by region — please verify locally for anything important.',
            style: TextStyle(color: Colors.black45, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final City? city;
  const _LocationCard({required this.city});

  @override
  Widget build(BuildContext context) {
    final set = city != null;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _saffron.withValues(alpha: set ? 0.35 : 0.5)),
        ),
        leading: const Icon(Icons.place_outlined, color: _saffron),
        title: Text(set ? '${city!.name}, ${city!.country}' : 'Set your city',
            style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
        subtitle: Text(set ? 'Sunrise and times are for this city' : 'Needed for sunrise and auspicious times',
            style: const TextStyle(color: Colors.black54)),
        trailing: Text(set ? 'Change' : 'Choose',
            style: const TextStyle(color: _saffron, fontWeight: FontWeight.bold)),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const LocationPickerScreen())),
      ),
    );
  }
}

class _SunCard extends StatelessWidget {
  final DateTime now;
  final City city;
  const _SunCard({required this.now, required this.city});

  @override
  Widget build(BuildContext context) {
    final sun = computeSunTimes(now, city.lat, city.lng);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _saffron.withValues(alpha: 0.25)),
      ),
      child: sun.valid
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sun(Icons.wb_twilight, 'Sunrise', _formatTime(sun.sunrise!.toLocal())),
                Container(width: 1, height: 40, color: Colors.black12),
                _sun(Icons.nightlight_round, 'Sunset', _formatTime(sun.sunset!.toLocal())),
              ],
            )
          : const Text('The sun does not rise or set today at this location.',
              style: TextStyle(color: Colors.black54)),
    );
  }

  Widget _sun(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: _saffron, size: 26),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }
}

class _AuspiciousCard extends StatelessWidget {
  final DateTime now;
  final City city;
  const _AuspiciousCard({required this.now, required this.city});

  @override
  Widget build(BuildContext context) {
    final periods = inauspiciousPeriods(now, city.lat, city.lng);
    if (periods.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _saffron.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Times to avoid today',
              style: TextStyle(fontWeight: FontWeight.bold, color: _maroon, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('Traditionally not chosen for starting new things.',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 12),
          for (final p in periods)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(p.name, style: const TextStyle(color: _maroon)),
                  Text('${_formatTime(p.start.toLocal())} – ${_formatTime(p.end.toLocal())}',
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FestivalPeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final next = nextFestival();
    return Column(
      children: [
        if (next != null)
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: _saffron.withValues(alpha: 0.35)),
              ),
              leading: const Icon(Icons.celebration_outlined, color: _saffron),
              title: Text(next.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
              subtitle: Text('${_formatDateShort(next.date)}  ·  ${_relativeDays(next.date)}',
                  style: const TextStyle(color: Colors.black54)),
              trailing: const Icon(Icons.chevron_right, color: _saffron),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FestivalDetailScreen(festival: next))),
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const FestivalListScreen())),
            child: const Text('See all festivals'),
          ),
        ),
      ],
    );
  }
}

class _WeekdayCard extends StatelessWidget {
  String get _shareText {
    final info = weekdayToday();
    return '${weekdayName()} — day of ${info.deity}\n\n${info.significance}\n\nToday’s mantra: ${info.mantra}\n\nvia Diya';
  }

  @override
  Widget build(BuildContext context) {
    final info = weekdayToday();
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 8, 18),
      decoration: BoxDecoration(
        color: _saffron.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _saffron.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.brightness_low, color: _saffron, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text('${weekdayName()} · day of ${info.deity}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon, fontSize: 16)),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: _saffron, size: 20),
                tooltip: 'Share',
                onPressed: () => SharePlus.instance.share(ShareParams(text: _shareText)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.significance,
                    style: const TextStyle(color: Colors.black87, height: 1.5, fontSize: 14)),
                const SizedBox(height: 12),
                for (final t in info.whatToDo)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, color: _saffron, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(t, style: const TextStyle(color: Colors.black87))),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _saffron.withValues(alpha: 0.3)),
                  ),
                  child: Text('Mantra · ${info.mantra}',
                      style: const TextStyle(color: _maroon, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Choose your city'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          const Text('Pick the city you live in. (Using your GPS location is coming soon.)',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 14),
          for (final c in cityList)
            ValueListenableBuilder<String?>(
              valueListenable: selectedCityName,
              builder: (context, current, _) {
                final selected = current == c.name;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: selected ? _maroon : _saffron.withValues(alpha: 0.2),
                            width: selected ? 2 : 1),
                      ),
                      title: Text(c.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
                      subtitle: Text(c.country, style: const TextStyle(color: Colors.black54)),
                      trailing: selected ? const Icon(Icons.check_circle, color: _maroon) : null,
                      onTap: () {
                        selectedCityName.value = c.name;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class FestivalListScreen extends StatelessWidget {
  const FestivalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = upcomingFestivals();
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: const Text('Festivals'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          for (final f in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: _saffron.withValues(alpha: 0.25)),
                  ),
                  leading: const Icon(Icons.celebration_outlined, color: _saffron),
                  title: Text(f.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: _maroon)),
                  subtitle: Text('${_formatDateShort(f.date)}  ·  ${_relativeDays(f.date)}',
                      style: const TextStyle(color: Colors.black54)),
                  trailing: const Icon(Icons.chevron_right, color: _saffron),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => FestivalDetailScreen(festival: f))),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FestivalDetailScreen extends StatelessWidget {
  final Festival festival;
  const FestivalDetailScreen({super.key, required this.festival});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        title: Text(festival.name),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Row(
            children: [
              const Icon(Icons.brightness_low, color: _saffron, size: 20),
              const SizedBox(width: 6),
              Text(festival.deity,
                  style: const TextStyle(color: _saffron, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Text('${_formatDateShort(festival.date)}  ·  ${_relativeDays(festival.date)}',
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Text(festival.blurb,
              style: const TextStyle(fontSize: 17, color: _maroon, fontWeight: FontWeight.w500, height: 1.4)),
          const SizedBox(height: 20),
          const Text('How to observe',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _maroon)),
          const SizedBox(height: 8),
          Text(festival.howToObserve,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
          const SizedBox(height: 20),
          const Text('Dates can vary slightly by region — verify locally.',
              style: TextStyle(color: Colors.black45, fontSize: 12)),
        ],
      ),
    );
  }
}
